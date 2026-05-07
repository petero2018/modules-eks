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

variable "aws_region" {
  description = "Region name where the cluster is running. This is used for IAM roles naming."
  type        = string
  default     = ""
}

################################################################################
# EBS CSI Driver
################################################################################

variable "ebs_csi_version" {
  type = string

  default     = "v1.13.0-eksbuild.2"
  description = "EBS CSI Version to install"
}

variable "delete_default_storage_class" {
  type = bool

  default     = true
  description = "Flag to delete the default storage class."
}

variable "storage_classes" {
  description = "EBS Storage Classes to create."

  type = map(object({
    # https://kubernetes.io/docs/concepts/storage/storage-classes/#aws-ebs
    # A flag to specify if should be the default storage class to use
    default = optional(bool)
    # It describes the Kubernetes action when the PV is released.
    # - Retain: When an associated PersistentVolumeClaim is deleted, the PersistentVolume will continue to be present.
    # - Delete: The PersistentVolume object and its associated storage volume are deleted when the PersistentVolumeClaim is deleted. (default)
    reclaim_policy = optional(bool)
    # Linux mount options to apply to PVCs created with this storage class.
    mount_options = optional(list(string))
    # PersistentVolumes can be configured to be expandable. This feature when set to true, allows the users to resize the volume by editing the corresponding PVC object. (true by default)
    allow_volume_expansion = optional(bool)
    # https://github.com/kubernetes-sigs/aws-ebs-csi-driver/blob/master/docs/parameters.md
    # File system type that will be formatted during volume creation. (xfs, ext2, ext3, ext4) (default: ext4)
    file_system = optional(string)
    # EBS volume type (io1, io2, gp2, gp3, sc1, st1, standard) (default: gp3)
    volume_type = optional(string)
    # I/O operations per second per GiB. Required when io1 or io2 volume type is specified.
    iops_per_gb = optional(number)
    # When true the CSI driver increases IOPS for a volume when iopsPerGB * <volume size> is too low to fit into IOPS range supported by AWS. (false by default)
    auto_iops = optional(bool)
    # I/O operations per second. Only effetive when gp3 volume type is specified. (default: 3000)
    iops = optional(number)
    # Throughput in MiB/s. Only effective when gp3 volume type is specified. (default: 125MiB/s)
    throughput = optional(number)
    # Whether the volume should be encrypted or not. (by default encrypt volumes)
    encrypted = optional(bool)
    # The full ARN of the key to use when encrypting the volume. (by default it will use the aws managed one)
    kms_key = optional(string)
    # https://github.com/kubernetes-sigs/aws-ebs-csi-driver/blob/master/docs/tagging.md
    # Tags to apply to the volume
    tags = optional(map(string))
  }))

  default = {
    gp3 = {
      default     = true
      file_system = "ext4"
      volume_type = "gp3"
      encrypted   = true
    }
  }
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
