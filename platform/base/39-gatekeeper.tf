module "gatekeeper" {
  count  = var.enable_gatekeeper ? 1 : 0
  source = "git@github.com:powise/terraform-modules//k8s/gatekeeper?ref=gatekeeper-0.2.0"

  namespace        = "gatekeeper-system"
  create_namespace = true
  chart_version    = local.gatekeeper_chart_versions[var.eks_version]

  # Only run Gatekeeper audit every 30 minutes to reduce pressure on cluster
  audit_interval = 1800
}
