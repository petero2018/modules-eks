module "karpenter_controller" {
  source = "../../..//k8s/core/karpenter-controller"

  karpenter_namespace     = "kube-system"
  karpenter_chart_version = var.karpenter_chart_version
  install_crds            = var.install_crds

  eks_cluster             = var.eks_cluster
  aws_region              = var.aws_region
  aws_account_id          = var.aws_account_id
  worker_role_arn         = var.worker_role_arn
  enable_spot_termination = var.enable_spot_termination
  queue_name              = "karpenter-${var.eks_cluster}-${var.aws_region}"

  tags = var.tags
}
