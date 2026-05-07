################################################################################
# Cluster
################################################################################

variable "eks_clusters" {
  description = "EKS cluster to get OIDC issuer/authorize from."
  type        = list(string)
}

################################################################################
# Namespace
################################################################################

variable "namespace" {
  description = "Kubernetes Namespace name."
  type        = string
}

################################################################################
# Service Account
################################################################################

variable "service_accounts" {
  description = "Kubernetes Service Account Names."
  type        = list(string)
  default     = []
}

variable "allow_any_namespace" {
  description = "Allow Service Account role assumptions from ANY namespace."
  type        = bool
  default     = false
}

################################################################################
# IAM Role
################################################################################

variable "iam_role_name" {
  description = "Name of the IAM role to create."
  type        = string
}

variable "iam_role_path" {
  description = "IAM role path for IRSA roles."
  type        = string
  default     = null
}

variable "iam_permissions_boundary" {
  description = "IAM permissions boundary for IRSA roles."
  type        = string
  default     = ""
}

variable "iam_policy_arns" {
  description = "IAM policy ARNs for IRSA IAM role."
  type        = list(string)
  default     = []
}

variable "iam_policy_documents" {
  description = "Documents to create inline IAM policies for IRSA IAM role."
  type        = map(string)

  default = {}
}

# To ease debug of the roles, e.g. allow admins to assume service roles outside of the cluster
variable "authorized_iam_roles" {
  description = "Additional IAM roles allowed to assume IRSA role, outside of the cluster."
  type        = list(string)
  default     = []
}

################################################################################
# AWS Tags
################################################################################

variable "tags" {
  description = "Tags to be applied to AWS resources."
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
