# IRSA (IAM roles for Kubernetes Service Accounts)

This Terraform module creates the following resources

1.  Kubernetes Namespace
2.  Service Account
3.  IAM Role for Service Account with OIDC assume role policy
4.  Creates default policy required for Addon
5.  Attaches the additional IAM policies provided by consumer module

## Learn more

## Blogs

- [Introducing fine-grained IAM roles for service accounts](https://aws.amazon.com/blogs/opensource/introducing-fine-grained-iam-roles-service-accounts/)
- [Cross account IAM roles for Kubernetes service accounts](https://aws.amazon.com/blogs/containers/cross-account-iam-roles-for-kubernetes-service-accounts/)
- [Enabling cross-account access to Amazon EKS cluster resources](https://aws.amazon.com/blogs/containers/enabling-cross-account-access-to-amazon-eks-cluster-resources/)
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >=3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >=3.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_irsa"></a> [irsa](#module\_irsa) | git@github.com:powise/terraform-modules//aws/iam/role | aws-iam-role-1.0.0 |

## Resources

| Name | Type |
|------|------|
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_eks_cluster.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_iam_policy_document.assume_role_by_authorized_roles](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.oidc_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_any_namespace"></a> [allow\_any\_namespace](#input\_allow\_any\_namespace) | Allow Service Account role assumptions from ANY namespace. | `bool` | `false` | no |
| <a name="input_authorized_iam_roles"></a> [authorized\_iam\_roles](#input\_authorized\_iam\_roles) | Additional IAM roles allowed to assume IRSA role, outside of the cluster. | `list(string)` | `[]` | no |
| <a name="input_eks_clusters"></a> [eks\_clusters](#input\_eks\_clusters) | EKS cluster to get OIDC issuer/authorize from. | `list(string)` | n/a | yes |
| <a name="input_iam_permissions_boundary"></a> [iam\_permissions\_boundary](#input\_iam\_permissions\_boundary) | IAM permissions boundary for IRSA roles. | `string` | `""` | no |
| <a name="input_iam_policy_arns"></a> [iam\_policy\_arns](#input\_iam\_policy\_arns) | IAM policy ARNs for IRSA IAM role. | `list(string)` | `[]` | no |
| <a name="input_iam_policy_documents"></a> [iam\_policy\_documents](#input\_iam\_policy\_documents) | Documents to create inline IAM policies for IRSA IAM role. | `map(string)` | `{}` | no |
| <a name="input_iam_role_name"></a> [iam\_role\_name](#input\_iam\_role\_name) | Name of the IAM role to create. | `string` | n/a | yes |
| <a name="input_iam_role_path"></a> [iam\_role\_path](#input\_iam\_role\_path) | IAM role path for IRSA roles. | `string` | `null` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Kubernetes Namespace name. | `string` | n/a | yes |
| <a name="input_service_accounts"></a> [service\_accounts](#input\_service\_accounts) | Kubernetes Service Account Names. | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be applied to AWS resources. | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_irsa_iam_role_arn"></a> [irsa\_iam\_role\_arn](#output\_irsa\_iam\_role\_arn) | IAM role ARN for your service account |
| <a name="output_irsa_iam_role_name"></a> [irsa\_iam\_role\_name](#output\_irsa\_iam\_role\_name) | IAM role name for your service account |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
