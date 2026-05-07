output "active_eks_cluster_name" {
  description = "Name of the active EKS cluster"
  value       = data.aws_eks_cluster.active_eks_cluster.id
}

output "active_eks_cluster_arn" {
  description = "ARN of the active EKS cluster"
  value       = data.aws_eks_cluster.active_eks_cluster.arn
}

output "inactive_eks_cluster_name" {
  description = "Name of the inactive EKS cluster"
  value       = var.inactive_eks_cluster != null ? data.aws_eks_cluster.inactive_eks_cluster[0].id : null
}

output "inactive_eks_cluster_arn" {
  description = "ARN of the inactive EKS cluster"
  value       = var.inactive_eks_cluster != null ? data.aws_eks_cluster.inactive_eks_cluster[0].arn : null
}
