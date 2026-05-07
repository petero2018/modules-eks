module "cert_manager" {
  count = var.cert_manager.enabled ? 1 : 0

  source = "git@github.com:powise/terraform-modules//k8s/cert-manager?ref=cert-manager-0.0.4"

  eks_cluster = var.eks_cluster
  aws_region  = var.aws_region
  deploy_arch = var.deploy_arch

  route53_zones = var.cert_manager.route53_zones

  tags = var.tags
}
