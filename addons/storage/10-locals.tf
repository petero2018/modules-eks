locals {
  ebs_csi_version = var.ebs_csi_version == null ? data.aws_eks_addon_version.ebs_csi_version.version : var.ebs_csi_version
}

data "aws_eks_addon_version" "ebs_csi_version" {
  addon_name         = "aws-ebs-csi-driver"
  kubernetes_version = var.k8s_version
}
