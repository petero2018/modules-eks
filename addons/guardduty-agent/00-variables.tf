variable "cluster_name" {
  type        = string
  description = "The name of the EKS cluster in which this addon will be created."
}

variable "k8s_version" {
  type        = string
  description = "The version of Kubernetes running on the target cluster."
}

variable "addon_version" {
  type        = string
  description = "The version of the addon to install"
  default     = "default"

  validation {
    condition     = can(regex("default|latest|v[0-9]+\\.[0-9]+\\.[0-9]+-eksbuild.[0-9]+", var.addon_version))
    error_message = "Must specify either a valid version string vX.Y.Z-eksbuild.N, 'default', or 'latest'."
  }
}

variable "vpc_id" {
  type        = string
  description = "The VPC ID used to fetch endpoint configuration"
}
