#!/bin/bash

export LC_ALL=C # Custom non-C locales may affect tool (e.g. sort) output

BEGIN='<!-- BEGINNING OF CURRENT MODULES HOOK -->'
END='<!-- END OF CURRENT MODULES HOOK -->'
README_FILE='README.md'

case "$(uname -s)" in
  Darwin*) AWK=gawk;;
  *) AWK=awk;;
esac

module_list=$(find * -mindepth 1 -type f -name "*.md" | grep -v .terraform)

generated_modules=""

for path in ${module_list[@]}; do
  module=$(dirname "${path}")
  item="* [${module}](${path})"
  generated_modules="${generated_modules}${item}\n"
done

# Modules need to be sorted for comparison
generated_modules=$(echo -e "$generated_modules"|sort)

# Get current list in README
original_modules=$(${AWK} "/${BEGIN}/{flag=1;next}/${END}/{flag=0}flag" ${README_FILE} | sort)

# Compare lists and exit if no changes are detected
if diff --ignore-blank-lines <(echo -e "${generated_modules}" ) <(echo -e "${original_modules}")
then
	echo -e "No changes in modules detected."
  exit 0
else
  echo -e "Changes detected."
  # Remove contents between tags and replace contents with new list
  new_readme=$(${AWK} "/${BEGIN}/{p=1;print}/${END}/{p=0}!p" ${README_FILE} | ${AWK} -v data="${generated_modules}" "/${BEGIN}/ {f=1} /${END}/ && f {print data; f=0}1")

  # Update README
  echo -e "${new_readme}" > ${README_FILE}
  exit 1
fi
