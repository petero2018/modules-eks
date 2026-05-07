locals {
  allow_on_karpenter_cotroller_nodes = jsonencode({
    tolerations = [{ operator = "Exists" }]
  })
}

module "network_addons" {
  source = "./network"

  eks_cluster = var.eks_cluster
  k8s_version = var.k8s_version

  enable_core_dns    = var.enable_core_dns
  core_dns_version   = var.core_dns_version
  enable_kube_proxy  = var.enable_kube_proxy
  kube_proxy_version = var.kube_proxy_version

  enable_vpc_cni                 = var.enable_vpc_cni
  enable_security_group_policies = var.enable_security_group_policies
  vpc_cni_version                = var.vpc_cni_version
  vpc_cni_chart_version          = var.vpc_cni_chart_version

  configuration_values = var.autoscale_with == "karpenter" ? local.allow_on_karpenter_cotroller_nodes : null

  tags = var.tags
}

module "secrets_store_csi_driver" {
  count = var.enable_secret_store_csi && var.enable_secrets_store_csi_driver ? 1 : 0

  source = "../../k8s/core/secrets-store-csi-driver"

  chart_version = var.secrets_store_csi_driver_chart_version
  repository    = var.secrets_store_csi_driver_repository
  chart_name    = var.secrets_store_csi_driver_chart_name
}

module "aws_secrets_store_csi" {
  count = var.enable_secret_store_csi ? 1 : 0

  source = "../../k8s/core/aws-secret-store-csi"

  chart_version = var.secret_store_csi_chart_version
  repository    = var.secret_store_csi_repository
  chart_name    = var.secret_store_csi_chart_name

  depends_on = [module.secrets_store_csi_driver]
}

module "storage_addons" {
  count = var.enable_ebs_csi_driver ? 1 : 0

  source = "./storage"

  eks_cluster = var.eks_cluster
  k8s_version = var.k8s_version
  aws_region  = var.aws_region

  ebs_csi_version = var.ebs_csi_version
  storage_classes = var.storage_classes
}

module "local_storage" {
  count  = var.enable_local_storage_driver ? 1 : 0
  source = "./local-storage"

  local_storage_driver_version = var.local_storage_driver_version
}

module "guardduty_agent" {
  count  = var.enable_guardduty_agent ? 1 : 0
  source = "./guardduty-agent"

  cluster_name = var.eks_cluster
  vpc_id       = var.vpc_id
  k8s_version  = var.k8s_version
}

module "karpenter" {
  count = var.autoscale_with == "karpenter" ? 1 : 0

  source = "./karpenter"

  worker_role_arn         = var.worker_role_arn
  enable_spot_termination = var.enable_spot_termination
  karpenter_chart_version = var.karpenter_chart_version

  eks_cluster    = var.eks_cluster
  aws_region     = var.aws_region
  aws_account_id = var.aws_account_id
  tags           = var.tags

  depends_on = [module.network_addons]
}

# EKS Auto mode storage classes
resource "kubernetes_storage_class" "auto_mode_gp3" {
  count = var.eks_auto_mode ? 1 : 0

  metadata {
    name = "gp3"
    annotations = {
      "storageclass.kubernetes.io/is-default-class" = "true"
    }
  }

  storage_provisioner = "ebs.csi.eks.amazonaws.com"
  volume_binding_mode = "WaitForFirstConsumer"
  parameters = {
    type      = "gp3"
    encrypted = "true"
  }
  allow_volume_expansion = true
}
