data "aws_eks_cluster" "cluster" {
  for_each = toset(var.eks_clusters)
  name     = each.value
}

data "aws_caller_identity" "current" {}
