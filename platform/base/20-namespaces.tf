module "namespace" {
  for_each = toset(var.namespaces)

  source = "git@github.com:powise/terraform-modules//k8s/core/namespace?ref=core-namespace-2.2.2"

  name         = each.key
  enable_istio = var.enable_istio

  rbac_users           = ["developers"]
  rbac_users_readonly  = var.rbac_developers_readonly
  rbac_groups          = ["developers"]
  rbac_groups_readonly = var.rbac_developers_readonly

  enable_common_credentials = true

  external_registry_auths = var.external_registry_auths
}
