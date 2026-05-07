data "aws_ssm_parameter" "aws_recommended_ami" {
  name = "${local.ssm_prefix}${var.k8s_version}${local.ssm_details}${local.ssm_suffix}"
}

data "aws_ami" "search" {
  count = var.ami_filter_name != null ? 1 : 0

  executable_users = ["self"]
  most_recent      = true

  owners = var.ami_filter_owners

  filter {
    name   = "name"
    values = [var.ami_filter_name]
  }
}

locals {
  # Check if we're using EKS 1.33 or newer (which requires AL2023)
  # https://docs.aws.amazon.com/eks/latest/userguide/eks-optimized-ami.html
  use_al2023 = var.platform == "linux" && tonumber(replace(var.k8s_version, ".", "")) >= 133

  ssm_prefix = var.platform == "linux" ? "/aws/service/eks/optimized-ami/" : "/aws/service/bottlerocket/aws-k8s-"
  ssm_suffix = var.platform == "linux" ? "/recommended/image_id" : "/latest/image_id"

  # For Linux platform, use AL2023 paths for EKS 1.33+ and AL2 paths for earlier versions
  ssm_details = var.platform == "linux" ? (
    local.use_al2023 ? (
      var.architecture == "amd64" ? (var.gpu_support ? "/amazon-linux-2023/x86_64/nvidia" : "/amazon-linux-2023/x86_64/standard") : "/amazon-linux-2023/arm64/standard"
      ) : (
      var.architecture == "amd64" ? (var.gpu_support ? "/amazon-linux-2-gpu" : "/amazon-linux-2") : "/amazon-linux-2-arm64"
    )
    ) : (
    var.architecture == "amd64" ? (var.gpu_support ? "-nvidia/x86_64" : "/x86_64") : (var.gpu_support ? "-nvidia/arm64" : "/arm64")
  )

  # AMI ID precedence: var.ami_id > var.ami_name_filter > AWS recommended AMI
  ami_id = var.ami_id != null ? var.ami_id : (var.ami_filter_name != null ? data.aws_ami.search[0].id : data.aws_ssm_parameter.aws_recommended_ami.value)
}
