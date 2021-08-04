
output "id" {
  description = "The id of the provisioned redis instance"
  value       = local.crn
  depends_on  = [null_resource.create_registry_namespace]
}

output "name" {
  description = "The name of the container registry service"
  value       = local.service
  depends_on  = [null_resource.create_registry_namespace]
}

output "crn" {
  description = "The crn of the contaienr registry service"
  value       = local.crn
  depends_on  = [null_resource.create_registry_namespace]
}

output "location" {
  description = "The location of the provisioned redis instance"
  value       = var.region
  depends_on  = [null_resource.create_registry_namespace]
}

output "service" {
  description = "The name of the key provisioned for the redis instance"
  value       = local.service
  depends_on  = [null_resource.create_registry_namespace]
}

output "label" {
  description = "The label for the container registry instance"
  value       = local.registry_namespace
  depends_on  = [null_resource.create_registry_namespace]
}


output "registry_url" {
  description = "The url for the container registry endpoint"
  value       = local.registry_url
}

output "registry_user" {
  description = "The username for the container registry endpoint"
  value       = local.registry_user
  depends_on = [null_resource.create_registry_namespace]
}

output "registry_password" {
  description = "The password for the container registry endpoint"
  value       = local.registry_password
  depends_on = [null_resource.create_registry_namespace]
  sensitive = true
}

output "registry_namespace" {
  description = "The namespace for the container registry endpoint"
  value       = local.registry_namespace
  depends_on = [null_resource.create_registry_namespace]
}
