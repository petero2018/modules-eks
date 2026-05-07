resource "aws_eks_node_group" "workers_autoscaling" {
  count = var.support_autoscaling ? 1 : 0

  cluster_name    = var.cluster_name
  node_group_name = var.group_name
  node_role_arn   = var.create_worker_role == null ? var.worker_role_arn : aws_iam_role.worker[0].arn
  subnet_ids      = var.subnet_ids
  capacity_type   = var.spot_enabled ? "SPOT" : "ON_DEMAND"
  instance_types  = var.instance_types

  force_update_version = true

  scaling_config {
    desired_size = var.desired_worker_count
    max_size     = var.max_worker_count
    min_size     = var.min_worker_count
  }

  launch_template {
    id      = module.launch_template.id
    version = module.launch_template.latest_version
  }

  dynamic "update_config" {
    for_each = length(var.update_config) > 0 ? [var.update_config] : []
    content {
      max_unavailable_percentage = lookup(update_config.value, "max_unavailable_percentage")
      max_unavailable            = lookup(update_config.value, "max_unavailable")
    }
  }

  dynamic "remote_access" {
    for_each = var.remote_access_ssh_key != null || length(var.remote_access_security_group) > 0 ? [1] : []
    content {
      ec2_ssh_key               = var.remote_access_ssh_key
      source_security_group_ids = var.remote_access_security_group
    }
  }

  labels = var.labels

  dynamic "taint" {
    for_each = toset(var.taints)

    content {
      key    = lookup(taint.key, "key")
      value  = lookup(taint.key, "value")
      effect = lookup(taint.key, "effect")
    }
  }

  tags = merge(local.tags, {
    name = var.group_name
    role = var.group_name
  })

  lifecycle {
    ignore_changes        = [scaling_config[0].desired_size]
    create_before_destroy = false
  }

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}

resource "aws_eks_node_group" "workers_static" {
  count = var.support_autoscaling ? 0 : 1

  cluster_name    = var.cluster_name
  node_group_name = var.group_name
  node_role_arn   = var.create_worker_role == null ? var.worker_role_arn : aws_iam_role.worker[0].arn
  subnet_ids      = var.subnet_ids
  capacity_type   = var.spot_enabled ? "SPOT" : "ON_DEMAND"
  instance_types  = var.instance_types

  force_update_version = true

  scaling_config {
    # Managed Node Group will not autoscale, so ignore min/max variables
    desired_size = var.desired_worker_count
    max_size     = var.desired_worker_count
    min_size     = var.desired_worker_count
  }

  launch_template {
    id      = module.launch_template.id
    version = module.launch_template.latest_version
  }

  dynamic "update_config" {
    for_each = length(var.update_config) > 0 ? [var.update_config] : []
    content {
      max_unavailable_percentage = lookup(update_config.value, "max_unavailable_percentage")
      max_unavailable            = lookup(update_config.value, "max_unavailable")
    }
  }

  dynamic "remote_access" {
    for_each = var.remote_access_ssh_key != null || length(var.remote_access_security_group) > 0 ? [1] : []
    content {
      ec2_ssh_key               = var.remote_access_ssh_key
      source_security_group_ids = var.remote_access_security_group
    }
  }

  labels = var.labels

  dynamic "taint" {
    for_each = toset(var.taints)

    content {
      key    = lookup(taint.key, "key")
      value  = lookup(taint.key, "value")
      effect = lookup(taint.key, "effect")
    }
  }

  tags = merge(local.tags, {
    name = var.group_name
    role = var.group_name
  })

  lifecycle {
    create_before_destroy = false
  }

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}
