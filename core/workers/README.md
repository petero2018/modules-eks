# workers

This module creates and configures a worker node group for an eks cluster.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_launch_template"></a> [launch\_template](#module\_launch\_template) | ./launch-template | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_eks_node_group.workers_autoscaling](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_eks_node_group.workers_static](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_iam_role.worker](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.worker_cloudwatch_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.worker_role_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_policy_document.worker_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_vpc_security_group_ids"></a> [additional\_vpc\_security\_group\_ids](#input\_additional\_vpc\_security\_group\_ids) | A list of security group IDs to associate | `list(string)` | `[]` | no |
| <a name="input_ami_filter_name"></a> [ami\_filter\_name](#input\_ami\_filter\_name) | Name or wildcard name filter to select the AMI to use for worker nodes. | `string` | `null` | no |
| <a name="input_ami_filter_owners"></a> [ami\_filter\_owners](#input\_ami\_filter\_owners) | Filter for owners of the AMI when using a name filter to fetch the AMI. | `list(string)` | <pre>[<br>  "self"<br>]</pre> | no |
| <a name="input_ami_id"></a> [ami\_id](#input\_ami\_id) | The AMI from which to launch the instance. If not supplied, EKS will use its own default image | `string` | `null` | no |
| <a name="input_architecture"></a> [architecture](#input\_architecture) | Identifies the IAM architecture. Mandatory if `use_aws_ami` is defined. | `string` | `"amd64"` | no |
| <a name="input_block_device_mappings"></a> [block\_device\_mappings](#input\_block\_device\_mappings) | Specify volumes to attach to the instance besides the volumes specified by the AMI | <pre>list(object({<br>    device_name : string<br>    no_device : optional(string)<br>    virtual_name : optional(string)<br>    ebs : list(object({<br>      kms_key_id : optional(string)<br>      iops : optional(number)<br>      throughput : optional(number)<br>      snapshot_id : optional(string)<br>      volume_size : number<br>      volume_type : string<br>    }))<br>  }))</pre> | `[]` | no |
| <a name="input_bootstrap_extra_args"></a> [bootstrap\_extra\_args](#input\_bootstrap\_extra\_args) | Additional arguments passed to the bootstrap script. When `platform` = `bottlerocket`; these are additional [settings](https://github.com/bottlerocket-os/bottlerocket#settings) that are provided to the Bottlerocket user data | `string` | `""` | no |
| <a name="input_cluster_auth_base64"></a> [cluster\_auth\_base64](#input\_cluster\_auth\_base64) | Base64 encoded CA of associated EKS cluster | `string` | `""` | no |
| <a name="input_cluster_endpoint"></a> [cluster\_endpoint](#input\_cluster\_endpoint) | Endpoint of associated EKS cluster | `string` | `""` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of associated EKS cluster | `string` | `null` | no |
| <a name="input_cluster_security_group_id"></a> [cluster\_security\_group\_id](#input\_cluster\_security\_group\_id) | ID of the cluster security group. | `string` | n/a | yes |
| <a name="input_cluster_service_ipv4_cidr"></a> [cluster\_service\_ipv4\_cidr](#input\_cluster\_service\_ipv4\_cidr) | The CIDR block to assign Kubernetes service IP addresses from. If you don't specify a block, Kubernetes assigns addresses from either the 10.100.0.0/16 or 172.20.0.0/16 CIDR blocks | `string` | `null` | no |
| <a name="input_cluster_tags"></a> [cluster\_tags](#input\_cluster\_tags) | Extra Tags to be applied to cluster resources. | `map(string)` | `{}` | no |
| <a name="input_create_worker_role"></a> [create\_worker\_role](#input\_create\_worker\_role) | Create a worker role of this name instead of using IAM role ARN supplied. | `string` | `null` | no |
| <a name="input_desired_worker_count"></a> [desired\_worker\_count](#input\_desired\_worker\_count) | Number of worker nodes to start as desired. This is the number of worker nodes that will be started when the cluster is created. | `number` | `2` | no |
| <a name="input_ebs_optimized"></a> [ebs\_optimized](#input\_ebs\_optimized) | If true, the launched EC2 instance(s) will be EBS-optimized | `bool` | `null` | no |
| <a name="input_enable_bootstrap_user_data"></a> [enable\_bootstrap\_user\_data](#input\_enable\_bootstrap\_user\_data) | Determines whether the bootstrap configurations are populated within the user data template | `bool` | `true` | no |
| <a name="input_enable_monitoring"></a> [enable\_monitoring](#input\_enable\_monitoring) | Enables/disables detailed monitoring | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Deploy environment ("dev", "prod", "tools" or "dr") | `string` | n/a | yes |
| <a name="input_gpu_support"></a> [gpu\_support](#input\_gpu\_support) | Identifies if the IAM needs GPU support. | `bool` | `false` | no |
| <a name="input_group_name"></a> [group\_name](#input\_group\_name) | Name of the node group. | `string` | `"workers"` | no |
| <a name="input_instance_profile_arn"></a> [instance\_profile\_arn](#input\_instance\_profile\_arn) | Instance profile arn to add to the launch template. | `string` | `null` | no |
| <a name="input_instance_types"></a> [instance\_types](#input\_instance\_types) | List of instance types to use. (e.g. ["t3.medium", "t3.large"]) | `list(string)` | <pre>[<br>  "t3.medium"<br>]</pre> | no |
| <a name="input_k8s_version"></a> [k8s\_version](#input\_k8s\_version) | The K8S version of the cluster. Mandatory if `use_aws_ami` is defined. | `string` | `""` | no |
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | Key Pair to use for the instance | `string` | `null` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | Key-value map of Kubernetes labels attached to nodes. | `map(string)` | `null` | no |
| <a name="input_launch_template_default_version"></a> [launch\_template\_default\_version](#input\_launch\_template\_default\_version) | Default version of the launch template | `string` | `null` | no |
| <a name="input_launch_template_name"></a> [launch\_template\_name](#input\_launch\_template\_name) | Name of the launch template. If no one is specified it will use the group name as prefix. | `string` | `null` | no |
| <a name="input_launch_template_tags"></a> [launch\_template\_tags](#input\_launch\_template\_tags) | A map of additional tags to add to the tag\_specifications of launch template created | `map(string)` | `{}` | no |
| <a name="input_max_worker_count"></a> [max\_worker\_count](#input\_max\_worker\_count) | Maximum number of worker nodes. | `number` | `10` | no |
| <a name="input_min_worker_count"></a> [min\_worker\_count](#input\_min\_worker\_count) | Minimum number of worker nodes. | `number` | `2` | no |
| <a name="input_platform"></a> [platform](#input\_platform) | Identifies if the OS platform is `bottlerocket` or `linux` based; | `string` | `"linux"` | no |
| <a name="input_post_bootstrap_user_data"></a> [post\_bootstrap\_user\_data](#input\_post\_bootstrap\_user\_data) | User data that is appended to the user data script after of the EKS bootstrap script. Not used when `platform` = `bottlerocket` | `string` | `""` | no |
| <a name="input_pre_bootstrap_user_data"></a> [pre\_bootstrap\_user\_data](#input\_pre\_bootstrap\_user\_data) | User data that is injected into the user data script ahead of the EKS bootstrap script. Not used when `platform` = `bottlerocket` | `string` | `""` | no |
| <a name="input_registry_mirrors"></a> [registry\_mirrors](#input\_registry\_mirrors) | Enables image registry mirror to avoid dockerhub limits. Only available for bottlerocket. | `list(string)` | `[]` | no |
| <a name="input_remote_access_security_group"></a> [remote\_access\_security\_group](#input\_remote\_access\_security\_group) | Configuration block with remote ssh access security group | `list(string)` | `[]` | no |
| <a name="input_remote_access_ssh_key"></a> [remote\_access\_ssh\_key](#input\_remote\_access\_ssh\_key) | Configuration block with remote ssh access key | `string` | `null` | no |
| <a name="input_spot_enabled"></a> [spot\_enabled](#input\_spot\_enabled) | Enable spot instances. This will allow the cluster to use spot instances when available. | `bool` | `false` | no |
| <a name="input_spot_max_price"></a> [spot\_max\_price](#input\_spot\_max\_price) | The maximum hourly price you're willing to pay for the Spot Instances. | `number` | `null` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | IDs of the VPC subnets to create nodes in. | `list(string)` | n/a | yes |
| <a name="input_support_autoscaling"></a> [support\_autoscaling](#input\_support\_autoscaling) | Whether the managed node group will support ASG-based autoscaling. Set to false if you are planning on using an ASG-indepedent autoscaling solution such as Karpenter. | `bool` | `true` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be applied to resources. | `map(string)` | n/a | yes |
| <a name="input_taints"></a> [taints](#input\_taints) | The Kubernetes taints to be applied to the nodes in the node group | <pre>list(object({<br>    key    = string,<br>    value  = string,<br>    effect = string<br>  }))</pre> | `[]` | no |
| <a name="input_timeouts"></a> [timeouts](#input\_timeouts) | Create, update, and delete timeout configurations for the node group | `object({ create = string, update = string, delete = string })` | <pre>{<br>  "create": "60m",<br>  "delete": "60m",<br>  "update": "60m"<br>}</pre> | no |
| <a name="input_update_config"></a> [update\_config](#input\_update\_config) | Configuration block of settings for max unavailable resources during node group updates | <pre>object({<br>    max_unavailable_percentage : optional(number)<br>    max_unavailable : optional(number)<br>  })</pre> | <pre>{<br>  "max_unavailable_percentage": 10<br>}</pre> | no |
| <a name="input_update_launch_template_default_version"></a> [update\_launch\_template\_default\_version](#input\_update\_launch\_template\_default\_version) | Whether to update the launch templates default version on each update. Conflicts with `launch_template_default_version` | `bool` | `true` | no |
| <a name="input_user_data_template_path"></a> [user\_data\_template\_path](#input\_user\_data\_template\_path) | Path to a local, custom user data template file to use when rendering user data | `string` | `""` | no |
| <a name="input_worker_role_arn"></a> [worker\_role\_arn](#input\_worker\_role\_arn) | ARN of the IAM role for the worker nodes. | `string` | n/a | yes |
| <a name="input_workers_security_group_id"></a> [workers\_security\_group\_id](#input\_workers\_security\_group\_id) | ID of the security group for the worker nodes. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_node_group_name"></a> [node\_group\_name](#output\_node\_group\_name) | The name of the node group. |
| <a name="output_node_groups"></a> [node\_groups](#output\_node\_groups) | Outputs from EKS node groups. Map of maps, keyed by `var.node_groups` keys. See `aws_eks_node_group` Terraform documentation for values |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
