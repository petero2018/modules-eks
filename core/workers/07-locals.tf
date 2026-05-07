locals {
  tags = merge({
    env              = var.environment
    terraform_module = "git@github.com:powise/terraform-modules//eks/core/workers"
  }, var.tags, var.cluster_tags)
}
