################################################################################
# Deployment
################################################################################

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

variable "cluster_tags" {
  description = "Extra Tags to be applied to cluster resources."
  type        = map(string)
  default     = {}
}

################################################################################
# User Data
################################################################################

variable "enable_bootstrap_user_data" {
  description = "Determines whether the bootstrap configurations are populated within the user data template"
  type        = bool
  default     = true
}

variable "cluster_name" {
  description = "Name of associated EKS cluster"
  type        = string
  default     = null
}

variable "cluster_endpoint" {
  description = "Endpoint of associated EKS cluster"
  type        = string
  default     = ""
}

variable "cluster_auth_base64" {
  description = "Base64 encoded CA of associated EKS cluster"
  type        = string
  default     = ""
}

variable "cluster_service_ipv4_cidr" {
  description = "The CIDR block to assign Kubernetes service IP addresses from. If you don't specify a block, Kubernetes assigns addresses from either the 10.100.0.0/16 or 172.20.0.0/16 CIDR blocks"
  type        = string
  default     = null
}

variable "pre_bootstrap_user_data" {
  description = "User data that is injected into the user data script ahead of the EKS bootstrap script. Not used when `platform` = `bottlerocket`"
  type        = string
  default     = ""
}

variable "post_bootstrap_user_data" {
  description = "User data that is appended to the user data script after of the EKS bootstrap script. Not used when `platform` = `bottlerocket`"
  type        = string
  default     = ""
}

variable "bootstrap_extra_args" {
  description = "Additional arguments passed to the bootstrap script. When `platform` = `bottlerocket`; these are additional [settings](https://github.com/bottlerocket-os/bottlerocket#settings) that are provided to the Bottlerocket user data"
  type        = string
  default     = ""
}

variable "user_data_template_path" {
  description = "Path to a local, custom user data template file to use when rendering user data"
  type        = string
  default     = ""
}

variable "registry_mirrors" {
  description = "Enables image registry mirror to avoid dockerhub limits. Only available for bottlerocket."
  type        = list(string)
  default     = []
}

################################################################################
# Launch template
################################################################################

variable "launch_template_name" {
  description = "Name of the launch template. If no one is specified it will use the group name as prefix."
  type        = string
  default     = null
}

variable "group_name" {
  description = "Name of the node group."
  type        = string
  default     = "workers"
}

variable "platform" {
  description = "Identifies if the OS platform is `bottlerocket` or `linux` based;"
  type        = string
  default     = "linux"

  validation {
    condition     = contains(["linux", "bottlerocket"], var.platform)
    error_message = "Invalid platform type! Valid values: 'linux' and 'bottlerocket'."
  }
}

variable "architecture" {
  description = "Identifies the IAM architecture. Mandatory if `use_aws_ami` is defined."
  type        = string
  default     = "amd64"

  validation {
    condition     = contains(["amd64", "arm64"], var.architecture)
    error_message = "Invalid architecture type! Valid values: 'amd64' and 'arm64'."
  }
}

variable "gpu_support" {
  description = "Identifies if the IAM needs GPU support."
  type        = bool
  default     = false
}

variable "k8s_version" {
  description = "The K8S version of the cluster. Mandatory if `use_aws_ami` is defined."
  type        = string
  default     = ""
}

variable "ami_id" {
  description = "The AMI from which to launch the instance. If not supplied, EKS will use its own default image"
  type        = string
  default     = null
}

variable "ami_filter_name" {
  description = "Name or wildcard name filter to select the AMI to use for worker nodes."
  type        = string
  default     = null
}

variable "ami_filter_owners" {
  description = "Filter for owners of the AMI when using a name filter to fetch the AMI."
  type        = list(string)
  default     = ["self"]
}

variable "key_name" {
  description = "Key Pair to use for the instance"
  type        = string
  default     = null
}

variable "ebs_optimized" {
  description = "If true, the launched EC2 instance(s) will be EBS-optimized"
  type        = bool
  default     = null
}

variable "cluster_security_group_id" {
  type        = string
  description = "ID of the cluster security group."
}

variable "workers_security_group_id" {
  type        = string
  description = "ID of the security group for the worker nodes."
}

variable "additional_vpc_security_group_ids" {
  description = "A list of security group IDs to associate"
  type        = list(string)
  default     = []
}

variable "launch_template_default_version" {
  description = "Default version of the launch template"
  type        = string
  default     = null
}

variable "update_launch_template_default_version" {
  description = "Whether to update the launch templates default version on each update. Conflicts with `launch_template_default_version`"
  type        = bool
  default     = true
}

variable "block_device_mappings" {
  description = "Specify volumes to attach to the instance besides the volumes specified by the AMI"
  type = list(object({
    device_name : string
    no_device : optional(string)
    virtual_name : optional(string)
    ebs : list(object({
      kms_key_id : optional(string)
      iops : optional(number)
      throughput : optional(number)
      snapshot_id : optional(string)
      volume_size : number
      volume_type : string
    }))
  }))
  default = []
}

variable "spot_enabled" {
  description = "Enable spot instances. This will allow the cluster to use spot instances when available."
  type        = bool
  default     = false
}

variable "spot_max_price" {
  description = "The maximum hourly price you're willing to pay for the Spot Instances."
  type        = number
  default     = null
}

variable "enable_monitoring" {
  description = "Enables/disables detailed monitoring"
  type        = bool
  default     = true
}

variable "launch_template_tags" {
  description = "A map of additional tags to add to the tag_specifications of launch template created"
  type        = map(string)
  default     = {}
}

variable "instance_profile_arn" {
  description = "Instance profile arn to add to the launch template."
  type        = string
  default     = null
}
