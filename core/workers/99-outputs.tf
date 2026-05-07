output "node_group_name" {
  value       = var.group_name
  description = "The name of the node group."
}

output "node_groups" {
  description = "Outputs from EKS node groups. Map of maps, keyed by `var.node_groups` keys. See `aws_eks_node_group` Terraform documentation for values"
  value       = var.support_autoscaling ? aws_eks_node_group.workers_autoscaling[0] : aws_eks_node_group.workers_static[0]
}
