variable "eks_cluster" {
  type = string

  description = "Name of the EKS cluster to operate on."

  validation {
    condition     = length(split("-", var.eks_cluster)) == 2
    error_message = "Cluster name should be passed in ENV-CLUSTER form."
  }
}

variable "aws_region" {
  type = string

  description = "Name of the AWS region where the EKS cluster is deployed."
}

variable "aws_account_id" {
  type = number

  description = "ID of the AWS account where the EKS cluster is deployed."
}

variable "karpenter_chart_version" {
  type = string

  description = "Karpenter chart version - must be at least 1.0.1."
}

variable "worker_role_arn" {
  type = string

  description = "IAM role ARN to use to set PassRole permissions on controller role."
}

variable "enable_spot_termination" {
  type = bool

  default     = false
  description = "Enable spot instance termination handling via SQS and EventBridge."
}

variable "install_crds" {
  type    = bool
  default = false

  description = "CRDs appropriate for the current version will be managed using the separate Helm chart."
}

variable "tags" {
  type        = map(string)
  description = "Tags to be applied to AWS resources."

  validation {
    condition = alltrue([
      contains(keys(var.tags), "team"),
      contains(keys(var.tags), "service"),
      contains(keys(var.tags), "impact"),
    ])
    error_message = "Required tags are missing! Please provide tags 'team', 'service' and 'impact'."
  }
}
