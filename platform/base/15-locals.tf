locals {
  # These charts have been tested working on the following EKS versions.
  # Pattern is `eks_version` => `chart_version`
  metrics_server_chart_versions = {
    "1.30" = "3.8.1"
    "1.31" = "3.12.2"
    "1.32" = "3.12.2"
    "1.33" = "3.12.2"
  }
  datadog_chart_versions = {
    "1.30" = "3.59.6"
    "1.31" = "3.74.3"
    "1.32" = "3.104.0"
    "1.33" = "3.118.0"
  }
  filebeat_chart_versions = {
    "1.30" = "7.17.3"
    "1.31" = "7.17.3" # this is about to get deprecated
    "1.32" = null     # no more supported on our platform
    "1.33" = null     # no more supported on our platform
  }
  fluentbit_chart_versions = {
    "1.30" = "0.46.2"
    "1.31" = "0.47.10"
    "1.32" = "0.48.9"
    "1.33" = "0.48.9"
  }
  cluster_autoscaler_chart_versions = {
    "1.30" = "9.29.0"
    "1.31" = "9.43.0"
    "1.32" = "9.46.2" # this is about to get deprecated after Karpenter takes over
    "1.33" = "9.46.2" # this is about to get deprecated after Karpenter takes over
  }
  aws_load_balancer_controller_chart_versions = {
    "1.30" = "1.8.1"
    "1.31" = "1.9.1"
    "1.32" = "1.11.0"
    "1.33" = "1.13.3"
  }
  external_dns_chart_versions = {
    "1.30" = "6.20.3"
    "1.31" = "8.3.9"
    "1.32" = "8.7.6"
    "1.33" = "8.7.6"
  }
  gatekeeper_chart_versions = {
    "1.30" = "3.10.0"
    "1.31" = "3.17.0"
    "1.32" = "3.18.2"
    "1.33" = "3.19.1"
  }

  overprovisioning_namespace = "overprovisioning"
}
