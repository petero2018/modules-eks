locals {
  # https://docs.aws.amazon.com/eks/latest/userguide/managing-kube-proxy.html
  kube_proxy_version = var.kube_proxy_version == null ? data.aws_eks_addon_version.kube_proxy.version : var.kube_proxy_version

  # https://docs.aws.amazon.com/eks/latest/userguide/managing-coredns.html
  core_dns_version = var.core_dns_version == null ? data.aws_eks_addon_version.core_dns.version : var.core_dns_version

  # https://docs.aws.amazon.com/eks/latest/userguide/managing-vpc-cni.html
  vpc_cni_version = var.vpc_cni_version == null ? data.aws_eks_addon_version.vpc_cni.version : var.vpc_cni_version
}

data "aws_eks_addon_version" "kube_proxy" {
  addon_name         = "kube-proxy"
  kubernetes_version = var.k8s_version
}

data "aws_eks_addon_version" "core_dns" {
  addon_name         = "coredns"
  kubernetes_version = var.k8s_version
}

data "aws_eks_addon_version" "vpc_cni" {
  addon_name         = "vpc-cni"
  kubernetes_version = var.k8s_version
}
