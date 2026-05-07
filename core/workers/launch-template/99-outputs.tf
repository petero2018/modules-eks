output "name" {
  value       = aws_launch_template.main.name
  description = "The name of the launch template."
}

output "id" {
  value       = aws_launch_template.main.id
  description = "The ID of the launch template."
}

output "latest_version" {
  value       = aws_launch_template.main.latest_version
  description = "Latest version of the launch template."
}
