module "cluster_autoscaler" {
  count = var.autoscale_with == "cluster-autoscaler" ? 1 : 0

  source = "../../..//k8s/core/cluster-autoscaler"

  cluster_autoscaler_namespace     = "kube-system"
  cluster_autoscaler_chart_version = local.cluster_autoscaler_chart_versions[var.eks_version]
  cluster_autoscaler_config        = var.cluster_autoscaler_config
  cluster_autoscaler_helm_config = {
    "awsRegion" = var.aws_region
  }

  eks_cluster = var.eks_cluster
}

module "karpenter_workload" {
  count = var.autoscale_with == "karpenter" ? 1 : 0

  source = "../../..//k8s/core/karpenter-workload"

  karpenter_config = var.karpenter_config
  eks_cluster      = var.eks_cluster
  worker_role_name = var.worker_role_name

  eks_auto_mode = var.eks_auto_mode

  tags = var.tags
}

check "karpenter_role_name" {
  assert {
    condition     = var.autoscale_with == "karpenter" ? var.worker_role_name != null : true
    error_message = "The worker IAM Role name must be set when using Karpenter."
  }
}
