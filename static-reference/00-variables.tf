################################################################################
# Cluster/SSM
################################################################################

variable "active_eks_cluster" {
  description = "Active EKS cluster record for the current AWS account/region"
  type        = object({ name = string, ssm_parameter = string })
}

variable "inactive_eks_cluster" {
  description = "Inactive EKS cluster record for the current AWS account/region"
  type        = object({ name = string, ssm_parameter = string })

  default = null
}

################################################################################
# Tags
################################################################################

variable "tags" {
  description = "Tags to identify resource ownership."

  type = map(string)

  default = { team = "product-infrastructure", impact = "low", service = "eks" }

  validation {
    condition = alltrue([
      contains(keys(var.tags), "team"),
      contains(keys(var.tags), "service"),
      contains(keys(var.tags), "impact"),
    ])

    error_message = "Required tags are missing! Please provide tags 'team', 'service' and 'impact'."
  }
}
