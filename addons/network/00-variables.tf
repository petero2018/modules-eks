################################################################################
# Cluster configuration
################################################################################

variable "eks_cluster" {
  type = string

  description = "Name of the EKS cluster to operate on."
}

variable "k8s_version" {
  description = "Kubernetes `<major>.<minor>` version to use for the EKS cluster (i.e.: `1.21`)"
  type        = string
}

################################################################################
# Network Modules
################################################################################

variable "enable_kube_proxy" {
  type = bool

  default     = true
  description = "Flag to enable kube proxy"
}

variable "kube_proxy_version" {
  type = string

  default     = null
  description = "Kube proxy version"
}

variable "enable_core_dns" {
  type = bool

  default     = true
  description = "Flag to enable core dns"
}

variable "core_dns_version" {
  type = string

  default     = null
  description = "Core DNS version"
}

################################################################################
# VPC CNI Driver
################################################################################

variable "enable_vpc_cni" {
  type = bool

  default     = true
  description = "Flag to enable VPC CNI"
}

variable "vpc_cni_version" {
  type = string

  default     = null
  description = "VPC CNI Version"
}

variable "vpc_cni_chart_version" {
  type = string

  default     = "1.2.8"
  description = "VPC CNI Chart version"
}

variable "enable_security_group_policies" {
  type = bool

  default     = false
  description = "Enable security group policies (set \"true\" to support security groups for pods)."
}

################################################################################
# Tags
################################################################################

variable "tags" {
  description = "Tags to identify resource ownership."

  type = map(string)

  default = { team = "product-infrastructure", impact = "critical", service = "eks" }

  validation {
    condition = alltrue([
      contains(keys(var.tags), "team"),
      contains(keys(var.tags), "service"),
      contains(keys(var.tags), "impact"),
    ])

    error_message = "Required tags are missing! Please provide tags 'team', 'service' and 'impact'."
  }
}

variable "configuration_values" {
  type    = string
  default = null

  description = "Custom add-on configuration."
}
