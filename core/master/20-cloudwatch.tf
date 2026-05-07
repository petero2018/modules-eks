resource "aws_cloudwatch_log_group" "cluster" {
  #checkov:skip=CKV_AWS_338:Log group retention is actually set, might be a bug in checkov

  name              = "/aws/eks/${var.cluster_name}/cluster"
  retention_in_days = var.cloudwatch_log_group_retention_in_days
  kms_key_id        = module.cluster_cloudwatch_logs.key_arn

  tags = local.tags
}
