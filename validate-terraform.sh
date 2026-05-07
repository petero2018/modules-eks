#!/bin/bash

ROOT=$(git rev-parse --show-toplevel)

function compare() # $1-a $2-op $3-$b
# Compare a and b as version strings. Rules:
# R1: a and b : dot-separated sequence of items. Items are numeric. The last item can optionally end with letters, i.e., 2.5 or 2.5a.
# R2: Zeros are automatically inserted to compare the same number of items, i.e., 1.0 < 1.0.1 means 1.0.0 < 1.0.1 => yes.
# R3: op can be '=' '==' '!=' '<' '<=' '>' '>=' (lexicographic).
# R4: Unrestricted number of digits of any item, i.e., 3.0003 > 3.0000004.
# R5: Unrestricted number of items.
{
  local comp=($@)
  local a=${comp[0]} op=${comp[1]} b=${comp[2]}
  local al=${a##*.} bl=${b##*.}
  while [[ $al =~ ^[[:digit:]] ]]; do al=${al:1}; done
  while [[ $bl =~ ^[[:digit:]] ]]; do bl=${bl:1}; done
  local ai=${a%$al} bi=${b%$bl}

  local ap=${ai//[[:digit:]]} bp=${bi//[[:digit:]]}
  ap=${ap//./.0} bp=${bp//./.0}

  local w=1 fmt=$a.$b x IFS=.
  for x in $fmt; do [ ${#x} -gt $w ] && w=${#x}; done
  fmt=${*//[^.]}; fmt=${fmt//./%${w}s}
  printf -v a $fmt $ai$bp; printf -v a "%s-%${w}s" $a $al
  printf -v b $fmt $bi$ap; printf -v b "%s-%${w}s" $b $bl

  case $op in
    '<='|'>=' ) [ "$a" ${op:0:1} "$b" ] || [ "$a" = "$b" ] ;;
    * )         [ "$a" $op "$b" ] ;;
  esac
}

get_os() {
    uname -s | tr '[:upper:]' '[:lower:]'
}

get_arch() {
    arch=$(uname -m)
    if [ $arch == "x86_64" ]; then
        echo "amd64"
    else
        echo $arch
    fi
}

os="$(get_os)"
arch="$(get_arch)"

terraform_cache=${ROOT}/.cache

function download_terraform(){
  version=$1
  terraform_path=${terraform_cache}/terraform${version}
  if [ -f ${terraform_path} ]; then
    return
  fi
  echo "Downloading ${version} in cache..."
  # Download terraform
  if compare "$version < 1.0.0"; then
    # All terraform versions below 1.0.0 doesn't have arm version so downloading amd64 version
    local arch="amd64"
  fi
  # Create cache if not exists
  mkdir -p ${terraform_cache}
  pushd "$terraform_cache" &>/dev/null || exit 1
  zip_file=terraform_${version}_${os}_${arch}.zip
  sha_file=terraform_${version}_SHA256SUMS
  wget https://releases.hashicorp.com/terraform/${version}/${zip_file} &>/dev/null
  wget https://releases.hashicorp.com/terraform/${version}/${sha_file} &>/dev/null
  sed -n "/${zip_file}/p" "${sha_file}" | sha256sum -c &>/dev/null
  rm -f ${sha_file}
  unzip -p ${zip_file} terraform > ${terraform_path}
  chmod +x ${terraform_path}
  rm -f ${zip_file}
  popd &>/dev/null || exit 1
}

function terraform(){
  terraform_path=${terraform_cache}/terraform${version}
  # Download if not on cache
  if [ ! -f ${terraform_path} ]; then
    download_terraform ${version}
  fi
  if [ "${os}" == "darwin" ] && [ "${arch}" == "arm64" ] && compare "$version < 1.0.0"; then
    # All terraform versions below 1.0.0 doesn't have arm version so running in compatibility mode (for mac with m*)
    export GODEBUG=asyncpreemptoff=1;
    arch -x86_64 ${terraform_path} $@
  else
    ${terraform_path} $@
  fi
}

cleanup(){
  rv=$?
  rm -rf .terraform*
  rm -rf *.init.log
  rm -rf *.validate.log
  exit $rv
}

trap "cleanup" EXIT

fail(){
  echo "Invalid version $version"
  if [ -f "${version}.init.log" ]; then
    echo "-------- init --------"
    cat "${version}.init.log"
  fi
  if [ -f "${version}.validate.log" ]; then
    echo "-------- validate --------"
    cat "${version}.validate.log"
  fi
  exit 1
}

validate(){
  version=$1
  echo "  - Validating version ${version}..."
  # Download
  download_terraform $version
  # Check
  terraform init &>"${version}.init.log" || fail
  terraform validate &>"${version}.validate.log" || fail
  # Cleanup
  rm -rf .terraform*
  rm -rf *.init.log
  rm -rf *.validate.log
}

version_constraint(){
  if [ ! -f *setup.tf ]; then
    echo "All modules should have a *setup.tf with the version constraints."
    exit 1
  fi
  local version_constraint=$(cat *setup.tf | grep required_version)
  if [ "$version_constraint" == "" ]; then
    echo "All modules need to define required_version!"
    exit 1
  fi
  local version_constraint=${version_constraint#*=}
  local version_constraint=${version_constraint//\"/}
  local version_constraint_arr=($version_constraint)
  if [ ${#version_constraint_arr[@]} != 2 ]; then
    echo "Invalid required_version value: ${version_constraint} / should be like: >= 1.3.6"
    exit 1
  fi
  comp=${version_constraint_arr[0]}
  version=${version_constraint_arr[1]}
  if [ ${comp} != ">=" ]; then
    echo "Invalid required_version comparator, must use >="
    return 1
  fi
  IFS=. read major minor micro <<EOF
${version}
EOF
  if [ "$major" == "" ]; then
    echo "should define at least major version!"
    exit 1
  fi
  if [ "$minor" == "" ]; then
    minor=0
  fi
  if [ "$micro" == "" ]; then
    micro=0
  fi
  echo "${comp} ${major}.${minor}.${micro}"
}

atlantis_versions=("1.3.6", "1.6.6")

versions_to_check(){
  constraint=($(version_constraint))
  constraint_operator=${constraint[0]}
  constraint_version=${constraint[1]}
  versions=("${constraint_version}")
  for version in "${atlantis_versions[@]}"; do
    if compare "$version > $constraint_version"; then
      versions+=("${version}")
    fi
  done
  echo "${versions[@]}"
}

validate_module(){
  module=$1
  echo "- Validating module $module..."
  pushd ${ROOT}/${module} &>/dev/null || exit 1
  versions=($(versions_to_check))
  for version in "${versions[@]}"; do
    validate "$version"
  done
  popd &>/dev/null
}

check_modules(){
  modules=($(git diff --cached --name-only --diff-filter=ACM | grep ".*\.tf$" | xargs dirname | uniq))
  for module in "${modules[@]}"; do
    validate_module $module
  done
}

check_modules
