module "datadog" {
  count = var.enable_datadog ? 1 : 0

  source = "git@github.com:powise/terraform-modules//k8s/datadog?ref=datadog-1.8.6"

  namespace        = "datadog"
  create_namespace = true
  chart_version    = local.datadog_chart_versions[var.eks_version]

  use_custom_image = true

  enable_apm  = var.datadog_config.enable_apm
  enable_logs = var.datadog_config.enable_logs
  eks_cluster = var.eks_cluster
  environment = var.environment
  kube_status = var.kube_status
  product     = var.product
  region      = var.aws_region

  msk_cluster_arns    = var.msk_cluster_arns
  opensearch_urls     = var.opensearch_urls
  opensearch_arns     = var.opensearch_arns
  clickhouse_clusters = var.clickhouse_clusters

  agent_iam_policy_arns = var.datadog_iam_policy_arns

  dd_external_metrics_provider_max_age = var.dd_external_metrics_provider_max_age

  datadog_site = var.datadog_config.site

  datadog_api_key = var.datadog_api_key
  datadog_app_key = var.datadog_app_key

  timeout = var.daemonset_helm_timeout

  tags = var.tags
}

moved {
  from = module.datadog
  to   = module.datadog[0]
}
