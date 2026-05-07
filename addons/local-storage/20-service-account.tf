resource "kubernetes_service_account" "main" {
  metadata {
    name      = "local-volume-provisioner"
    namespace = var.namespace
  }
}

resource "kubernetes_cluster_role" "main" {
  metadata {
    name = "local-storage-provisioner-node-clusterrole"
  }

  rule {
    api_groups = [""]
    resources  = ["persistentvolumes"]
    verbs      = ["get", "list", "watch", "create", "delete"]
  }

  rule {
    api_groups = ["storage.k8s.io"]
    resources  = ["storageclasses"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = [""]
    resources  = ["events"]
    verbs      = ["watch"]
  }

  rule {
    api_groups = ["", "events.k8s.io"]
    resources  = ["events"]
    verbs      = ["create", "update", "patch"]
  }

  rule {
    api_groups = [""]
    resources  = ["nodes"]
    verbs      = ["get"]
  }
}

resource "kubernetes_cluster_role_binding" "main" {
  metadata {
    name = "local-storage-provisioner-node-binding"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.main.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.main.metadata[0].name
    namespace = var.namespace
  }
}
