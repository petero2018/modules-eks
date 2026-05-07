################################################################################
# Deployment
################################################################################

variable "environment" {
  description = "Deploy environment (\"dev\", \"prod\", \"tools\" or \"dr\")"
  type        = string

  validation {
    condition     = contains(["dev", "prod", "tools", "dr"], var.environment)
    error_message = "Illegal environment name!"
  }
}

variable "aws_region" {
  description = "Name of the AWS region to deploy cluster into"
  type        = string
}

variable "tags" {
  description = "Tags to be applied to resources."
  type        = map(string)

  validation {
    condition = alltrue([
      contains(keys(var.tags), "team"),
      contains(keys(var.tags), "service"),
      contains(keys(var.tags), "impact"),
    ])
    error_message = "Required tags are missing! Please provide tags 'team', 'service' and 'impact'."
  }
}

################################################################################
# Cluster
################################################################################

variable "cluster_name" {
  description = "Name of the EKS cluster to provision"
  type        = string
}

variable "cluster_tags" {
  description = "Extra Tags to be applied to cluster resources."
  type        = map(string)
  default     = {}
}

variable "k8s_version" {
  description = "Kubernetes `<major>.<minor>` version to use for the EKS cluster (i.e.: `1.21`)"
  type        = string
  default     = null

  validation {
    condition     = length(split(".", var.k8s_version)) == 2
    error_message = "Kubernetes version should be `<major>.<minor>`."
  }
}

variable "auto_mode" {
  description = "Whether to enable EKS Auto Mode."
  type        = bool
  default     = false
}

variable "auto_mode_default_node_pools" {
  description = "Whether to create the default built-in node pools."
  type        = bool
  default     = false
}

variable "cluster_service_ipv4_cidr" {
  description = "The CIDR block to assign Kubernetes service IP addresses from. If you don't specify a block, Kubernetes assigns addresses from either the 10.100.0.0/16 or 172.20.0.0/16 CIDR blocks"
  type        = string
  default     = null
}

variable "cluster_encryption_config" {
  description = "Configuration block with encryption configuration for the cluster"
  type = list(object({
    provider_key_arn = string
    resources        = list(string)
  }))
  default = []
}

variable "cluster_timeouts" {
  description = "Create, update, and delete timeout configurations for the cluster"
  type        = map(string)
  default     = {}
}

variable "kubeconfig_discoverable" {
  description = "Whether the cluster should be discoverable by the kubeconfig generation."
  type        = bool
  default     = true
}

variable "kubeconfig_alias" {
  description = "Kubeconfig alias name, used for kubeconfig generation."
  type        = string
}

################################################################################
# CloudWatch Log Group
################################################################################

variable "cloudwatch_log_group_retention_in_days" {
  description = "Number of days to retain log events. Default retention - 30 days"
  type        = number
  default     = 30
}

################################################################################
# Cluster Networking
################################################################################
variable "vpc_id" {
  description = "ID of the VPC where the cluster and its nodes will be provisioned"
  type        = string
  default     = null
}

variable "vpc_name" {
  description = "Name of the VPC where the cluster and its nodes will be provisioned"
  type        = string
  default     = null
}

variable "subnet_ids" {
  description = "A list of subnet IDs where the EKS cluster (ENIs) will be provisioned along with the nodes/node groups. Node groups can be deployed within a different set of subnet IDs from within the node group configuration"
  type        = list(string)
  default     = []
}

variable "subnet_tags" {
  description = "Tags to lookup subnets for Kubernetes cluster (specific subnet IDs will always prevail over this!)."
  type        = map(string)
  default     = { tier = "private" }
}

################################################################################
# Cluster Security Group
################################################################################

variable "enable_public_api" {
  description = "Enables public Kubernetes API endpoint"
  type        = bool
  default     = true
}

variable "public_api_access_cidrs" {
  description = "List of CIDRs allowed to reach the public Kubernetes API endpoint"
  type        = list(string)
  default     = [] # HINT: use "common/ips" module to get them
}

variable "private_api_access_cidrs" {
  description = "List of CIDRs allowed to reach the private Kubernetes API endpoint"
  type        = list(string)
  default     = [] # HINT: use "common/ips" module to get them
}

variable "cluster_security_group_additional_rules" {
  description = "List of additional security group rules to add to the cluster security group created."
  type = map(object({
    protocol                 = string
    from_port                = string
    to_port                  = string
    type                     = string
    description              = optional(string)
    cidr_blocks              = optional(list(string))
    prefix_list_ids          = optional(list(string))
    self                     = optional(bool)
    source_security_group_id = optional(string)
  }))
  default = {}
}

variable "cluster_security_group_extra_tags" {
  description = "Tags to apply to the cluster security group."
  type        = map(string)
  default     = {}
}

################################################################################
# Worker Security Group
################################################################################

variable "share_cluster_security_group" {
  description = "Use cluster created security group for workers [needed for Karpenter to work]"
  type        = bool
  default     = false
}

variable "worker_security_group_additional_rules" {
  description = "List of additional security group rules to add to the workers security group created."
  type = map(object({
    protocol                 = string
    from_port                = string
    to_port                  = string
    type                     = string
    description              = optional(string)
    cidr_blocks              = optional(list(string))
    prefix_list_ids          = optional(list(string))
    self                     = optional(bool)
    source_security_group_id = optional(string)
  }))
  default = {}
}

variable "worker_security_group_extra_tags" {
  description = "Tags to apply to the worker security group."
  type        = map(string)
  default     = {}
}

variable "worker_extra_security_groups" {
  description = "Creates extra worker security groups that can be used by Karpenter node classes."
  type = map(object({
    tags = map(string) # Karpenter node classes can then select security groups based on these tags
    rules = map(object({
      protocol                 = string
      from_port                = string
      to_port                  = string
      type                     = string
      description              = optional(string)
      cidr_blocks              = optional(list(string))
      prefix_list_ids          = optional(list(string))
      self                     = optional(bool)
      source_security_group_id = optional(string)
    }))
  }))
  default = {}
}

################################################################################
# IAM Roles
################################################################################

variable "cluster_role_name" {
  description = "Force this cluster (control plane) IAM role name, otherwise generate the name."
  type        = string
  default     = null
}

variable "worker_role_name" {
  description = "Force this worker IAM role name, otherwise generate the name."
  type        = string
  default     = null
}

variable "cluster_iam_role_additional_policies" {
  description = "Additional policies to be added to the cluster IAM role"
  type        = list(string)
  default     = []
}

variable "worker_iam_role_additional_policies" {
  description = "Additional policies to be added to the worker IAM role"
  type        = list(string)
  default     = []
}

################################################################################
# Key Management Service
################################################################################

variable "extra_kms_roles" {
  description = "Extra roles for accessing KMS Keys created for the EKS"
  type        = list(string)
  default     = []
}
