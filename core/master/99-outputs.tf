output "kubernetes_version" {
  value       = var.k8s_version
  description = "Kubernetes version."
}

output "k8s_version" {
  value       = var.k8s_version
  description = "Kubernetes version."
}

output "environment" {
  value       = var.environment
  description = "Environment name."
}

output "aws_region" {
  value       = var.aws_region
  description = "Name of the AWS region to deployed cluster into."
}

output "vpc_id" {
  value       = local.vpc_id
  description = "VPC ID."
}

output "master_role_arn" {
  value       = aws_iam_role.cluster.arn
  description = "Master IAM role ARN."
}

output "master_role_name" {
  value       = aws_iam_role.cluster.name
  description = "Master IAM role name."
}

output "worker_role_arn" {
  value       = aws_iam_role.worker.arn
  description = "Worker role ARN."
}

output "worker_role_name" {
  value       = aws_iam_role.worker.name
  description = "Worker role name."
}

output "cluster_name" {
  value       = aws_eks_cluster.cluster.name
  description = "EKS cluster name."
}

output "cluster_endpoint" {
  value       = aws_eks_cluster.cluster.endpoint
  description = "EKS cluster endpoint."
}

output "cluster_ca" {
  value       = aws_eks_cluster.cluster.certificate_authority[0].data
  description = "EKS cluster CA. This is the CA that is used to validate the EKS cluster."
}

output "cluster_security_group_id" {
  value       = aws_eks_cluster.cluster.vpc_config[0].cluster_security_group_id
  description = "EKS cluster security group ID."
}

output "workers_security_group_id" {
  value       = local.workers_security_group_id
  description = "Workers security group ID."
}

output "oidc_url" {
  value       = aws_eks_cluster.cluster.identity[0].oidc[0].issuer
  description = "OIDC URL. This is the URL that is used to authenticate with the EKS cluster."
}

output "oidc_host_path" {
  value       = replace(aws_eks_cluster.cluster.identity[0].oidc[0].issuer, "https://", "")
  description = "OIDC host path. The difference with the 'oidc_url' output is that the protocol is stripped out. E.g. 'https://oidc.eks.us-east-1.amazonaws.com/' is 'oidc.eks.us-east-1.amazonaws.com'."
}

output "subnet_ids" {
  value       = local.subnet_ids
  description = "IDs of the VPC subnets we deployed cluster into."
}

output "service_ipv4_cidr" {
  value       = var.cluster_service_ipv4_cidr
  description = "The CIDR block for Kubernetes service IP addresses."
}

output "iam_oidc_provider_arn" {
  value       = aws_iam_openid_connect_provider.oidc.arn
  description = "ARN of the IAM OpenID Connect provider associated with cluster."
}
