# addons

Generic EKS addon module.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.6 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | <3 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.36 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >= 2.36 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aws_secrets_store_csi"></a> [aws\_secrets\_store\_csi](#module\_aws\_secrets\_store\_csi) | ../../k8s/core/aws-secret-store-csi | n/a |
| <a name="module_guardduty_agent"></a> [guardduty\_agent](#module\_guardduty\_agent) | ./guardduty-agent | n/a |
| <a name="module_karpenter"></a> [karpenter](#module\_karpenter) | ./karpenter | n/a |
| <a name="module_local_storage"></a> [local\_storage](#module\_local\_storage) | ./local-storage | n/a |
| <a name="module_network_addons"></a> [network\_addons](#module\_network\_addons) | ./network | n/a |
| <a name="module_secrets_store_csi_driver"></a> [secrets\_store\_csi\_driver](#module\_secrets\_store\_csi\_driver) | ../../k8s/core/secrets-store-csi-driver | n/a |
| <a name="module_storage_addons"></a> [storage\_addons](#module\_storage\_addons) | ./storage | n/a |

## Resources

| Name | Type |
|------|------|
| [kubernetes_storage_class.auto_mode_gp3](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/storage_class) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_autoscale_with"></a> [autoscale\_with](#input\_autoscale\_with) | Which mechanism use to scale the cluster. | `string` | `"cluster-autoscaler"` | no |
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | ID of the AWS account where the EKS cluster is deployed. | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | Region name where the cluster is running. This is used for IAM roles naming. | `string` | n/a | yes |
| <a name="input_core_dns_version"></a> [core\_dns\_version](#input\_core\_dns\_version) | Core DNS version to install | `string` | `null` | no |
| <a name="input_ebs_csi_version"></a> [ebs\_csi\_version](#input\_ebs\_csi\_version) | EBS CSI Version to install | `string` | `null` | no |
| <a name="input_eks_auto_mode"></a> [eks\_auto\_mode](#input\_eks\_auto\_mode) | Set this to true when using EKS Auto Mode. | `bool` | `false` | no |
| <a name="input_eks_cluster"></a> [eks\_cluster](#input\_eks\_cluster) | Name of the EKS cluster to operate on. | `string` | n/a | yes |
| <a name="input_enable_core_dns"></a> [enable\_core\_dns](#input\_enable\_core\_dns) | Flag to enable core dns | `bool` | `true` | no |
| <a name="input_enable_ebs_csi_driver"></a> [enable\_ebs\_csi\_driver](#input\_enable\_ebs\_csi\_driver) | Enable Amazon EBS CSI driver addon | `bool` | `false` | no |
| <a name="input_enable_guardduty_agent"></a> [enable\_guardduty\_agent](#input\_enable\_guardduty\_agent) | Enable the guardduty agent for EKS runtime monitoring. | `bool` | `false` | no |
| <a name="input_enable_kube_proxy"></a> [enable\_kube\_proxy](#input\_enable\_kube\_proxy) | Flag to enable kube proxy | `bool` | `true` | no |
| <a name="input_enable_local_storage_driver"></a> [enable\_local\_storage\_driver](#input\_enable\_local\_storage\_driver) | Enable local storage driver addon. | `bool` | `false` | no |
| <a name="input_enable_secret_store_csi"></a> [enable\_secret\_store\_csi](#input\_enable\_secret\_store\_csi) | Enable AWS Secrets Store CSI driver addon | `bool` | `true` | no |
| <a name="input_enable_secrets_store_csi_driver"></a> [enable\_secrets\_store\_csi\_driver](#input\_enable\_secrets\_store\_csi\_driver) | Enable Secrets Store CSI Driver (required for AWS Secrets Store CSI) | `bool` | `false` | no |
| <a name="input_enable_security_group_policies"></a> [enable\_security\_group\_policies](#input\_enable\_security\_group\_policies) | Enable security group policies (set "true" to support security groups for pods). | `bool` | `false` | no |
| <a name="input_enable_spot_termination"></a> [enable\_spot\_termination](#input\_enable\_spot\_termination) | Enable spot instance termination handling via SQS and EventBridge. | `bool` | `false` | no |
| <a name="input_enable_vpc_cni"></a> [enable\_vpc\_cni](#input\_enable\_vpc\_cni) | Flag to enable VPC CNI | `bool` | `true` | no |
| <a name="input_k8s_version"></a> [k8s\_version](#input\_k8s\_version) | Kubernetes `<major>.<minor>` version to use for the EKS cluster (i.e.: `1.21`) | `string` | n/a | yes |
| <a name="input_karpenter_chart_version"></a> [karpenter\_chart\_version](#input\_karpenter\_chart\_version) | Karpenter chart version - must be at least 1.0.1. | `string` | `"1.0.1"` | no |
| <a name="input_kube_proxy_version"></a> [kube\_proxy\_version](#input\_kube\_proxy\_version) | Kube proxy version to install | `string` | `null` | no |
| <a name="input_local_storage_driver_version"></a> [local\_storage\_driver\_version](#input\_local\_storage\_driver\_version) | Version of local-volume-provisioner. | `string` | `"v2.7.0"` | no |
| <a name="input_secret_store_csi_chart_name"></a> [secret\_store\_csi\_chart\_name](#input\_secret\_store\_csi\_chart\_name) | The name of the Helm chart for the AWS Secrets Store CSI Driver | `string` | `"csi-secrets-store-provider-aws"` | no |
| <a name="input_secret_store_csi_chart_version"></a> [secret\_store\_csi\_chart\_version](#input\_secret\_store\_csi\_chart\_version) | AWS Secrets Store CSI Driver chart version | `string` | `"0.0.3"` | no |
| <a name="input_secret_store_csi_repository"></a> [secret\_store\_csi\_repository](#input\_secret\_store\_csi\_repository) | The Helm chart repository URL for the AWS Secrets Store CSI Driver | `string` | `"https://aws.github.io/eks-charts"` | no |
| <a name="input_secrets_store_csi_driver_chart_name"></a> [secrets\_store\_csi\_driver\_chart\_name](#input\_secrets\_store\_csi\_driver\_chart\_name) | The name of the Helm chart for the Secrets Store CSI Driver | `string` | `"secrets-store-csi-driver"` | no |
| <a name="input_secrets_store_csi_driver_chart_version"></a> [secrets\_store\_csi\_driver\_chart\_version](#input\_secrets\_store\_csi\_driver\_chart\_version) | Secrets Store CSI Driver chart version | `string` | `"1.3.4"` | no |
| <a name="input_secrets_store_csi_driver_repository"></a> [secrets\_store\_csi\_driver\_repository](#input\_secrets\_store\_csi\_driver\_repository) | The Helm chart repository URL for the Secrets Store CSI Driver | `string` | `"https://kubernetes-sigs.github.io/secrets-store-csi-driver/charts"` | no |
| <a name="input_storage_classes"></a> [storage\_classes](#input\_storage\_classes) | EBS Storage Classes to create. | <pre>map(object({<br>    # https://kubernetes.io/docs/concepts/storage/storage-classes/#aws-ebs<br>    # A flag to specify if should be the default storage class to use<br>    default = optional(bool)<br>    # It describes the Kubernetes action when the PV is released.<br>    # - Retain: When an associated PersistentVolumeClaim is deleted, the PersistentVolume will continue to be present.<br>    # - Delete: The PersistentVolume object and its associated storage volume are deleted when the PersistentVolumeClaim is deleted. (default)<br>    reclaim_policy = optional(bool)<br>    # Linux mount options to apply to PVCs created with this storage class.<br>    mount_options = optional(list(string))<br>    # PersistentVolumes can be configured to be expandable. This feature when set to true, allows the users to resize the volume by editing the corresponding PVC object. (true by default)<br>    allow_volume_expansion = optional(bool)<br>    # https://github.com/kubernetes-sigs/aws-ebs-csi-driver/blob/master/docs/parameters.md<br>    # File system type that will be formatted during volume creation. (xfs, ext2, ext3, ext4) (default: ext4)<br>    file_system = optional(string)<br>    # EBS volume type (io1, io2, gp2, gp3, sc1, st1, standard) (default: gp3)<br>    volume_type = optional(string)<br>    # I/O operations per second per GiB. Required when io1 or io2 volume type is specified.<br>    iops_per_gb = optional(number)<br>    # When true the CSI driver increases IOPS for a volume when iopsPerGB * <volume size> is too low to fit into IOPS range supported by AWS. (false by default)<br>    auto_iops = optional(bool)<br>    # I/O operations per second. Only effetive when gp3 volume type is specified. (default: 3000)<br>    iops = optional(number)<br>    # Throughput in MiB/s. Only effective when gp3 volume type is specified. (default: 125MiB/s)<br>    throughput = optional(number)<br>    # Whether the volume should be encrypted or not. (by default encrypt volumes)<br>    encrypted = optional(bool)<br>    # The full ARN of the key to use when encrypting the volume. (by default it will use the aws managed one)<br>    kms_key = optional(string)<br>    # https://github.com/kubernetes-sigs/aws-ebs-csi-driver/blob/master/docs/tagging.md<br>    # Tags to apply to the volume<br>    tags = optional(map(string))<br>  }))</pre> | <pre>{<br>  "gp3": {<br>    "default": true,<br>    "encrypted": true,<br>    "file_system": "ext4",<br>    "volume_type": "gp3"<br>  }<br>}</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to identify resource ownership. | `map(string)` | <pre>{<br>  "impact": "critical",<br>  "service": "eks",<br>  "team": "product-infrastructure"<br>}</pre> | no |
| <a name="input_vpc_cni_chart_version"></a> [vpc\_cni\_chart\_version](#input\_vpc\_cni\_chart\_version) | VPC CNI Chart version | `string` | `"1.2.8"` | no |
| <a name="input_vpc_cni_version"></a> [vpc\_cni\_version](#input\_vpc\_cni\_version) | VPC CNI Version | `string` | `null` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The VPC ID used to fetch the guardduty endpoint status | `string` | `null` | no |
| <a name="input_worker_role_arn"></a> [worker\_role\_arn](#input\_worker\_role\_arn) | IAM role ARN to use to set PassRole permissions on controller role. | `string` | `null` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
