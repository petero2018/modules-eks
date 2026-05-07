################################################################################
# OICD
################################################################################

locals {
  service_account_namespace = var.allow_any_namespace ? "*" : var.namespace
  eks_clusters_oidc = [
    for eks_cluster in var.eks_clusters : replace(data.aws_eks_cluster.cluster[eks_cluster].identity[0].oidc[0].issuer, "https://", "")
  ]
}

data "aws_iam_policy_document" "oidc_assume_role" {
  source_policy_documents = [data.aws_iam_policy_document.assume_role_by_authorized_roles.json]

  dynamic "statement" {
    for_each = setproduct(local.eks_clusters_oidc, var.service_accounts)

    content {
      effect = "Allow"

      principals {
        type        = "Federated"
        identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${statement.value[0]}"]
      }

      actions = ["sts:AssumeRoleWithWebIdentity"]

      condition {
        test     = "StringLike"
        variable = "${statement.value[0]}:sub"
        values   = ["system:serviceaccount:${local.service_account_namespace}:${statement.value[1]}"]
      }
    }
  }
}

################################################################################
# Non-Kubernetes Access (debug roles by assuming them outside of cluster)
################################################################################

data "aws_iam_policy_document" "assume_role_by_authorized_roles" {
  dynamic "statement" {
    for_each = toset([for role in var.authorized_iam_roles : role])

    content {
      effect = "Allow"

      sid = "Allow${statement.value}"

      principals {
        type        = "AWS"
        identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${statement.value}"]
      }

      actions = ["sts:AssumeRole"]
    }
  }
}

################################################################################
# IRSA Role
################################################################################

module "irsa" {
  source = "git@github.com:powise/terraform-modules//aws/iam/role?ref=aws-iam-role-1.0.0"

  name = var.iam_role_name
  path = var.iam_role_path

  description        = "AWS IAM Role for the Kubernetes service accounts ${join(", ", var.service_accounts)}."
  assume_role_policy = data.aws_iam_policy_document.oidc_assume_role.json

  force_detach_policies = true
  permissions_boundary  = var.iam_permissions_boundary

  attach_policies = var.iam_policy_arns
  create_policies = var.iam_policy_documents

  tags = merge({
    "Name"        = var.iam_role_name
    "eksClusters" = join("+", var.eks_clusters)
  }, local.tags)
}

moved {
  from = aws_iam_role.irsa
  to   = module.irsa.aws_iam_role.role
}
