module "velero" {
  count  = var.velero_config.enabled ? 1 : 0
  source = "git@github.com:powise/terraform-modules//k8s/velero?ref=velero-0.2.0"

  namespace     = "velero"
  chart_version = var.velero_config.chart_version

  eks_cluster = var.eks_cluster

  aws_region = var.aws_region

  deploy_arch = var.deploy_arch

  features = var.velero_config.features

  template_values = {
    backup_bucket = var.velero_config.backup_bucket
  }

  tags = {
    team    = "platform-infra"
    impact  = "medium"
    service = "velero"
  }

}
