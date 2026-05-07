module "coredns_hpa" {
  count = var.eks_auto_mode ? 0 : 1

  source = "git@github.com:powise/terraform-modules//k8s/hpa?ref=k8s-hpa-0.2.0"

  hpa_name  = "coredns"
  namespace = "kube-system"

  scaling = {
    min_replicas   = var.coredns_config.min_replicas
    max_replicas   = var.coredns_config.max_replicas
    resource_name  = "memory"
    utilization    = 60
    period_seconds = 120
    scale_up_pods  = 2
    window_seconds = 300
  }

  target = {
    api_version = "apps/v1",
    kind        = "Deployment"
    name        = "coredns"
  }
}

moved {
  from = module.coredns_hpa
  to   = module.coredns_hpa[0]
}
