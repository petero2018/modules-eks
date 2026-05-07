resource "kubernetes_daemonset" "provisioner" {

  wait_for_rollout = false

  metadata {
    name      = "local-volume-provisioner"
    namespace = var.namespace
    labels = {
      "app.kubernetes.io/name" = "local-volume-provisioner"
    }
  }

  spec {
    selector {
      match_labels = {
        "app.kubernetes.io/name" = "local-volume-provisioner"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/name" = "local-volume-provisioner"
        }
      }

      spec {
        service_account_name = kubernetes_service_account.main.metadata[0].name
        container {
          image             = "registry.k8s.io/sig-storage/local-volume-provisioner:${var.local_storage_driver_version}"
          name              = "provisioner"
          image_pull_policy = "IfNotPresent"

          security_context {
            privileged = true
          }

          env {
            name = "MY_NODE_NAME"
            value_from {
              field_ref {
                field_path = "spec.nodeName"
              }
            }
          }

          env {
            name = "MY_NAMESPACE"
            value_from {
              field_ref {
                field_path = "metadata.namespace"
              }
            }
          }

          port {
            name           = "metrics"
            container_port = 8080
          }

          volume_mount {
            name       = "provisioner-config"
            mount_path = "/etc/provisioner/config"
            read_only  = true
          }

          volume_mount {
            name              = "fast-disks"
            mount_path        = "/mnt/fast-disks"
            mount_propagation = "HostToContainer"
          }
        }

        volume {
          name = "provisioner-config"
          config_map {
            name = kubernetes_config_map.local_storage.metadata[0].name
          }
        }

        volume {
          name = "fast-disks"
          host_path {
            path = "/mnt/fast-disks"
          }
        }

        # Only run on NVMe instances
        affinity {
          node_affinity {
            required_during_scheduling_ignored_during_execution {
              node_selector_term {
                match_expressions {
                  key      = "fast-disk-node"
                  operator = "In"
                  values = [
                    "pv-raid",
                    "pv-nvme",
                  ]
                }
              }
            }
          }
        }

        toleration {
          key   = "dedicated"
          value = "nvme"
        }
      }
    }
  }
}
