################################################################################
# HINT: Make sure we point to an existing [and active] cluster!
################################################################################

data "aws_eks_cluster" "active_eks_cluster" {
  name = var.active_eks_cluster.name

  lifecycle {
    postcondition {
      condition     = self.status == "ACTIVE"
      error_message = "unexpected cluster status: ${self.status}"
    }
  }
}

data "aws_eks_cluster" "inactive_eks_cluster" {
  count = var.inactive_eks_cluster != null ? 1 : 0

  name = var.inactive_eks_cluster.name

  lifecycle {
    precondition {
      condition     = var.active_eks_cluster.name != var.inactive_eks_cluster.name
      error_message = "active and inactive clusters must have different names"
    }
  }
}
