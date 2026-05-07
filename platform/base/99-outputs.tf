output "namespaces" {
  value = var.namespaces

  description = "List of namespaces provisioned."
}

output "datadog_api_key" {
  value       = var.datadog_api_key
  sensitive   = true
  description = "Datadog API key."
}

output "datadog_app_key" {
  value       = var.datadog_app_key
  sensitive   = true
  description = "Datadog application key."
}
