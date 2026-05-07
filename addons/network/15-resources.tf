resource "aws_eks_addon" "kube_proxy" {
  count = var.enable_kube_proxy ? 1 : 0

  cluster_name = var.eks_cluster

  addon_name    = "kube-proxy"
  addon_version = local.kube_proxy_version

  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  tags = var.tags
}

resource "aws_eks_addon" "core_dns" {
  count = var.enable_core_dns ? 1 : 0

  cluster_name = var.eks_cluster

  addon_name    = "coredns"
  addon_version = local.core_dns_version

  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  # This JSON already has tolerations to work with or without Karpenter
  # Let's make CoreDNS configuration more static and predictable :pray:
  configuration_values = jsonencode(
    {
      affinity = {
        nodeAffinity = {
          requiredDuringSchedulingIgnoredDuringExecution = {
            nodeSelectorTerms = [
              {
                matchExpressions = [
                  {
                    key      = "kubernetes.io/os"
                    operator = "In"
                    values = [
                      "linux",
                    ]
                  },
                  {
                    key      = "kubernetes.io/arch"
                    operator = "In"
                    values = [
                      "arm64",
                      "amd64",
                    ]
                  },
                ]
              },
            ]
          }
        }
        podAntiAffinity = {
          preferredDuringSchedulingIgnoredDuringExecution = [
            {
              podAffinityTerm = {
                labelSelector = {
                  matchExpressions = [
                    {
                      key      = "k8s-app"
                      operator = "In"
                      values = [
                        "kube-dns",
                      ]
                    },
                  ]
                }
                topologyKey = "kubernetes.io/hostname"
              }
              weight = 100
            },
          ]
        }
      }
      tolerations = [
        {
          operator = "Exists"
        },
      ]
    }
  )

  tags = var.tags
}

module "eks_vpc_cni" {
  count = var.enable_vpc_cni ? 1 : 0

  source = "git@github.com:powise/terraform-modules//k8s/core/vpc-cni?ref=vpc-cni-0.1.2"

  eks_cluster = var.eks_cluster

  vpc_cni_version       = local.vpc_cni_version
  vpc_cni_chart_version = var.vpc_cni_chart_version

  enable_security_group_policies = var.enable_security_group_policies
  configuration_values           = var.configuration_values

  tags = var.tags
}
