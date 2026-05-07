locals {
  vpc_security_group_ids = distinct(concat([
    var.workers_security_group_id, var.cluster_security_group_id
  ], var.additional_vpc_security_group_ids))
}

resource "aws_launch_template" "main" {
  #checkov:skip=CKV_AWS_341::Recommended for container environments

  name        = var.launch_template_name
  name_prefix = var.launch_template_name == null ? "${var.group_name}-" : null

  ebs_optimized = var.ebs_optimized
  image_id      = local.ami_id

  key_name = var.key_name

  user_data = var.enable_bootstrap_user_data ? local.user_data : null

  vpc_security_group_ids = local.vpc_security_group_ids

  default_version        = var.launch_template_default_version
  update_default_version = var.update_launch_template_default_version

  dynamic "iam_instance_profile" {
    for_each = var.instance_profile_arn != null ? [1] : []
    content {
      arn = var.instance_profile_arn
    }
  }

  dynamic "block_device_mappings" {
    for_each = var.block_device_mappings
    content {
      device_name  = block_device_mappings.value.device_name
      no_device    = block_device_mappings.value.no_device
      virtual_name = block_device_mappings.value.virtual_name

      dynamic "ebs" {
        for_each = flatten([block_device_mappings.value.ebs != null ? block_device_mappings.value.ebs : []])
        content {
          delete_on_termination = true # All cluster volumes should be deleted on termination
          encrypted             = true # All volumes must be encrypted
          kms_key_id            = lookup(ebs.value, "kms_key_id")
          iops                  = lookup(ebs.value, "iops")
          throughput            = lookup(ebs.value, "throughput")
          snapshot_id           = lookup(ebs.value, "snapshot_id")
          volume_size           = lookup(ebs.value, "volume_size")
          volume_type           = lookup(ebs.value, "volume_type")
        }
      }
    }
  }

  dynamic "instance_market_options" {
    for_each = var.spot_enabled && var.spot_max_price != null ? [1] : []
    content {
      market_type = "spot"

      spot_options {
        max_price = var.spot_max_price
      }
    }
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required" # Force IMDSv2
    http_put_response_hop_limit = 2          # Recommended for container environments
  }

  dynamic "monitoring" {
    for_each = var.enable_monitoring != null ? [1] : []
    content {
      enabled = var.enable_monitoring
    }
  }

  dynamic "tag_specifications" {
    for_each = toset(["instance", "volume", "network-interface"])
    content {
      resource_type = tag_specifications.key
      tags          = merge(local.tags, { Name = var.group_name }, var.launch_template_tags)
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = local.tags
}
