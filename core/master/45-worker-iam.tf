data "aws_iam_policy_document" "worker_assume_role" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole",
    ]
  }
}

resource "aws_iam_role" "worker" {
  name               = var.worker_role_name != null ? var.worker_role_name : "eks-worker-${var.cluster_name}-${var.aws_region}"
  assume_role_policy = data.aws_iam_policy_document.worker_assume_role.json

  tags = local.tags
}

resource "aws_iam_role_policy_attachment" "worker_role_attachment" {
  for_each = toset(compact(distinct(concat(
    [
      "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
      "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
      "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
      "arn:aws:iam::aws:policy/AmazonMSKReadOnlyAccess"
    ],
    var.auto_mode ? [
      # Policies for EKS Auto Mode
      "arn:aws:iam::aws:policy/AmazonEKSWorkerNodeMinimalPolicy",
    ] : [],
    var.worker_iam_role_additional_policies
  ))))

  policy_arn = each.value
  role       = aws_iam_role.worker.name
}

resource "aws_iam_role_policy" "ssm_policy" {
  #checkov:skip=CKV_AWS_290:We can restrict this later on
  #checkov:skip=CKV_AWS_355:We can restrict this later on

  # This allow to use AWS SSM Session Manager to connect to the instances (similar to SSH)

  name = "EnableSessionsManager"
  role = aws_iam_role.worker.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ssm:SendCommand",
          "ssm:UpdateInstanceInformation",
          "ssm:ListInstanceAssociations",
          "ssm:ListAssociations",
          "ec2messages:AcknowledgeMessage",
          "ec2messages:DeleteMessage",
          "ec2messages:FailMessage",
          "ec2messages:GetEndpoint",
          "ec2messages:GetMessages",
          "ec2messages:SendReply",
          "ssmmessages:CreateControlChannel",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:OpenDataChannel"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetEncryptionConfiguration"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy" "cloudwatch_policy" {
  name = "EnableSendingCloudwatchMetrics"
  role = aws_iam_role.worker.name

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

resource "aws_iam_role_policy" "ecr_pull_through_cache_import" {
  # This policy is needed so workers can import images into the ECR pull through cache when pulled for the first time
  name = "ECRPullThroughCacheImport"
  role = aws_iam_role.worker.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["ecr:BatchImportUpstreamImage"]
        Resource = "*"
      }
    ]
  })
}

resource "aws_eks_access_entry" "worker_auto_mode" {
  count = var.auto_mode ? 1 : 0

  cluster_name  = aws_eks_cluster.cluster.id
  principal_arn = aws_iam_role.worker.arn
  type          = "EC2"
}

resource "aws_eks_access_policy_association" "worker_auto_mode" {
  count = var.auto_mode ? 1 : 0

  cluster_name  = var.cluster_name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSAutoNodePolicy"
  principal_arn = aws_iam_role.worker.arn

  access_scope {
    type = "cluster"
  }

  depends_on = [aws_eks_access_entry.worker_auto_mode]
}
