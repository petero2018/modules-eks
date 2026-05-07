################################################################################
# SSM
################################################################################

resource "aws_ssm_parameter" "active_eks_cluster" {
  #checkov:skip=CKV_AWS_337:No need to encrypt using KMS CMK
  #checkov:skip=CKV2_AWS_34:No need to encrypt this parameter
  name        = var.active_eks_cluster.ssm_parameter
  description = "Statically set active EKS cluster name"
  type        = "String"
  value       = data.aws_eks_cluster.active_eks_cluster.id

  tags = merge({
    value = data.aws_eks_cluster.active_eks_cluster.id
  }, local.tags)
}

resource "aws_ssm_parameter" "active_eks_cluster_arn" {
  #checkov:skip=CKV_AWS_337:No need to encrypt using KMS CMK
  #checkov:skip=CKV2_AWS_34:No need to encrypt this parameter
  name        = "${var.active_eks_cluster.ssm_parameter}_arn"
  description = "Statically set active EKS cluster ARN"
  type        = "String"
  value       = data.aws_eks_cluster.active_eks_cluster.arn

  tags = merge({
    value = data.aws_eks_cluster.active_eks_cluster.arn
  }, local.tags)
}

resource "aws_ssm_parameter" "inactive_eks_cluster" {
  count = var.inactive_eks_cluster != null ? 1 : 0

  #checkov:skip=CKV_AWS_337:No need to encrypt using KMS CMK
  #checkov:skip=CKV2_AWS_34:No need to encrypt this parameter
  name        = var.inactive_eks_cluster.ssm_parameter
  description = "Statically set inactive EKS cluster name"
  type        = "String"
  value       = data.aws_eks_cluster.inactive_eks_cluster[0].id

  tags = merge({
    value = data.aws_eks_cluster.inactive_eks_cluster[0].id
  }, local.tags)

  lifecycle {
    precondition {
      condition     = var.active_eks_cluster.ssm_parameter != var.inactive_eks_cluster.ssm_parameter
      error_message = "active and inactive clusters must have different SSM parameter names"
    }
  }
}

resource "aws_ssm_parameter" "inactive_eks_cluster_arn" {
  count = var.inactive_eks_cluster != null ? 1 : 0

  #checkov:skip=CKV_AWS_337:No need to encrypt using KMS CMK
  #checkov:skip=CKV2_AWS_34:No need to encrypt this parameter
  name        = "${var.inactive_eks_cluster.ssm_parameter}_arn"
  description = "Statically set inactive EKS cluster ARN"
  type        = "String"
  value       = data.aws_eks_cluster.inactive_eks_cluster[0].arn

  tags = merge({
    value = data.aws_eks_cluster.inactive_eks_cluster[0].arn
  }, local.tags)

  lifecycle {
    precondition {
      condition     = "${var.active_eks_cluster.ssm_parameter}-arn" != "${var.inactive_eks_cluster.ssm_parameter}-arn"
      error_message = "active and inactive clusters must have different SSM parameter names for ARNs"
    }
  }
}
