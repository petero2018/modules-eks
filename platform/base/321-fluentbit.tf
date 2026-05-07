module "fluentbit" {
  count = var.enable_fluentbit ? 1 : 0

  source = "git@github.com:powise/terraform-modules//k8s/fluentbit?ref=fluentbit-0.2.3"

  chart_version = local.fluentbit_chart_versions[var.eks_version]

  eks_cluster = var.eks_cluster
  aws_region  = var.aws_region

  opensearch_output_enabled = false
  s3_output_enabled         = false
  debug_output_enabled      = false

  kubernetes_metadata_config = {
    labels      = true
    annotations = false
  }

  static_fields = merge(var.fluentbit_config.static_fields, {
    "kubernetes.cluster" = var.eks_cluster
    "aws.account_name"   = var.aws_account_name
    "environment"        = var.environment
  })

  kafka_output_enabled = var.fluentbit_config.kafka.enabled
  kafka_brokers        = var.fluentbit_config.kafka.brokers
  kafka_topic          = var.fluentbit_config.kafka.topic
  kafka_username       = var.fluentbit_config.kafka.username
  kafka_password       = var.fluentbit_config.kafka.password

  tags = var.tags
}
