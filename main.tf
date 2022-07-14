
locals {
  tmp_dir              = "${path.cwd}/.tmp/icr"
  registry_namespace   = lower(var.registry_namespace != "" ? var.registry_namespace : var.resource_group_name)
  registry_user        = var.registry_user != "" ? var.registry_user : "iamapikey"
  registry_password    = var.registry_password != "" ? var.registry_password : var.ibmcloud_api_key
  registry_region      = data.external.registry.result.registry_region
  registry_server      = data.external.registry.result.registry_server
  service              = "container-registry"
  crn                  = "crn:v1:bluemix:public:container-registry:${var.region}:::"
}

module setup_clis {
  source = "cloud-native-toolkit/clis/util"
  version = "1.16.4"

  clis = ["jq", "ibmcloud-cr"]
}

data external registry {
  program = ["bash", "${path.module}/scripts/get-registry-info.sh"]

  query = {
    bin_dir          = module.setup_clis.bin_dir
    region           = var.region
    resource_group   = var.resource_group_name
    ibmcloud_api_key = var.ibmcloud_api_key
  }
}

# this should probably be moved to a separate module that operates at a namespace level
resource null_resource create_registry_namespace {

  provisioner "local-exec" {
    command = "${path.module}/scripts/create-registry-namespace.sh '${var.region}' '${var.resource_group_name}' '${local.registry_region}' '${local.registry_namespace}' '${var.upgrade_plan}'"

    environment = {
      BIN_DIR = module.setup_clis.bin_dir
      IBMCLOUD_API_KEY = var.ibmcloud_api_key
    }
  }
}
