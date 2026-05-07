locals {
  # Tags
  tags = merge({
    terraform_module = "git@github.com:powise/terraform-modules//eks/irsa"
  }, var.tags)
}
