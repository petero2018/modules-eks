locals {
  # Get Registry Mirrors
  registry_mirrors = concat(var.registry_mirrors, ["https://registry-1.docker.io"])

  # Check if we're using EKS 1.33 or newer (which requires AL2023)
  # This duplicates the logic from 10-ami.tf to ensure it's available here
  use_al2023_userdata = var.platform == "linux" && tonumber(replace(var.k8s_version, ".", "")) >= 133

  # Select the appropriate Linux user data template based on AL2023 usage
  linux_template_path = local.use_al2023_userdata ? "${path.module}/templates/al2023_user_data.tpl" : "${path.module}/templates/linux_user_data.tpl"

  # Generate User Data for Platforms
  user_data_platforms = {
    bottlerocket = var.enable_bootstrap_user_data && var.platform == "bottlerocket" ? base64encode(templatefile(
      coalesce(var.user_data_template_path, "${path.module}/templates/bottlerocket_user_data.tpl"),
      {
        # https://docs.aws.amazon.com/eks/latest/userguide/launch-templates.html#launch-template-custom-ami
        # Required to bootstrap node
        cluster_name        = var.cluster_name
        cluster_endpoint    = var.cluster_endpoint
        cluster_auth_base64 = var.cluster_auth_base64
        # Optional - is appended if using EKS managed node group without custom AMI
        # cluster_service_ipv4_cidr = var.cluster_service_ipv4_cidr # Bottlerocket pulls this automatically https://github.com/bottlerocket-os/bottlerocket/issues/1866
        bootstrap_extra_args = var.bootstrap_extra_args
        # Disable Kernel Lock Down to avoid crash loading nvidia kernel modules
        kernel_lockdown = var.gpu_support ? "none" : "integrity"
        # Registry mirrors
        registry_mirrors = local.registry_mirrors
      }
    )) : ""
    linux = var.enable_bootstrap_user_data && var.platform == "linux" ? base64encode(templatefile(
      coalesce(var.user_data_template_path, local.linux_template_path),
      {
        # https://docs.aws.amazon.com/eks/latest/userguide/launch-templates.html#launch-template-custom-ami
        # Required to bootstrap node
        cluster_name        = var.cluster_name
        cluster_endpoint    = var.cluster_endpoint
        cluster_auth_base64 = var.cluster_auth_base64
        # Registry mirrors
        registry_mirrors = jsonencode(local.registry_mirrors)
        # Optional
        cluster_service_ipv4_cidr = var.cluster_service_ipv4_cidr != null ? var.cluster_service_ipv4_cidr : ""
        bootstrap_extra_args      = var.bootstrap_extra_args
        pre_bootstrap_user_data   = var.pre_bootstrap_user_data
        post_bootstrap_user_data  = var.post_bootstrap_user_data
      }
    )) : ""
  }
  user_data = local.user_data_platforms[var.platform]
}
