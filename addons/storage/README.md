# storage addons

Generic EKS storage addon module.
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
| <a name="module_ebs_csi"></a> [ebs\_csi](#module\_ebs\_csi) | ../../../k8s/core/ebs-csi | n/a |
| <a name="module_storage_class"></a> [storage\_class](#module\_storage\_class) | ../../../k8s/core/ebs-storage-class | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_eks_addon_version.ebs_csi_version](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_addon_version) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | Region name where the cluster is running. This is used for IAM roles naming. | `string` | `""` | no |
| <a name="input_delete_default_storage_class"></a> [delete\_default\_storage\_class](#input\_delete\_default\_storage\_class) | Flag to delete the default storage class. | `bool` | `true` | no |
| <a name="input_ebs_csi_version"></a> [ebs\_csi\_version](#input\_ebs\_csi\_version) | EBS CSI Version to install | `string` | `"v1.13.0-eksbuild.2"` | no |
| <a name="input_eks_cluster"></a> [eks\_cluster](#input\_eks\_cluster) | Name of the EKS cluster to operate on. | `string` | n/a | yes |
| <a name="input_k8s_version"></a> [k8s\_version](#input\_k8s\_version) | Kubernetes `<major>.<minor>` version to use for the EKS cluster (i.e.: `1.21`) | `string` | n/a | yes |
| <a name="input_storage_classes"></a> [storage\_classes](#input\_storage\_classes) | EBS Storage Classes to create. | <pre>map(object({<br>    # https://kubernetes.io/docs/concepts/storage/storage-classes/#aws-ebs<br>    # A flag to specify if should be the default storage class to use<br>    default = optional(bool)<br>    # It describes the Kubernetes action when the PV is released.<br>    # - Retain: When an associated PersistentVolumeClaim is deleted, the PersistentVolume will continue to be present.<br>    # - Delete: The PersistentVolume object and its associated storage volume are deleted when the PersistentVolumeClaim is deleted. (default)<br>    reclaim_policy = optional(bool)<br>    # Linux mount options to apply to PVCs created with this storage class.<br>    mount_options = optional(list(string))<br>    # PersistentVolumes can be configured to be expandable. This feature when set to true, allows the users to resize the volume by editing the corresponding PVC object. (true by default)<br>    allow_volume_expansion = optional(bool)<br>    # https://github.com/kubernetes-sigs/aws-ebs-csi-driver/blob/master/docs/parameters.md<br>    # File system type that will be formatted during volume creation. (xfs, ext2, ext3, ext4) (default: ext4)<br>    file_system = optional(string)<br>    # EBS volume type (io1, io2, gp2, gp3, sc1, st1, standard) (default: gp3)<br>    volume_type = optional(string)<br>    # I/O operations per second per GiB. Required when io1 or io2 volume type is specified.<br>    iops_per_gb = optional(number)<br>    # When true the CSI driver increases IOPS for a volume when iopsPerGB * <volume size> is too low to fit into IOPS range supported by AWS. (false by default)<br>    auto_iops = optional(bool)<br>    # I/O operations per second. Only effetive when gp3 volume type is specified. (default: 3000)<br>    iops = optional(number)<br>    # Throughput in MiB/s. Only effective when gp3 volume type is specified. (default: 125MiB/s)<br>    throughput = optional(number)<br>    # Whether the volume should be encrypted or not. (by default encrypt volumes)<br>    encrypted = optional(bool)<br>    # The full ARN of the key to use when encrypting the volume. (by default it will use the aws managed one)<br>    kms_key = optional(string)<br>    # https://github.com/kubernetes-sigs/aws-ebs-csi-driver/blob/master/docs/tagging.md<br>    # Tags to apply to the volume<br>    tags = optional(map(string))<br>  }))</pre> | <pre>{<br>  "gp3": {<br>    "default": true,<br>    "encrypted": true,<br>    "file_system": "ext4",<br>    "volume_type": "gp3"<br>  }<br>}</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to identify resource ownership. | `map(string)` | <pre>{<br>  "impact": "critical",<br>  "service": "eks",<br>  "team": "product-infrastructure"<br>}</pre> | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
