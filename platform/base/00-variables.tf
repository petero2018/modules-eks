variable "eks_cluster" {
  type = string

  description = "Name of the EKS cluster to operate on."
}

variable "eks_version" {
  description = "EKS `<major>.<minor>` version to use for the EKS cluster (i.e.: `1.24`)"
  type        = string
  validation {
    condition     = contains(["1.30", "1.31", "1.32", "1.33"], var.eks_version)
    error_message = "Unsupported EKS Version."
  }
}

variable "aws_account_name" {
  type = string

  description = "AWS account name, used to set static metadata."
}

variable "environment" {
  type = string

  description = "Deploy environment."

  validation {
    condition     = contains(["prod", "dev", "tools", "dr"], var.environment)
    error_message = "Illegal environment."
  }
}

variable "product" {
  type = string

  description = "Name of the product deployed to this cluster."

  default = "generic"

  validation {
    condition     = contains(["generic", "powise", "videoask"], var.product)
    error_message = "Illegal product name."
  }
}

variable "kube_status" {
  type = string

  default     = "active"
  description = "Cluster status. \"active\" or \"inactive\"?"

  validation {
    condition     = contains(["active", "inactive"], var.kube_status)
    error_message = "Illegal cluster status."
  }
}

variable "enable_istio" {
  type = bool

  description = "Enable istio service mesh?"
}

variable "external_registry_auths" {
  type = map(string)

  default = {}

  description = "Map of <external (non-ECR) registry>:<ssm secret key with registry auth> form to be included in common [image pull] credentials."
}

variable "namespaces" {
  type = list(string)

  description = "Namespaces that contain customer facing applications."

  default = []
}

variable "datadog_config" {
  type = object({
    enable_apm  = bool,
    enable_logs = bool,
    site        = optional(string, "datadoghq.com")
  })

  default = {
    enable_apm  = false,
    enable_logs = false,
    site        = "datadoghq.com",
  }

  description = "Datadog config."
}

variable "datadog_api_key" {
  type        = string
  sensitive   = true
  default     = null
  description = "Datadog API key."
}

variable "datadog_app_key" {
  type        = string
  sensitive   = true
  default     = null
  description = "Datadog application key."
}

variable "dd_external_metrics_provider_max_age" {
  type = string

  default     = "120"
  description = "DD_EXTERNAL_METRICS_PROVIDER_MAX_AGE environment variable. Maximum age (in seconds) of a datapoint before considering it invalid to be served. Default to 120 seconds."
}

variable "filebeat_config" {
  type = object({
    output_redis_host = string,
    ignore_services   = optional(list(string), [])
  })

  default = {
    output_redis_host = "logstash-tfprod.zuxcwv.0001.use1.cache.amazonaws.com"
    ignore_services   = []
  }

  description = "Filebeat config."
}

variable "fluentbit_config" {
  type = object({
    static_fields = optional(map(string), {})
    kafka = optional(object(
      {
        enabled  = bool
        brokers  = string
        topic    = string
        username = string
        password = string
      }),
      {
        enabled  = false
        brokers  = null
        topic    = null
        username = null
        password = null
      }
    )
  })

  default     = {}
  description = "Fluentbit config."
}


variable "enable_datadog" {
  type    = bool
  default = true

  description = "Whether to enable datadog monitoring agent."
}

variable "enable_filebeat" {
  type    = bool
  default = true

  description = "Whether to enable filebeat to ship logs."
}

variable "enable_fluentbit" {
  type    = bool
  default = false

  description = "Whether to enable fluentbit to ship logs."
}

variable "external_dns_config" {
  type = object({
    allow_zones  = list(string),
    interval     = optional(string, "1m")
    watch_events = optional(bool, false)
  })

  default = {
    allow_zones = []
  }

  description = "ExternalDNS config."
}

variable "coredns_config" {
  type = object({
    min_replicas = number,
    max_replicas = number,
  })

  default = {
    min_replicas = 4,
    max_replicas = 16,
  }

  description = "CoreDNS config."

  validation {
    condition = var.coredns_config.min_replicas >= 4

    error_message = "\"min_replicas\" should be greater or equal than 4."
  }

  validation {
    condition = var.coredns_config.max_replicas >= var.coredns_config.min_replicas

    error_message = "\"max_replicas\" should be greater or equal than \"min_replicas\"."
  }
}

variable "daemonset_helm_timeout" {
  type = number

  default     = 600
  description = "Timeout to install/update daemonset (Datadog and Filebeat) charts."
}

variable "cluster_autoscaler_config" {
  type = object({
    enabled                          = optional(bool, true)
    scale_down_utilization_threshold = optional(string, "0.6"),
    skip_nodes_with_local_storage    = optional(bool, false),
    scale_down_unneeded_time         = optional(string, "10m"),
    image_tag                        = optional(string, "v1.23.0"),
  })

  description = "Cluster Autoscaler configuration."

  validation {
    condition     = contains(["0.5", "0.6", "0.7", "0.8", "0.9"], var.cluster_autoscaler_config.scale_down_utilization_threshold)
    error_message = "\"scale_down_utilization_threshold\" should be set to a sane value."
  }

  validation {
    condition     = contains(["1m", "2m", "3m", "4m", "5m", "10m"], var.cluster_autoscaler_config.scale_down_unneeded_time)
    error_message = "\"scale_down_unneeded_time\" should be set to a sane value."
  }
}

variable "overprovisioning_configs" {
  type = map(object({
    node_group_name = optional(string)
    pod_tolerations = optional(list(object({
      key      = string
      operator = string
      value    = string
      effect   = string
    })), [])
    replicas = optional(number, 4)
    cpu      = optional(string, "800m")
    memory   = optional(string, "900Mi")
  }))
  description = "Overprovisioning deployments configuration."
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

variable "worker_role_name" {
  type    = string
  default = null

  description = "IAM role name to use for the node identity. The \"role\" field is immutable after EC2NodeClass creation."
}

variable "aws_load_balancer_controller_iam_role_path" {
  description = "IAM role path for IRSA roles."
  type        = string
  default     = null
}

variable "karpenter_config" {
  type = map(object({
    vpc_name = optional(string, "eks") # Used in EKS Auto Mode to target the proper subnets
    block_device_mappings = optional(list(object({
      deviceName = optional(string, "/dev/xvda")
      ebs = optional(object({
        volumeSize          = optional(string, "100Gi")
        volumeType          = optional(string, "gp3")
        iops                = optional(number, 3000)
        throughput          = optional(number, 125)
        encrypted           = optional(bool, true)
        key                 = optional(string, "")
        deleteOnTermination = optional(bool, true)
      }))
    })))
    extra_security_groups_selectors = optional(list(object({ tags = map(string) })), [])
    nodepool_config = optional(object({
      architecture         = optional(list(string), ["arm64", "amd64"])
      os                   = optional(list(string), ["linux"])
      instance_family      = optional(list(string), ["c7g", "m5", "m7g"])
      instance_cpu         = optional(list(string), ["4", "8", "16"])
      instance_generation  = optional(list(string), ["2"])
      capacity_type        = optional(list(string), ["on-demand"])
      consolidation_policy = optional(string, "WhenEmptyOrUnderutilized")
      consolidation_period = optional(string, "30s")
      expire_after         = optional(string, "720h")
      limits = optional(object({
        cpu    = optional(string, "50")
        memory = optional(string, "50Gi")
      }))
      labels = optional(map(string), {})
      taints = optional(list(object({
        key    = string,
        value  = string,
        effect = string
      })), null)
      node_disruption_budgets = optional(list(object({
        nodes    = optional(string, "10%")
        schedule = optional(string)
        duration = optional(string)
        reasons  = optional(list(string))
      })))
    }))
  }))

  default = {}

  description = "Karpenter workload configuration."
}

variable "wazuh_environment" {
  description = "Wazuh environment, should be set to prod in all environments so information is sent to the \"prod\" security account "

  type    = string
  default = "prod"
}

variable "wazuh_agent_config" {
  description = "Config relating to the wazuh agent"

  type = object({
    enable_agent              = bool
    host_package_manager_type = string
  })

  default = {
    enable_agent              = false
    host_package_manager_type = "rpm"
  }
}

variable "tags" {
  description = "Tags to identify resource ownership."

  type = object({
    team    = string
    impact  = string
    service = string
  })

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

variable "aws_region" {
  description = "AWS Region name."
  type        = string
}

variable "rbac_developers_readonly" {
  description = "Sets only read access for users with developer role."
  type        = bool
  default     = true
}

variable "enable_gatekeeper" {
  description = "Whether to install Gatekeeper admission controller in the cluster"
  type        = bool
  default     = false
}

variable "snyk_monitor_config" {
  type = object({
    enabled       = optional(bool, true)
    chart_version = optional(string, "2.2.1")
    api_token     = string
  })
  description = "The version of the snyk-monitor helm chart to install"

  default = {
    enabled       = false
    chart_version = "2.2.1"
    api_token     = ""
  }
}

variable "txt_owner_id" {
  type        = string
  description = "Override for txt_owner_id in external dns. If none given, defaults to cluster name."
  default     = ""
}

variable "datadog_iam_policy_arns" {
  type = list(string)

  default     = []
  description = "List of IAM policy ARNs to attach to the Datadog agent role."
}

variable "msk_cluster_arns" {
  type = list(string)

  default     = []
  description = "AWS MSK Cluster ARNs used for Kafka Metrics."
}

variable "opensearch_urls" {
  type = list(object({
    url       = string
    auth_type = optional(string)
    region    = optional(string, null)
  }))

  default     = []
  description = "List of OpenSearch URLs to monitor."
}

variable "opensearch_arns" {
  type = list(string)

  default     = []
  description = "List of OpenSearch ARNs to allow the Datadog agent to monitor."
}

variable "clickhouse_clusters" {
  type = list(object({
    name          = string
    replica_hosts = list(string)
    port          = optional(number, 9440)
    username      = string
    password      = string
  }))
  sensitive   = true
  default     = []
  description = "List of ClickHouse clusters to monitor."
}

variable "velero_config" {
  type = object({
    enabled       = optional(bool, true)
    chart_version = optional(string, "7.2.1")
    backup_bucket = string
    features      = optional(list(string), ["EnableCSI"])
  })
  description = "Configuration for Velero backup server."

  default = {
    enabled       = false
    chart_version = "7.2.1"
    backup_bucket = ""
    features      = ["EnableCSI"]
  }
}

variable "cert_manager" {
  type = object({
    enabled = optional(bool, false)
    route53_zones = optional(list(object({
      id     = string
      domain = string
    })), [])
  })
  description = "cert-manager configuration."
  default     = {}
}

variable "csi_snapshotter_config" {
  type = object({
    enabled = optional(bool, true)
    version = optional(string, "v8.2.0")
  })
  description = "CSI Snapshotter configuration."
  default = {
    enabled = false
    version = "v8.2.0"
  }
}

variable "deploy_arch" {
  type        = string
  description = "Node architecture to deploy to. Must be either \"amd64\" or \"arm64\""
  default     = "arm64"

  validation {
    condition     = contains(["amd64", "arm64"], var.deploy_arch)
    error_message = "Valid values for node architecture are: (amd64, arm64)"
  }
}

variable "eks_auto_mode" {
  type        = bool
  default     = false
  description = "Set this to true when using EKS Auto Mode."
}
