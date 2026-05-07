terraform {
  required_providers {
    # While Datadog is not actually used in this module, it takes a var of datadog_api_key and datadog_app_key
    # which can come from datadog_config.hcl in some repos. Since terraform checks hashicorp first, this is just placed here to prevent issues,
    # otherwise you will recieve the following error from terraform:
    # | Could not retrieve the list of available versions for provider
    # | hashicorp/datadog: provider registry registry.terraform.io does not have a
    # | provider named registry.terraform.io/hashicorp/datadog

    aws = {
      source  = "hashicorp/aws"
      version = ">=4.0.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.29.0"
    }
    # tflint-ignore: terraform_unused_required_providers
    datadog = {
      source  = "DataDog/datadog"
      version = ">= 3.30.0"
    }

    # tflint-ignore: terraform_unused_required_providers
    helm = {
      source = "hashicorp/helm"
      # breaking changes in version 3
      version = "<3"
    }
  }
  required_version = ">= 1.6.6"
}
