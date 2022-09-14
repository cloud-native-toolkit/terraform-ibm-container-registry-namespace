module "container_registry" {
  source = "./module"

  resource_group_name = "${local.name_prefix}-${module.resource_group.name}"
  
  region              = var.region
  ibmcloud_api_key    = var.ibmcloud_api_key
}
