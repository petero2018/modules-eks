resource "kubernetes_namespace" "overprovisioning" {
  metadata {
    name = local.overprovisioning_namespace

    labels = {
      istio-injection = "disabled"
    }
  }
}

resource "kubernetes_priority_class" "overprovisioning" {
  metadata {
    name = "overprovisioning"
  }

  value          = -1
  global_default = false

  description = "Priority class used for cluster overprovisioner pods"
}

resource "kubernetes_deployment" "overprovisioning" {
  #checkov:skip=CKV_K8S_43: "Image should use digest"
  #checkov:skip=CKV_K8S_8: "Liveness Probe Should be Configured"
  #checkov:skip=CKV_K8S_9: "Readiness Probe Should be Configured"
  #checkov:skip=CKV_K8S_11: "CPU Limits should be set"
  #checkov:skip=CKV_K8S_12: "Memory Limits should be set"

  for_each = var.overprovisioning_configs

  metadata {
    name      = each.key
    namespace = kubernetes_namespace.overprovisioning.metadata[0].name

    labels = {
      app = each.key
    }
  }

  spec {
    replicas = each.value.replicas

    selector {
      match_labels = {
        app = each.key
      }
    }

    template {
      metadata {
        labels = {
          app = each.key
        }
      }

      spec {
        priority_class_name = kubernetes_priority_class.overprovisioning.metadata[0].name

        node_selector = each.value.node_group_name != null ? {
          "eks.amazonaws.com/nodegroup" = each.value.node_group_name
        } : {}

        security_context {
          run_as_non_root = true
        }

        dynamic "toleration" {
          for_each = each.value.pod_tolerations
          content {
            key      = toleration.value.key
            operator = toleration.value.operator
            value    = toleration.value.value
            effect   = toleration.value.effect
          }
        }

        container {
          name              = "overprovisioning"
          image             = "registry.k8s.io/pause:3.9"
          image_pull_policy = "Always"

          security_context {
            read_only_root_filesystem = true
            capabilities {
              drop = ["NET_RAW", "ALL"]
            }
          }

          resources {
            requests = {
              cpu    = each.value.cpu
              memory = each.value.memory
            }
          }
        }
      }
    }
  }
}
