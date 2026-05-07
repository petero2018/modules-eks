# master

This module creates an EKS cluster.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | ~>3.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | ~>3.1.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cluster_cloudwatch_logs"></a> [cluster\_cloudwatch\_logs](#module\_cluster\_cloudwatch\_logs) | git@github.com:powise/terraform-modules//aws/kms | aws-kms-0.1.2 |
| <a name="module_cluster_kms"></a> [cluster\_kms](#module\_cluster\_kms) | git@github.com:powise/terraform-modules//aws/kms | aws-kms-0.1.2 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_eks_access_entry.worker_auto_mode](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_access_entry) | resource |
| [aws_eks_access_policy_association.worker_auto_mode](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_access_policy_association) | resource |
| [aws_eks_cluster.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster) | resource |
| [aws_iam_openid_connect_provider.oidc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider) | resource |
| [aws_iam_role.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.worker](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.auto_mode_tagging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.cloudwatch_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.ecr_pull_through_cache_import](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.ssm_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.cluster_role_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.worker_role_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_security_group.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.workers](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.workers_extra](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.allow_cluster_to_worker_communication](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.allow_vpc_to_worker_communication](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.allow_worker_to_worker_communication](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.cluster_additional](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.cluster_egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.private_api_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.worker_additional](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.worker_extra](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.auto_mode_tagging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.cloudwatch_kms_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.cluster_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.cluster_kms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.worker_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_subnets.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.vpc_from_id](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |
| [aws_vpc.vpc_from_name](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |
| [tls_certificate.oidc](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/data-sources/certificate) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_auto_mode"></a> [auto\_mode](#input\_auto\_mode) | Whether to enable EKS Auto Mode. | `bool` | `false` | no |
| <a name="input_auto_mode_default_node_pools"></a> [auto\_mode\_default\_node\_pools](#input\_auto\_mode\_default\_node\_pools) | Whether to create the default built-in node pools. | `bool` | `false` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | Name of the AWS region to deploy cluster into | `string` | n/a | yes |
| <a name="input_cloudwatch_log_group_retention_in_days"></a> [cloudwatch\_log\_group\_retention\_in\_days](#input\_cloudwatch\_log\_group\_retention\_in\_days) | Number of days to retain log events. Default retention - 30 days | `number` | `30` | no |
| <a name="input_cluster_encryption_config"></a> [cluster\_encryption\_config](#input\_cluster\_encryption\_config) | Configuration block with encryption configuration for the cluster | <pre>list(object({<br>    provider_key_arn = string<br>    resources        = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_cluster_iam_role_additional_policies"></a> [cluster\_iam\_role\_additional\_policies](#input\_cluster\_iam\_role\_additional\_policies) | Additional policies to be added to the cluster IAM role | `list(string)` | `[]` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the EKS cluster to provision | `string` | n/a | yes |
| <a name="input_cluster_role_name"></a> [cluster\_role\_name](#input\_cluster\_role\_name) | Force this cluster (control plane) IAM role name, otherwise generate the name. | `string` | `null` | no |
| <a name="input_cluster_security_group_additional_rules"></a> [cluster\_security\_group\_additional\_rules](#input\_cluster\_security\_group\_additional\_rules) | List of additional security group rules to add to the cluster security group created. | <pre>map(object({<br>    protocol                 = string<br>    from_port                = string<br>    to_port                  = string<br>    type                     = string<br>    description              = optional(string)<br>    cidr_blocks              = optional(list(string))<br>    prefix_list_ids          = optional(list(string))<br>    self                     = optional(bool)<br>    source_security_group_id = optional(string)<br>  }))</pre> | `{}` | no |
| <a name="input_cluster_security_group_extra_tags"></a> [cluster\_security\_group\_extra\_tags](#input\_cluster\_security\_group\_extra\_tags) | Tags to apply to the cluster security group. | `map(string)` | `{}` | no |
| <a name="input_cluster_service_ipv4_cidr"></a> [cluster\_service\_ipv4\_cidr](#input\_cluster\_service\_ipv4\_cidr) | The CIDR block to assign Kubernetes service IP addresses from. If you don't specify a block, Kubernetes assigns addresses from either the 10.100.0.0/16 or 172.20.0.0/16 CIDR blocks | `string` | `null` | no |
| <a name="input_cluster_tags"></a> [cluster\_tags](#input\_cluster\_tags) | Extra Tags to be applied to cluster resources. | `map(string)` | `{}` | no |
| <a name="input_cluster_timeouts"></a> [cluster\_timeouts](#input\_cluster\_timeouts) | Create, update, and delete timeout configurations for the cluster | `map(string)` | `{}` | no |
| <a name="input_enable_public_api"></a> [enable\_public\_api](#input\_enable\_public\_api) | Enables public Kubernetes API endpoint | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Deploy environment ("dev", "prod", "tools" or "dr") | `string` | n/a | yes |
| <a name="input_extra_kms_roles"></a> [extra\_kms\_roles](#input\_extra\_kms\_roles) | Extra roles for accessing KMS Keys created for the EKS | `list(string)` | `[]` | no |
| <a name="input_k8s_version"></a> [k8s\_version](#input\_k8s\_version) | Kubernetes `<major>.<minor>` version to use for the EKS cluster (i.e.: `1.21`) | `string` | `null` | no |
| <a name="input_kubeconfig_alias"></a> [kubeconfig\_alias](#input\_kubeconfig\_alias) | Kubeconfig alias name, used for kubeconfig generation. | `string` | n/a | yes |
| <a name="input_kubeconfig_discoverable"></a> [kubeconfig\_discoverable](#input\_kubeconfig\_discoverable) | Whether the cluster should be discoverable by the kubeconfig generation. | `bool` | `true` | no |
| <a name="input_private_api_access_cidrs"></a> [private\_api\_access\_cidrs](#input\_private\_api\_access\_cidrs) | List of CIDRs allowed to reach the private Kubernetes API endpoint | `list(string)` | `[]` | no |
| <a name="input_public_api_access_cidrs"></a> [public\_api\_access\_cidrs](#input\_public\_api\_access\_cidrs) | List of CIDRs allowed to reach the public Kubernetes API endpoint | `list(string)` | `[]` | no |
| <a name="input_share_cluster_security_group"></a> [share\_cluster\_security\_group](#input\_share\_cluster\_security\_group) | Use cluster created security group for workers [needed for Karpenter to work] | `bool` | `false` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | A list of subnet IDs where the EKS cluster (ENIs) will be provisioned along with the nodes/node groups. Node groups can be deployed within a different set of subnet IDs from within the node group configuration | `list(string)` | `[]` | no |
| <a name="input_subnet_tags"></a> [subnet\_tags](#input\_subnet\_tags) | Tags to lookup subnets for Kubernetes cluster (specific subnet IDs will always prevail over this!). | `map(string)` | <pre>{<br>  "tier": "private"<br>}</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be applied to resources. | `map(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of the VPC where the cluster and its nodes will be provisioned | `string` | `null` | no |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | Name of the VPC where the cluster and its nodes will be provisioned | `string` | `null` | no |
| <a name="input_worker_extra_security_groups"></a> [worker\_extra\_security\_groups](#input\_worker\_extra\_security\_groups) | Creates extra worker security groups that can be used by Karpenter node classes. | <pre>map(object({<br>    tags = map(string) # Karpenter node classes can then select security groups based on these tags<br>    rules = map(object({<br>      protocol                 = string<br>      from_port                = string<br>      to_port                  = string<br>      type                     = string<br>      description              = optional(string)<br>      cidr_blocks              = optional(list(string))<br>      prefix_list_ids          = optional(list(string))<br>      self                     = optional(bool)<br>      source_security_group_id = optional(string)<br>    }))<br>  }))</pre> | `{}` | no |
| <a name="input_worker_iam_role_additional_policies"></a> [worker\_iam\_role\_additional\_policies](#input\_worker\_iam\_role\_additional\_policies) | Additional policies to be added to the worker IAM role | `list(string)` | `[]` | no |
| <a name="input_worker_role_name"></a> [worker\_role\_name](#input\_worker\_role\_name) | Force this worker IAM role name, otherwise generate the name. | `string` | `null` | no |
| <a name="input_worker_security_group_additional_rules"></a> [worker\_security\_group\_additional\_rules](#input\_worker\_security\_group\_additional\_rules) | List of additional security group rules to add to the workers security group created. | <pre>map(object({<br>    protocol                 = string<br>    from_port                = string<br>    to_port                  = string<br>    type                     = string<br>    description              = optional(string)<br>    cidr_blocks              = optional(list(string))<br>    prefix_list_ids          = optional(list(string))<br>    self                     = optional(bool)<br>    source_security_group_id = optional(string)<br>  }))</pre> | `{}` | no |
| <a name="input_worker_security_group_extra_tags"></a> [worker\_security\_group\_extra\_tags](#input\_worker\_security\_group\_extra\_tags) | Tags to apply to the worker security group. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_region"></a> [aws\_region](#output\_aws\_region) | Name of the AWS region to deployed cluster into. |
| <a name="output_cluster_ca"></a> [cluster\_ca](#output\_cluster\_ca) | EKS cluster CA. This is the CA that is used to validate the EKS cluster. |
| <a name="output_cluster_endpoint"></a> [cluster\_endpoint](#output\_cluster\_endpoint) | EKS cluster endpoint. |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | EKS cluster name. |
| <a name="output_cluster_security_group_id"></a> [cluster\_security\_group\_id](#output\_cluster\_security\_group\_id) | EKS cluster security group ID. |
| <a name="output_environment"></a> [environment](#output\_environment) | Environment name. |
| <a name="output_iam_oidc_provider_arn"></a> [iam\_oidc\_provider\_arn](#output\_iam\_oidc\_provider\_arn) | ARN of the IAM OpenID Connect provider associated with cluster. |
| <a name="output_k8s_version"></a> [k8s\_version](#output\_k8s\_version) | Kubernetes version. |
| <a name="output_kubernetes_version"></a> [kubernetes\_version](#output\_kubernetes\_version) | Kubernetes version. |
| <a name="output_master_role_arn"></a> [master\_role\_arn](#output\_master\_role\_arn) | Master IAM role ARN. |
| <a name="output_master_role_name"></a> [master\_role\_name](#output\_master\_role\_name) | Master IAM role name. |
| <a name="output_oidc_host_path"></a> [oidc\_host\_path](#output\_oidc\_host\_path) | OIDC host path. The difference with the 'oidc\_url' output is that the protocol is stripped out. E.g. 'https://oidc.eks.us-east-1.amazonaws.com/' is 'oidc.eks.us-east-1.amazonaws.com'. |
| <a name="output_oidc_url"></a> [oidc\_url](#output\_oidc\_url) | OIDC URL. This is the URL that is used to authenticate with the EKS cluster. |
| <a name="output_service_ipv4_cidr"></a> [service\_ipv4\_cidr](#output\_service\_ipv4\_cidr) | The CIDR block for Kubernetes service IP addresses. |
| <a name="output_subnet_ids"></a> [subnet\_ids](#output\_subnet\_ids) | IDs of the VPC subnets we deployed cluster into. |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | VPC ID. |
| <a name="output_worker_role_arn"></a> [worker\_role\_arn](#output\_worker\_role\_arn) | Worker role ARN. |
| <a name="output_worker_role_name"></a> [worker\_role\_name](#output\_worker\_role\_name) | Worker role name. |
| <a name="output_workers_security_group_id"></a> [workers\_security\_group\_id](#output\_workers\_security\_group\_id) | Workers security group ID. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
