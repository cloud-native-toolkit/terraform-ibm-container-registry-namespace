module "container_registry" {
  source = "./module"

  resource_group_name = module.resource_group.name

  region              = var.region
  ibmcloud_api_key    = var.ibmcloud_api_key
  registry_namespace   = local.name-random
  
}

locals {
  name-random = "${local.name_prefix}-${var.namespace}"
}