terraform {
  required_version = ">= 1.6.6"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.36"
    }

    # tflint-ignore: terraform_unused_required_providers
    helm = {
      source = "hashicorp/helm"
      # breaking changes in version 3
      version = "<3"
    }
  }
}
