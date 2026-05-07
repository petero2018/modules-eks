module "snyk_monitor" {
  count = var.snyk_monitor_config.enabled ? 1 : 0

  source = "git@github.com:powise/terraform-modules//k8s/snyk?ref=snyk-4.1.1"

  chart_version             = var.snyk_monitor_config.chart_version
  eks_cluster               = var.eks_cluster
  environment               = var.environment
  service_account_api_token = var.snyk_monitor_config.api_token
  iam_suffix                = var.aws_region

  tags = {
    team    = "security"
    impact  = "medium"
    service = "snyk"
  }
}
