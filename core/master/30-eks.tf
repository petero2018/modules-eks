resource "aws_eks_cluster" "cluster" {
  #checkov:skip=CKV_AWS_39:Access to the public endpoint is being restricted by cidr
  #checkov:skip=CKV_AWS_38:The security group already ensures it is not accessible from internet
  #checkov:skip=CKV_AWS_58:The secrets are already encrypted

  name                      = var.cluster_name
  role_arn                  = aws_iam_role.cluster.arn
  version                   = var.k8s_version
  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  vpc_config {
    security_group_ids      = [aws_security_group.cluster.id]
    subnet_ids              = local.subnet_ids
    endpoint_private_access = true                        # VPC traffic stays within VPC
    endpoint_public_access  = var.enable_public_api       # Open a public endpoint as well
    public_access_cidrs     = var.public_api_access_cidrs # Limit access to the public endpoint
  }

  dynamic "compute_config" {
    for_each = var.auto_mode ? [1] : []
    content {
      enabled       = true
      node_role_arn = var.auto_mode_default_node_pools ? aws_iam_role.worker.arn : null
      node_pools    = var.auto_mode_default_node_pools ? ["general-purpose", "system"] : null
    }
  }

  access_config {
    authentication_mode = var.auto_mode ? "API_AND_CONFIG_MAP" : "CONFIG_MAP"

    bootstrap_cluster_creator_admin_permissions = true
  }

  bootstrap_self_managed_addons = !var.auto_mode

  kubernetes_network_config {
    service_ipv4_cidr = var.cluster_service_ipv4_cidr

    dynamic "elastic_load_balancing" {
      for_each = var.auto_mode ? [1] : []
      content {
        enabled = true
      }
    }
  }

  dynamic "storage_config" {
    for_each = var.auto_mode ? [1] : []
    content {
      block_storage {
        # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster#eks-cluster-with-eks-auto-mode
        enabled = var.auto_mode
      }
    }
  }

  encryption_config {
    provider {
      key_arn = module.cluster_kms.key_arn
    }

    resources = ["secrets"]
  }

  dynamic "encryption_config" {
    for_each = toset(var.cluster_encryption_config)

    content {
      provider {
        key_arn = encryption_config.value.provider_key_arn
      }
      resources = encryption_config.value.resources
    }
  }

  timeouts {
    create = lookup(var.cluster_timeouts, "create", null)
    update = lookup(var.cluster_timeouts, "update", null)
    delete = lookup(var.cluster_timeouts, "delete", null)
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster_role_attachment,
    aws_cloudwatch_log_group.cluster,
  ]

  tags = merge(local.cluster_tags, {
    "powise.com/kubeconfig-alias"        = var.kubeconfig_alias
    "powise.com/kubeconfig-discoverable" = var.kubeconfig_discoverable ? "true" : "false"
  })
}
