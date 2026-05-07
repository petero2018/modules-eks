module "aws_load_balancer_controller" {
  count = var.eks_auto_mode ? 0 : 1

  source = "git@github.com:powise/terraform-modules//k8s/core/aws-load-balancer-controller?ref=aws-load-balancer-controller-0.6.2"

  namespace     = "kube-system"
  chart_version = local.aws_load_balancer_controller_chart_versions[var.eks_version]
  aws_region    = var.aws_region
  eks_cluster   = var.eks_cluster
  iam_role_path = var.aws_load_balancer_controller_iam_role_path

  tags = var.tags
}

moved {
  from = module.aws_load_balancer_controller
  to   = module.aws_load_balancer_controller[0]
}
