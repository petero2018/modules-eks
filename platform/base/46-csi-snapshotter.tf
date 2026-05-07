module "csi_snapshotter" {
  source = "git@github.com:powise/terraform-modules//k8s/core/csi-snapshotter?ref=core-csi-snapshotter-0.1.0"
  count  = var.csi_snapshotter_config.enabled ? 1 : 0

  default_class = true
  default_class_labels = var.velero_config.enabled ? {
    "velero.io/csi-volumesnapshot-class" = "true"
  } : {}

  csi_snapshotter_version = var.csi_snapshotter_config.version
}
