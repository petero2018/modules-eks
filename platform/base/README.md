# base

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >=4.0.0 |
| <a name="requirement_datadog"></a> [datadog](#requirement\_datadog) | >= 3.30.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | <3 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.29.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >=4.0.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >= 2.29.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aws_load_balancer_controller"></a> [aws\_load\_balancer\_controller](#module\_aws\_load\_balancer\_controller) | git@github.com:powise/terraform-modules//k8s/core/aws-load-balancer-controller | aws-load-balancer-controller-0.6.2 |
| <a name="module_cert_manager"></a> [cert\_manager](#module\_cert\_manager) | git@github.com:powise/terraform-modules//k8s/cert-manager | cert-manager-0.0.4 |
| <a name="module_cluster_autoscaler"></a> [cluster\_autoscaler](#module\_cluster\_autoscaler) | ../../..//k8s/core/cluster-autoscaler | n/a |
| <a name="module_coredns_hpa"></a> [coredns\_hpa](#module\_coredns\_hpa) | git@github.com:powise/terraform-modules//k8s/hpa | k8s-hpa-0.2.0 |
| <a name="module_csi_snapshotter"></a> [csi\_snapshotter](#module\_csi\_snapshotter) | git@github.com:powise/terraform-modules//k8s/core/csi-snapshotter | core-csi-snapshotter-0.1.0 |
| <a name="module_datadog"></a> [datadog](#module\_datadog) | git@github.com:powise/terraform-modules//k8s/datadog | datadog-1.8.6 |
| <a name="module_external_dns"></a> [external\_dns](#module\_external\_dns) | git@github.com:powise/terraform-modules//k8s/core/external-dns | external-dns-0.2.0 |
| <a name="module_filebeat"></a> [filebeat](#module\_filebeat) | git@github.com:powise/terraform-modules//k8s/filebeat | filebeat-0.5.1 |
| <a name="module_fluentbit"></a> [fluentbit](#module\_fluentbit) | git@github.com:powise/terraform-modules//k8s/fluentbit | fluentbit-0.2.3 |
| <a name="module_gatekeeper"></a> [gatekeeper](#module\_gatekeeper) | git@github.com:powise/terraform-modules//k8s/gatekeeper | gatekeeper-0.2.0 |
| <a name="module_karpenter_workload"></a> [karpenter\_workload](#module\_karpenter\_workload) | ../../..//k8s/core/karpenter-workload | n/a |
| <a name="module_metrics_server"></a> [metrics\_server](#module\_metrics\_server) | git@github.com:powise/terraform-modules//k8s/core/metrics-server | core-metrics-server-0.1.0 |
| <a name="module_namespace"></a> [namespace](#module\_namespace) | git@github.com:powise/terraform-modules//k8s/core/namespace | core-namespace-2.2.2 |
| <a name="module_snyk_monitor"></a> [snyk\_monitor](#module\_snyk\_monitor) | git@github.com:powise/terraform-modules//k8s/snyk | snyk-4.1.1 |
| <a name="module_velero"></a> [velero](#module\_velero) | git@github.com:powise/terraform-modules//k8s/velero | velero-0.2.0 |
| <a name="module_wazuh_agent"></a> [wazuh\_agent](#module\_wazuh\_agent) | git@github.com:powise/terraform-modules//security/wazuh-agent | wazuh-agent-0.8.2 |

## Resources

| Name | Type |
|------|------|
| [kubernetes_deployment.overprovisioning](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment) | resource |
| [kubernetes_namespace.overprovisioning](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_priority_class.overprovisioning](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/priority_class) | resource |
| [aws_route53_zone.external_dns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_autoscale_with"></a> [autoscale\_with](#input\_autoscale\_with) | Which mechanism use to scale the cluster. | `string` | `"cluster-autoscaler"` | no |
| <a name="input_aws_account_name"></a> [aws\_account\_name](#input\_aws\_account\_name) | AWS account name, used to set static metadata. | `string` | n/a | yes |
| <a name="input_aws_load_balancer_controller_iam_role_path"></a> [aws\_load\_balancer\_controller\_iam\_role\_path](#input\_aws\_load\_balancer\_controller\_iam\_role\_path) | IAM role path for IRSA roles. | `string` | `null` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS Region name. | `string` | n/a | yes |
| <a name="input_cert_manager"></a> [cert\_manager](#input\_cert\_manager) | cert-manager configuration. | <pre>object({<br>    enabled = optional(bool, false)<br>    route53_zones = optional(list(object({<br>      id     = string<br>      domain = string<br>    })), [])<br>  })</pre> | `{}` | no |
| <a name="input_clickhouse_clusters"></a> [clickhouse\_clusters](#input\_clickhouse\_clusters) | List of ClickHouse clusters to monitor. | <pre>list(object({<br>    name          = string<br>    replica_hosts = list(string)<br>    port          = optional(number, 9440)<br>    username      = string<br>    password      = string<br>  }))</pre> | `[]` | no |
| <a name="input_cluster_autoscaler_config"></a> [cluster\_autoscaler\_config](#input\_cluster\_autoscaler\_config) | Cluster Autoscaler configuration. | <pre>object({<br>    enabled                          = optional(bool, true)<br>    scale_down_utilization_threshold = optional(string, "0.6"),<br>    skip_nodes_with_local_storage    = optional(bool, false),<br>    scale_down_unneeded_time         = optional(string, "10m"),<br>    image_tag                        = optional(string, "v1.23.0"),<br>  })</pre> | n/a | yes |
| <a name="input_coredns_config"></a> [coredns\_config](#input\_coredns\_config) | CoreDNS config. | <pre>object({<br>    min_replicas = number,<br>    max_replicas = number,<br>  })</pre> | <pre>{<br>  "max_replicas": 16,<br>  "min_replicas": 4<br>}</pre> | no |
| <a name="input_csi_snapshotter_config"></a> [csi\_snapshotter\_config](#input\_csi\_snapshotter\_config) | CSI Snapshotter configuration. | <pre>object({<br>    enabled = optional(bool, true)<br>    version = optional(string, "v8.2.0")<br>  })</pre> | <pre>{<br>  "enabled": false,<br>  "version": "v8.2.0"<br>}</pre> | no |
| <a name="input_daemonset_helm_timeout"></a> [daemonset\_helm\_timeout](#input\_daemonset\_helm\_timeout) | Timeout to install/update daemonset (Datadog and Filebeat) charts. | `number` | `600` | no |
| <a name="input_datadog_api_key"></a> [datadog\_api\_key](#input\_datadog\_api\_key) | Datadog API key. | `string` | `null` | no |
| <a name="input_datadog_app_key"></a> [datadog\_app\_key](#input\_datadog\_app\_key) | Datadog application key. | `string` | `null` | no |
| <a name="input_datadog_config"></a> [datadog\_config](#input\_datadog\_config) | Datadog config. | <pre>object({<br>    enable_apm  = bool,<br>    enable_logs = bool,<br>    site        = optional(string, "datadoghq.com")<br>  })</pre> | <pre>{<br>  "enable_apm": false,<br>  "enable_logs": false,<br>  "site": "datadoghq.com"<br>}</pre> | no |
| <a name="input_datadog_iam_policy_arns"></a> [datadog\_iam\_policy\_arns](#input\_datadog\_iam\_policy\_arns) | List of IAM policy ARNs to attach to the Datadog agent role. | `list(string)` | `[]` | no |
| <a name="input_dd_external_metrics_provider_max_age"></a> [dd\_external\_metrics\_provider\_max\_age](#input\_dd\_external\_metrics\_provider\_max\_age) | DD\_EXTERNAL\_METRICS\_PROVIDER\_MAX\_AGE environment variable. Maximum age (in seconds) of a datapoint before considering it invalid to be served. Default to 120 seconds. | `string` | `"120"` | no |
| <a name="input_deploy_arch"></a> [deploy\_arch](#input\_deploy\_arch) | Node architecture to deploy to. Must be either "amd64" or "arm64" | `string` | `"arm64"` | no |
| <a name="input_eks_auto_mode"></a> [eks\_auto\_mode](#input\_eks\_auto\_mode) | Set this to true when using EKS Auto Mode. | `bool` | `false` | no |
| <a name="input_eks_cluster"></a> [eks\_cluster](#input\_eks\_cluster) | Name of the EKS cluster to operate on. | `string` | n/a | yes |
| <a name="input_eks_version"></a> [eks\_version](#input\_eks\_version) | EKS `<major>.<minor>` version to use for the EKS cluster (i.e.: `1.24`) | `string` | n/a | yes |
| <a name="input_enable_datadog"></a> [enable\_datadog](#input\_enable\_datadog) | Whether to enable datadog monitoring agent. | `bool` | `true` | no |
| <a name="input_enable_filebeat"></a> [enable\_filebeat](#input\_enable\_filebeat) | Whether to enable filebeat to ship logs. | `bool` | `true` | no |
| <a name="input_enable_fluentbit"></a> [enable\_fluentbit](#input\_enable\_fluentbit) | Whether to enable fluentbit to ship logs. | `bool` | `false` | no |
| <a name="input_enable_gatekeeper"></a> [enable\_gatekeeper](#input\_enable\_gatekeeper) | Whether to install Gatekeeper admission controller in the cluster | `bool` | `false` | no |
| <a name="input_enable_istio"></a> [enable\_istio](#input\_enable\_istio) | Enable istio service mesh? | `bool` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Deploy environment. | `string` | n/a | yes |
| <a name="input_external_dns_config"></a> [external\_dns\_config](#input\_external\_dns\_config) | ExternalDNS config. | <pre>object({<br>    allow_zones  = list(string),<br>    interval     = optional(string, "1m")<br>    watch_events = optional(bool, false)<br>  })</pre> | <pre>{<br>  "allow_zones": []<br>}</pre> | no |
| <a name="input_external_registry_auths"></a> [external\_registry\_auths](#input\_external\_registry\_auths) | Map of <external (non-ECR) registry>:<ssm secret key with registry auth> form to be included in common [image pull] credentials. | `map(string)` | `{}` | no |
| <a name="input_filebeat_config"></a> [filebeat\_config](#input\_filebeat\_config) | Filebeat config. | <pre>object({<br>    output_redis_host = string,<br>    ignore_services   = optional(list(string), [])<br>  })</pre> | <pre>{<br>  "ignore_services": [],<br>  "output_redis_host": "logstash-tfprod.zuxcwv.0001.use1.cache.amazonaws.com"<br>}</pre> | no |
| <a name="input_fluentbit_config"></a> [fluentbit\_config](#input\_fluentbit\_config) | Fluentbit config. | <pre>object({<br>    static_fields = optional(map(string), {})<br>    kafka = optional(object(<br>      {<br>        enabled  = bool<br>        brokers  = string<br>        topic    = string<br>        username = string<br>        password = string<br>      }),<br>      {<br>        enabled  = false<br>        brokers  = null<br>        topic    = null<br>        username = null<br>        password = null<br>      }<br>    )<br>  })</pre> | `{}` | no |
| <a name="input_karpenter_config"></a> [karpenter\_config](#input\_karpenter\_config) | Karpenter workload configuration. | <pre>map(object({<br>    vpc_name = optional(string, "eks") # Used in EKS Auto Mode to target the proper subnets<br>    block_device_mappings = optional(list(object({<br>      deviceName = optional(string, "/dev/xvda")<br>      ebs = optional(object({<br>        volumeSize          = optional(string, "100Gi")<br>        volumeType          = optional(string, "gp3")<br>        iops                = optional(number, 3000)<br>        throughput          = optional(number, 125)<br>        encrypted           = optional(bool, true)<br>        key                 = optional(string, "")<br>        deleteOnTermination = optional(bool, true)<br>      }))<br>    })))<br>    extra_security_groups_selectors = optional(list(object({ tags = map(string) })), [])<br>    nodepool_config = optional(object({<br>      architecture         = optional(list(string), ["arm64", "amd64"])<br>      os                   = optional(list(string), ["linux"])<br>      instance_family      = optional(list(string), ["c7g", "m5", "m7g"])<br>      instance_cpu         = optional(list(string), ["4", "8", "16"])<br>      instance_generation  = optional(list(string), ["2"])<br>      capacity_type        = optional(list(string), ["on-demand"])<br>      consolidation_policy = optional(string, "WhenEmptyOrUnderutilized")<br>      consolidation_period = optional(string, "30s")<br>      expire_after         = optional(string, "720h")<br>      limits = optional(object({<br>        cpu    = optional(string, "50")<br>        memory = optional(string, "50Gi")<br>      }))<br>      labels = optional(map(string), {})<br>      taints = optional(list(object({<br>        key    = string,<br>        value  = string,<br>        effect = string<br>      })), null)<br>      node_disruption_budgets = optional(list(object({<br>        nodes    = optional(string, "10%")<br>        schedule = optional(string)<br>        duration = optional(string)<br>        reasons  = optional(list(string))<br>      })))<br>    }))<br>  }))</pre> | `{}` | no |
| <a name="input_kube_status"></a> [kube\_status](#input\_kube\_status) | Cluster status. "active" or "inactive"? | `string` | `"active"` | no |
| <a name="input_msk_cluster_arns"></a> [msk\_cluster\_arns](#input\_msk\_cluster\_arns) | AWS MSK Cluster ARNs used for Kafka Metrics. | `list(string)` | `[]` | no |
| <a name="input_namespaces"></a> [namespaces](#input\_namespaces) | Namespaces that contain customer facing applications. | `list(string)` | `[]` | no |
| <a name="input_opensearch_arns"></a> [opensearch\_arns](#input\_opensearch\_arns) | List of OpenSearch ARNs to allow the Datadog agent to monitor. | `list(string)` | `[]` | no |
| <a name="input_opensearch_urls"></a> [opensearch\_urls](#input\_opensearch\_urls) | List of OpenSearch URLs to monitor. | <pre>list(object({<br>    url       = string<br>    auth_type = optional(string)<br>    region    = optional(string, null)<br>  }))</pre> | `[]` | no |
| <a name="input_overprovisioning_configs"></a> [overprovisioning\_configs](#input\_overprovisioning\_configs) | Overprovisioning deployments configuration. | <pre>map(object({<br>    node_group_name = optional(string)<br>    pod_tolerations = optional(list(object({<br>      key      = string<br>      operator = string<br>      value    = string<br>      effect   = string<br>    })), [])<br>    replicas = optional(number, 4)<br>    cpu      = optional(string, "800m")<br>    memory   = optional(string, "900Mi")<br>  }))</pre> | n/a | yes |
| <a name="input_product"></a> [product](#input\_product) | Name of the product deployed to this cluster. | `string` | `"generic"` | no |
| <a name="input_rbac_developers_readonly"></a> [rbac\_developers\_readonly](#input\_rbac\_developers\_readonly) | Sets only read access for users with developer role. | `bool` | `true` | no |
| <a name="input_snyk_monitor_config"></a> [snyk\_monitor\_config](#input\_snyk\_monitor\_config) | The version of the snyk-monitor helm chart to install | <pre>object({<br>    enabled       = optional(bool, true)<br>    chart_version = optional(string, "2.2.1")<br>    api_token     = string<br>  })</pre> | <pre>{<br>  "api_token": "",<br>  "chart_version": "2.2.1",<br>  "enabled": false<br>}</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to identify resource ownership. | <pre>object({<br>    team    = string<br>    impact  = string<br>    service = string<br>  })</pre> | <pre>{<br>  "impact": "critical",<br>  "service": "eks",<br>  "team": "product-infrastructure"<br>}</pre> | no |
| <a name="input_txt_owner_id"></a> [txt\_owner\_id](#input\_txt\_owner\_id) | Override for txt\_owner\_id in external dns. If none given, defaults to cluster name. | `string` | `""` | no |
| <a name="input_velero_config"></a> [velero\_config](#input\_velero\_config) | Configuration for Velero backup server. | <pre>object({<br>    enabled       = optional(bool, true)<br>    chart_version = optional(string, "7.2.1")<br>    backup_bucket = string<br>    features      = optional(list(string), ["EnableCSI"])<br>  })</pre> | <pre>{<br>  "backup_bucket": "",<br>  "chart_version": "7.2.1",<br>  "enabled": false,<br>  "features": [<br>    "EnableCSI"<br>  ]<br>}</pre> | no |
| <a name="input_wazuh_agent_config"></a> [wazuh\_agent\_config](#input\_wazuh\_agent\_config) | Config relating to the wazuh agent | <pre>object({<br>    enable_agent              = bool<br>    host_package_manager_type = string<br>  })</pre> | <pre>{<br>  "enable_agent": false,<br>  "host_package_manager_type": "rpm"<br>}</pre> | no |
| <a name="input_wazuh_environment"></a> [wazuh\_environment](#input\_wazuh\_environment) | Wazuh environment, should be set to prod in all environments so information is sent to the "prod" security account | `string` | `"prod"` | no |
| <a name="input_worker_role_name"></a> [worker\_role\_name](#input\_worker\_role\_name) | IAM role name to use for the node identity. The "role" field is immutable after EC2NodeClass creation. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_datadog_api_key"></a> [datadog\_api\_key](#output\_datadog\_api\_key) | Datadog API key. |
| <a name="output_datadog_app_key"></a> [datadog\_app\_key](#output\_datadog\_app\_key) | Datadog application key. |
| <a name="output_namespaces"></a> [namespaces](#output\_namespaces) | List of namespaces provisioned. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
