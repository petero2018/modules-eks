module "metrics_server" {
  source = "git@github.com:powise/terraform-modules//k8s/core/metrics-server?ref=core-metrics-server-0.1.0"

  chart_version = local.metrics_server_chart_versions[var.eks_version]
}
