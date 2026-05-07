data "aws_vpc" "vpc_from_id" {
  count = var.vpc_id != null ? 1 : 0

  id = var.vpc_id
}

data "aws_vpc" "vpc_from_name" {
  count = var.vpc_name != null ? 1 : 0

  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

locals {
  vpc_id   = try(data.aws_vpc.vpc_from_id[0].id, data.aws_vpc.vpc_from_name[0].id)
  vpc_cidr = try(data.aws_vpc.vpc_from_id[0].cidr_block, data.aws_vpc.vpc_from_name[0].cidr_block)
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [local.vpc_id]
  }

  tags = var.subnet_tags
}

locals {
  subnet_ids = length(var.subnet_ids) == 0 ? data.aws_subnets.private.ids : var.subnet_ids
}
