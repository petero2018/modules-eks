resource "kubernetes_storage_class" "local_storage" {
  metadata {
    name = "fast-disks"
  }

  storage_provisioner = "kubernetes.io/no-provisioner"
  reclaim_policy      = "Retain"
  volume_binding_mode = "Immediate"
}

resource "kubernetes_config_map" "local_storage" {
  metadata {
    name      = "local-volume-provisioner-config"
    namespace = var.namespace
  }

  data = {
    nodeLabelsForPV = file("${path.module}/configmaps/node_labels.yaml")
    labelsForPV     = file("${path.module}/configmaps/labels.yaml")
    storageClassMap = file("${path.module}/configmaps/storage_class.yaml")
  }
}
