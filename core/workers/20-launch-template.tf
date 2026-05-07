module "launch_template" {
  source = "./launch-template"

  # Deployment
  tags         = local.tags
  cluster_tags = var.cluster_tags

  # User Data
  enable_bootstrap_user_data = var.enable_bootstrap_user_data
  cluster_name               = var.cluster_name
  cluster_endpoint           = var.cluster_endpoint
  cluster_auth_base64        = var.cluster_auth_base64
  cluster_service_ipv4_cidr  = var.cluster_service_ipv4_cidr
  pre_bootstrap_user_data    = var.pre_bootstrap_user_data
  post_bootstrap_user_data   = var.post_bootstrap_user_data
  bootstrap_extra_args       = var.bootstrap_extra_args
  user_data_template_path    = var.user_data_template_path
  registry_mirrors           = var.registry_mirrors

  # Launch template
  launch_template_name                   = var.launch_template_name
  group_name                             = var.group_name
  platform                               = var.platform
  architecture                           = var.architecture
  gpu_support                            = var.gpu_support
  k8s_version                            = var.k8s_version
  ami_id                                 = var.ami_id
  ami_filter_name                        = var.ami_filter_name
  ami_filter_owners                      = var.ami_filter_owners
  key_name                               = var.key_name
  ebs_optimized                          = var.ebs_optimized
  cluster_security_group_id              = var.cluster_security_group_id
  workers_security_group_id              = var.workers_security_group_id
  additional_vpc_security_group_ids      = var.additional_vpc_security_group_ids
  launch_template_default_version        = var.launch_template_default_version
  update_launch_template_default_version = var.update_launch_template_default_version
  block_device_mappings                  = var.block_device_mappings
  spot_enabled                           = var.spot_enabled
  spot_max_price                         = var.spot_max_price
  enable_monitoring                      = var.enable_monitoring
  launch_template_tags                   = var.launch_template_tags
  instance_profile_arn                   = var.instance_profile_arn
}
