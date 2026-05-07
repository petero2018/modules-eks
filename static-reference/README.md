# static-reference

Statically appoint active and inactive clusters for the environments where traffic shifting is not required.

Appointment of the inactive cluster is optional, as for the simplest in-place setup there could be only one cluster.

This module provides interoperability link between SRE and DX tooling as DX tooling, in particular `tf` CLI, relies on SSM to resolve active/inactive clusters.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >=5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >=5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ssm_parameter.active_eks_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.active_eks_cluster_arn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.inactive_eks_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.inactive_eks_cluster_arn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_eks_cluster.active_eks_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster.inactive_eks_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_active_eks_cluster"></a> [active\_eks\_cluster](#input\_active\_eks\_cluster) | Active EKS cluster record for the current AWS account/region | `object({ name = string, ssm_parameter = string })` | n/a | yes |
| <a name="input_inactive_eks_cluster"></a> [inactive\_eks\_cluster](#input\_inactive\_eks\_cluster) | Inactive EKS cluster record for the current AWS account/region | `object({ name = string, ssm_parameter = string })` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to identify resource ownership. | `map(string)` | <pre>{<br>  "impact": "low",<br>  "service": "eks",<br>  "team": "product-infrastructure"<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_active_eks_cluster_arn"></a> [active\_eks\_cluster\_arn](#output\_active\_eks\_cluster\_arn) | ARN of the active EKS cluster |
| <a name="output_active_eks_cluster_name"></a> [active\_eks\_cluster\_name](#output\_active\_eks\_cluster\_name) | Name of the active EKS cluster |
| <a name="output_inactive_eks_cluster_arn"></a> [inactive\_eks\_cluster\_arn](#output\_inactive\_eks\_cluster\_arn) | ARN of the inactive EKS cluster |
| <a name="output_inactive_eks_cluster_name"></a> [inactive\_eks\_cluster\_name](#output\_inactive\_eks\_cluster\_name) | Name of the inactive EKS cluster |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
