resource "aws_iam_role" "worker" {
  count = var.create_worker_role == null ? 0 : 1

  name               = var.create_worker_role
  assume_role_policy = data.aws_iam_policy_document.worker_assume_role.json

  tags = local.tags
}

data "aws_iam_policy_document" "worker_assume_role" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role_policy_attachment" "worker_role_attachment" {
  for_each = var.create_worker_role == null ? toset([]) : toset([
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
  ])

  role = aws_iam_role.worker[0].name

  policy_arn = each.key
}

resource "aws_iam_role_policy" "worker_cloudwatch_policy" {
  count = var.create_worker_role == null ? 0 : 1

  name = "EnableSendingCloudwatchMetrics"
  role = aws_iam_role.worker[0].name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["cloudwatch:PutMetricData"]
        Resource = "*"
      }
    ]
  })
}
