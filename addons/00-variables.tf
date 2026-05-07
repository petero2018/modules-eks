################################################################################
# Cluster configuration
################################################################################

variable "eks_cluster" {
  type = string

  description = "Name of the EKS cluster to operate on."
}

variable "eks_auto_mode" {
  type        = bool
  default     = false
  description = "Set this to true when using EKS Auto Mode."
}

variable "aws_region" {
  description = "Region name where the cluster is running. This is used for IAM roles naming."
  type        = string
}

variable "aws_account_id" {
  description = "ID of the AWS account where the EKS cluster is deployed."

  type = string
}

variable "k8s_version" {
  description = "Kubernetes `<major>.<minor>` version to use for the EKS cluster (i.e.: `1.21`)"
  type        = string

  validation {
    condition     = length(split(".", var.k8s_version)) == 2
    error_message = "Kubernetes version should be `<major>.<minor>`."
  }
}

variable "autoscale_with" {
  type    = string
  default = "cluster-autoscaler"

  validation {
    condition     = contains(["cluster-autoscaler", "karpenter", "no-autoscaling"], var.autoscale_with)
    error_message = "Illegal autoscaling mechanism, choose \"cluster-autoscaler\", \"karpenter\" or \"no-autoscaling\"."
  }

  description = "Which mechanism use to scale the cluster."
}

variable "karpenter_chart_version" {
  type    = string
  default = "1.0.1"

  description = "Karpenter chart version - must be at least 1.0.1."
}

variable "worker_role_arn" {
  type    = string
  default = null

  description = "IAM role ARN to use to set PassRole permissions on controller role."
}

variable "enable_spot_termination" {
  type = bool

  default     = false
  description = "Enable spot instance termination handling via SQS and EventBridge."
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

  # See https://docs.aws.amazon.com/eks/latest/userguide/managing-kube-proxy.html If set to null, will use:
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_addon_version
  default     = null
  description = "Kube proxy version to install"
}

variable "enable_core_dns" {
  type = bool

  default     = true
  description = "Flag to enable core dns"
}

variable "core_dns_version" {
  type = string

  # See https://docs.aws.amazon.com/eks/latest/userguide/managing-coredns.html If set to null, will use:
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_addon_version
  default     = null
  description = "Core DNS version to install"
}

################################################################################
# VPC CNI Driver
################################################################################

variable "enable_vpc_cni" {
  type = bool

  default     = true
  description = "Flag to enable VPC CNI"
}

variable "enable_security_group_policies" {
  type = bool

  default     = false
  description = "Enable security group policies (set \"true\" to support security groups for pods)."
}

variable "vpc_cni_version" {
  type = string

  # See https://docs.aws.amazon.com/eks/latest/userguide/managing-vpc-cni.html If set to null, will use:
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_addon_version
  default     = null
  description = "VPC CNI Version"
}

variable "vpc_cni_chart_version" {
  type = string

  default     = "1.2.8"
  description = "VPC CNI Chart version"
}

################################################################################
# Enable Secret Store
################################################################################

variable "enable_secret_store_csi" {
  type = bool

  default     = true
  description = "Enable AWS Secrets Store CSI driver addon"
}

variable "enable_secrets_store_csi_driver" {
  type = bool

  default     = false
  description = "Enable Secrets Store CSI Driver (required for AWS Secrets Store CSI)"
}

variable "secrets_store_csi_driver_chart_version" {
  type = string

  default     = "1.3.4"
  description = "Secrets Store CSI Driver chart version"
}

variable "secrets_store_csi_driver_repository" {
  type = string

  default     = "https://kubernetes-sigs.github.io/secrets-store-csi-driver/charts"
  description = "The Helm chart repository URL for the Secrets Store CSI Driver"
}

variable "secrets_store_csi_driver_chart_name" {
  type = string

  default     = "secrets-store-csi-driver"
  description = "The name of the Helm chart for the Secrets Store CSI Driver"
}

variable "secret_store_csi_chart_version" {
  type = string

  default     = "0.0.3"
  description = "AWS Secrets Store CSI Driver chart version"
}

variable "secret_store_csi_repository" {
  type = string

  default     = "https://aws.github.io/eks-charts"
  description = "The Helm chart repository URL for the AWS Secrets Store CSI Driver"
}

variable "secret_store_csi_chart_name" {
  type = string

  default     = "csi-secrets-store-provider-aws"
  description = "The name of the Helm chart for the AWS Secrets Store CSI Driver"
}

################################################################################
# EBS CSI Driver
################################################################################

variable "enable_ebs_csi_driver" {
  type = bool

  default     = false
  description = "Enable Amazon EBS CSI driver addon"
}

variable "ebs_csi_version" {
  type = string

  # See https://docs.aws.amazon.com/eks/latest/userguide/managing-ebs-csi.html If set to null, will use:
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_addon_version
  default     = null
  description = "EBS CSI Version to install"
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
# Local storage driver
################################################################################

variable "enable_local_storage_driver" {
  type = bool

  default     = false
  description = "Enable local storage driver addon."
}

variable "local_storage_driver_version" {
  type = string

  default     = "v2.7.0"
  description = "Version of local-volume-provisioner."
}

################################################################################
# GaurdDuty agent - EKS Runtime monitoring
################################################################################

variable "vpc_id" {
  type = string

  default     = null
  description = "The VPC ID used to fetch the guardduty endpoint status"
}

variable "enable_guardduty_agent" {
  type = bool

  default     = false
  description = "Enable the guardduty agent for EKS runtime monitoring."
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
