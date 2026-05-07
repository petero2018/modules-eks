module "external_dns" {
  count  = length(var.external_dns_config.allow_zones) > 0 ? 1 : 0
  source = "git@github.com:powise/terraform-modules//k8s/core/external-dns?ref=external-dns-0.2.0"

  namespace     = "kube-system"
  chart_version = local.external_dns_chart_versions[var.eks_version]
  aws_region    = var.aws_region

  txt_owner_id = var.txt_owner_id

  allow_external_dns_zone_ids = [for _, zone in var.external_dns_config.allow_zones : data.aws_route53_zone.external_dns[zone].zone_id]
  eks_cluster                 = var.eks_cluster

  interval     = var.external_dns_config.interval
  watch_events = var.external_dns_config.watch_events

  node_selector = var.autoscale_with == "karpenter" ? {
    "karpenter.sh/capacity-type" = "on-demand"
    } : {
    "eks.amazonaws.com/capacityType" = "ON_DEMAND"
  }

  tags = var.tags
}

moved { # Added a count to make ExternalDNS optional
  from = module.external_dns
  to   = module.external_dns[0]
}

data "aws_route53_zone" "external_dns" {
  for_each = toset(var.external_dns_config.allow_zones)

  name         = each.key
  private_zone = false
}
