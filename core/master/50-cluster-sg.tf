locals {
  cluster_security_group_name = "eks-${var.cluster_name}"
}

resource "aws_security_group" "cluster" {
  name        = local.cluster_security_group_name
  description = "EKS cluster security group"
  vpc_id      = local.vpc_id

  tags = merge({
    Name = local.cluster_security_group_name
  }, local.tags, var.cluster_security_group_extra_tags)

  lifecycle {
    ignore_changes = [name]
  }
}

resource "aws_security_group_rule" "cluster_egress" {
  #checkov:skip=CKV_AWS_382:We can restrict this later on

  description       = "Allow cluster access to the Internet"
  protocol          = "-1"
  security_group_id = aws_security_group.cluster.id
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  to_port           = 0
  type              = "egress"
}

resource "aws_security_group_rule" "private_api_access" {
  count = length(var.private_api_access_cidrs) > 0 ? 1 : 0

  type = "ingress"

  security_group_id = aws_security_group.cluster.id
  cidr_blocks       = var.private_api_access_cidrs

  from_port   = 443
  to_port     = 443
  protocol    = "-1"
  description = "Allow these CIDRs access to EKS cluster API endpoint."
}

resource "aws_security_group_rule" "cluster_additional" {
  for_each = var.cluster_security_group_additional_rules

  # Required
  security_group_id = aws_security_group.cluster.id
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
