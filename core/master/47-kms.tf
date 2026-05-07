data "aws_caller_identity" "current" {}

module "cluster_kms" {
  source = "git@github.com:powise/terraform-modules//aws/kms?ref=aws-kms-0.1.2"

  alias               = "eks/${var.cluster_name}"
  description         = "Encrypt secrets for ${var.cluster_name} cluster"
  key_policy          = data.aws_iam_policy_document.cluster_kms.json
  enable_key_rotation = true

  tags = var.tags
}

data "aws_iam_policy_document" "cluster_kms" {
  #checkov:skip=CKV_AWS_111:For now this check is ignored but we should really revisit and fix this to allow only access to what's strictly necessary and avoid giving full KMS access.
  #Even if some roles need full access to KMS it shouldn't be given in this module since it's an EKS module.
  #checkov:skip=CKV_AWS_109:Same thing as before. We should revisit and fix this to allow only access to what's strictly necessary and avoid giving full KMS access.
  #checkov:skip=CKV_AWS_356:We can restrict this later on
  statement {
    sid = "AllowKMSUsage"

    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:Describe*",
      "kms:Get*",
      "kms:List*",
      "kms:Generate*",
    ]

    principals {
      type = "AWS"

      identifiers = [aws_iam_role.cluster.arn]
    }

    resources = ["*"]
  }

  statement {
    sid = "AllowKMSFullControl"

    actions = ["kms:*"]

    principals {
      type = "AWS"

      identifiers = concat([
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/AdminRole",
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/TerraformRole",
      ], var.extra_kms_roles)
    }

    resources = ["*"]
  }
}

module "cluster_cloudwatch_logs" {
  source = "git@github.com:powise/terraform-modules//aws/kms?ref=aws-kms-0.1.2"

  alias       = "eks/cloudwatch_logs/${var.cluster_name}"
  description = "KMS key for cluster logs"
  key_policy  = data.aws_iam_policy_document.cloudwatch_kms_policy.json

  tags = var.tags
}

data "aws_iam_policy_document" "cloudwatch_kms_policy" {
  #checkov:skip=CKV_AWS_109:It's exactly as recommended from aws docs.
  #checkov:skip=CKV_AWS_111:It's exactly as recommended from aws docs.
  #checkov:skip=CKV_AWS_356:It's exactly as recommended from aws docs.
  #https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/encrypt-log-data-kms.html
  statement {
    sid = "AllowKMSUsage"

    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Describe*",
    ]

    principals {
      type        = "Service"
      identifiers = ["logs.${var.aws_region}.amazonaws.com"]
    }

    resources = ["*"]
    condition {
      test     = "ArnLike"
      variable = "kms:EncryptionContext:aws:logs:arn"
      values   = ["arn:aws:logs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:*"]
    }
  }

  statement {
    sid = "AllowKMSFullControl"

    actions = ["kms:*"]

    principals {
      type = "AWS"

      identifiers = concat([
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/AdminRole",
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/TerraformRole",
      ], var.extra_kms_roles)
    }

    resources = ["*"]
  }
}
