module "filebeat" {
  count = var.enable_filebeat ? 1 : 0

  source = "git@github.com:powise/terraform-modules//k8s/filebeat?ref=filebeat-0.5.1"

  namespace        = "filebeat"
  create_namespace = true
  chart_version    = local.filebeat_chart_versions[var.eks_version]

  template_values = {
    eks_cluster                 = var.eks_cluster,
    environment                 = var.environment,
    kube_status                 = var.kube_status,
    product                     = var.product,
    output_redis_host           = var.filebeat_config.output_redis_host,
    enable_core_components_logs = true,
  }

  helm_config = {
    "daemonset.resources.limits.memory" = "400Mi"
  }

  drop_services = var.filebeat_config.ignore_services
}

moved {
  from = module.filebeat
  to   = module.filebeat[0]
}
