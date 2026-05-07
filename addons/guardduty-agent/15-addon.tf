locals {
  use_default_version = contains(["default", "latest"], var.addon_version)
}

data "aws_eks_addon_version" "auto" {
  count = local.use_default_version ? 1 : 0

  addon_name         = "aws-guardduty-agent"
  kubernetes_version = var.k8s_version

  most_recent = var.addon_version == "latest" ? true : false
}

data "aws_region" "current" {}

data "aws_vpc_endpoint" "guardduty" {
  vpc_id       = var.vpc_id
  service_name = "com.amazonaws.${data.aws_region.current.name}.guardduty-data"
  state        = "available"
}

resource "aws_eks_addon" "guardduty_agent" {
  addon_name    = "aws-guardduty-agent"
  addon_version = local.use_default_version ? data.aws_eks_addon_version.auto[0].version : var.addon_version

  cluster_name = var.cluster_name

  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  configuration_values = jsonencode(
    {
      priorityClassName = "aws-guardduty-agent.priorityclass-high"
    }
  )

  tags = {
    team    = "security",
    impact  = "critical",
    service = "eks"
  }

  depends_on = [data.aws_vpc_endpoint.guardduty]
}
