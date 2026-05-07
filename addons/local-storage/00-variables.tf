variable "namespace" {
  type        = string
  default     = "kube-system"
  description = "The namespace to set up resources in."
}

variable "local_storage_driver_version" {
  type        = string
  description = "Version of local-volume-provisioner."
}
