data "aws_iam_policy_document" "cluster_assume_role" {
  statement {
    sid = "EKSClusterAssumeRole"

    actions = concat(
      [
        "sts:AssumeRole",
      ],
      var.auto_mode ? [
        "sts:TagSession",
      ] : []
    )

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "auto_mode_tagging" {
  count = var.auto_mode ? 1 : 0

  statement {
    sid    = "Compute"
    effect = "Allow"
    actions = [
      "ec2:CreateFleet",
      "ec2:RunInstances",
      "ec2:CreateLaunchTemplate"
    ]
    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/eks:eks-cluster-name"
      values   = ["$${aws:PrincipalTag/eks:eks-cluster-name}"]
    }

    condition {
      test     = "StringLike"
      variable = "aws:RequestTag/eks:kubernetes-node-class-name"
      values   = ["*"]
    }

    condition {
      test     = "StringLike"
      variable = "aws:RequestTag/eks:kubernetes-node-pool-name"
      values   = ["*"]
    }
  }

  statement {
    sid    = "Storage"
    effect = "Allow"
    actions = [
      "ec2:CreateVolume",
      "ec2:CreateSnapshot"
    ]
    resources = [
      "arn:aws:ec2:*:*:volume/*",
      "arn:aws:ec2:*:*:snapshot/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/eks:eks-cluster-name"
      values   = ["$${aws:PrincipalTag/eks:eks-cluster-name}"]
    }
  }

  statement {
    sid       = "Networking"
    effect    = "Allow"
    actions   = ["ec2:CreateNetworkInterface"]
    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/eks:eks-cluster-name"
      values   = ["$${aws:PrincipalTag/eks:eks-cluster-name}"]
    }

    condition {
      test     = "StringLike"
      variable = "aws:RequestTag/eks:kubernetes-cni-node-name"
      values   = ["*"]
    }
  }

  statement {
    sid    = "LoadBalancer"
    effect = "Allow"
    actions = [
      "elasticloadbalancing:CreateLoadBalancer",
      "elasticloadbalancing:CreateTargetGroup",
      "elasticloadbalancing:CreateListener",
      "elasticloadbalancing:CreateRule",
      "ec2:CreateSecurityGroup"
    ]
    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/eks:eks-cluster-name"
      values   = ["$${aws:PrincipalTag/eks:eks-cluster-name}"]
    }
  }

  statement {
    sid       = "ShieldProtection"
    effect    = "Allow"
    actions   = ["shield:CreateProtection"]
    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/eks:eks-cluster-name"
      values   = ["$${aws:PrincipalTag/eks:eks-cluster-name}"]
    }
  }

  statement {
    sid       = "ShieldTagResource"
    effect    = "Allow"
    actions   = ["shield:TagResource"]
    resources = ["arn:aws:shield::*:protection/*"]

    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/eks:eks-cluster-name"
      values   = ["$${aws:PrincipalTag/eks:eks-cluster-name}"]
    }
  }
}

resource "aws_iam_role" "cluster" {
  name                  = var.cluster_role_name != null ? var.cluster_role_name : "eks-master-${var.cluster_name}-${var.aws_region}"
  assume_role_policy    = data.aws_iam_policy_document.cluster_assume_role.json
  force_detach_policies = true

  tags = local.tags

  lifecycle {
    ignore_changes = [name]
  }
}

resource "aws_iam_role_policy_attachment" "cluster_role_attachment" {
  for_each = toset(compact(distinct(concat(
    [
      "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
      "arn:aws:iam::aws:policy/AmazonEKSServicePolicy",
      # Policy needed to enable support for pod security groups as described here: https://docs.aws.amazon.com/eks/latest/userguide/security-groups-for-pods.html
      "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController",
    ],
    var.auto_mode ? [
      # Policies for EKS Auto Mode
      "arn:aws:iam::aws:policy/AmazonEKSComputePolicy",
      "arn:aws:iam::aws:policy/AmazonEKSBlockStoragePolicy",
      "arn:aws:iam::aws:policy/AmazonEKSLoadBalancingPolicy",
      "arn:aws:iam::aws:policy/AmazonEKSNetworkingPolicy"
    ] : [],
    var.cluster_iam_role_additional_policies
  ))))

  policy_arn = each.value
  role       = aws_iam_role.cluster.name
}

resource "aws_iam_role_policy" "auto_mode_tagging" {
  count = var.auto_mode ? 1 : 0

  name = "AutoModeEC2Tagging"
  role = aws_iam_role.cluster.id

  policy = data.aws_iam_policy_document.auto_mode_tagging[0].json
}
