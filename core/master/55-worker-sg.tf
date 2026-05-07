locals {
  workers_security_group_name = "eks-workers-${var.cluster_name}"
  workers_security_group_id   = var.share_cluster_security_group ? aws_security_group.cluster.id : aws_security_group.workers[0].id
}

resource "aws_security_group" "workers" {
  count = var.share_cluster_security_group ? 0 : 1

  name        = local.workers_security_group_name
  description = "EKS workers security group"
  vpc_id      = local.vpc_id

  tags = merge({
    Name = local.workers_security_group_name
  }, local.tags, var.worker_security_group_extra_tags)
}

resource "aws_security_group_rule" "allow_worker_to_worker_communication" {
  type = "ingress"

  security_group_id = local.workers_security_group_id
  self              = true

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  description = "Allow EKS workers to reach each other."
}

resource "aws_security_group_rule" "allow_cluster_to_worker_communication" {
  count = var.share_cluster_security_group ? 0 : 1

  type = "ingress"

  security_group_id        = aws_security_group.workers[0].id
  source_security_group_id = aws_security_group.cluster.id

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  description = "Allow EKS control plane to reach workers."
}

resource "aws_security_group_rule" "allow_vpc_to_worker_communication" {
  type = "ingress"

  security_group_id = local.workers_security_group_id
  cidr_blocks       = [local.vpc_cidr]

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  description = "Allow VPC CIDR access to EKS workers."
}

resource "aws_security_group_rule" "worker_additional" {
  for_each = var.worker_security_group_additional_rules

  # Required
  security_group_id = local.workers_security_group_id
  protocol          = each.value.protocol
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  type              = each.value.type

  # Optional
  description              = try(each.value.description, null)
  cidr_blocks              = try(each.value.cidr_blocks, null)
  prefix_list_ids          = try(each.value.prefix_list_ids, [])
  self                     = try(each.value.self, null)
  source_security_group_id = try(each.value.source_security_group_id, null)
}

resource "aws_security_group" "workers_extra" {
  for_each = var.worker_extra_security_groups

  name        = "${local.workers_security_group_name}-${each.key}"
  description = "EKS workers extra security group."
  vpc_id      = local.vpc_id

  tags = merge({
    Name = "${local.workers_security_group_name}-${each.key}"
  }, local.tags, var.worker_security_group_extra_tags, each.value.tags)
}

resource "aws_security_group_rule" "worker_extra" {
  for_each = merge([for sg_key, sg in var.worker_extra_security_groups : { for rule_key, rule in sg.rules : "${sg_key}-${rule_key}" => [sg_key, rule] }]...)

  # Required
  security_group_id = aws_security_group.workers_extra[each.value[0]].id
  protocol          = each.value[1].protocol
  from_port         = each.value[1].from_port
  to_port           = each.value[1].to_port
  type              = each.value[1].type

  # Optional
  description              = try(each.value[1].description, null)
  cidr_blocks              = try(each.value[1].cidr_blocks, null)
  prefix_list_ids          = try(each.value[1].prefix_list_ids, [])
  self                     = try(each.value[1].self, null)
  source_security_group_id = try(each.value[1].source_security_group_id, null)
}
