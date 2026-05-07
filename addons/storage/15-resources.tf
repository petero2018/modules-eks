module "ebs_csi" {
  source = "../../../k8s/core/ebs-csi"

  eks_cluster     = var.eks_cluster
  ebs_csi_version = local.ebs_csi_version
  aws_region      = var.aws_region

  delete_default = var.delete_default_storage_class

  tags = var.tags
}

module "storage_class" {
  for_each = var.storage_classes

  source = "../../../k8s/core/ebs-storage-class"

  name                   = each.key
  default                = coalesce(each.value.default, false)
  reclaim_policy         = coalesce(each.value.reclaim_policy, "Delete")
  allow_volume_expansion = coalesce(each.value.allow_volume_expansion, true)
  mount_options          = each.value.mount_options

  file_system = coalesce(each.value.file_system, "ext4")
  volume_type = coalesce(each.value.volume_type, "gp3")
  iops_per_gb = each.value.iops_per_gb
  auto_iops   = coalesce(each.value.auto_iops, false)
  iops        = each.value.iops
  throughput  = each.value.throughput
  encrypted   = coalesce(each.value.encrypted, true)
  kms_key     = each.value.kms_key

  tags = var.tags

  labels      = {}
  annotations = {}

  depends_on = [
    module.ebs_csi
  ]
}
