# network addons

Generic EKS network addon module.
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_eks_vpc_cni"></a> [eks\_vpc\_cni](#module\_eks\_vpc\_cni) | git@github.com:powise/terraform-modules//k8s/core/vpc-cni | vpc-cni-0.1.2 |

## Resources

| Name | Type |
|------|------|
| [aws_eks_addon.core_dns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon) | resource |
| [aws_eks_addon.kube_proxy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon) | resource |
| [aws_eks_addon_version.core_dns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_addon_version) | data source |
| [aws_eks_addon_version.kube_proxy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_addon_version) | data source |
| [aws_eks_addon_version.vpc_cni](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_addon_version) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_configuration_values"></a> [configuration\_values](#input\_configuration\_values) | Custom add-on configuration. | `string` | `null` | no |
| <a name="input_core_dns_version"></a> [core\_dns\_version](#input\_core\_dns\_version) | Core DNS version | `string` | `null` | no |
| <a name="input_eks_cluster"></a> [eks\_cluster](#input\_eks\_cluster) | Name of the EKS cluster to operate on. | `string` | n/a | yes |
| <a name="input_enable_core_dns"></a> [enable\_core\_dns](#input\_enable\_core\_dns) | Flag to enable core dns | `bool` | `true` | no |
| <a name="input_enable_kube_proxy"></a> [enable\_kube\_proxy](#input\_enable\_kube\_proxy) | Flag to enable kube proxy | `bool` | `true` | no |
| <a name="input_enable_security_group_policies"></a> [enable\_security\_group\_policies](#input\_enable\_security\_group\_policies) | Enable security group policies (set "true" to support security groups for pods). | `bool` | `false` | no |
| <a name="input_enable_vpc_cni"></a> [enable\_vpc\_cni](#input\_enable\_vpc\_cni) | Flag to enable VPC CNI | `bool` | `true` | no |
| <a name="input_k8s_version"></a> [k8s\_version](#input\_k8s\_version) | Kubernetes `<major>.<minor>` version to use for the EKS cluster (i.e.: `1.21`) | `string` | n/a | yes |
| <a name="input_kube_proxy_version"></a> [kube\_proxy\_version](#input\_kube\_proxy\_version) | Kube proxy version | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to identify resource ownership. | `map(string)` | <pre>{<br>  "impact": "critical",<br>  "service": "eks",<br>  "team": "product-infrastructure"<br>}</pre> | no |
| <a name="input_vpc_cni_chart_version"></a> [vpc\_cni\_chart\_version](#input\_vpc\_cni\_chart\_version) | VPC CNI Chart version | `string` | `"1.2.8"` | no |
| <a name="input_vpc_cni_version"></a> [vpc\_cni\_version](#input\_vpc\_cni\_version) | VPC CNI Version | `string` | `null` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
