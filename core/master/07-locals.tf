locals {
  # Tags
  tags = merge({
    env              = var.environment,
    terraform_module = "git@github.com:powise/terraform-modules//eks/core/master"
  }, var.tags)
  # Cluster Tags
  cluster_tags = merge(local.tags, var.cluster_tags)
}
