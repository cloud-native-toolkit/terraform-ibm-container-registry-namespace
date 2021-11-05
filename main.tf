
locals {
  tmp_dir              = "${path.cwd}/.tmp/icr"
  registry_server_file = "${local.tmp_dir}/registry_server.val"
  registry_region_file = "${local.tmp_dir}/registry_region.val"
  registry_namespace   = lower(var.registry_namespace != "" ? var.registry_namespace : var.resource_group_name)
  registry_user        = var.registry_user != "" ? var.registry_user : "iamapikey"
  registry_password    = var.registry_password != "" ? var.registry_password : var.ibmcloud_api_key
  registry_server      = data.local_file.registry_server.content
  registry_region      = data.local_file.registry_region.content
  service              = "container-registry"
  crn                  = "crn:v1:bluemix:public:container-registry:${var.region}:::"
}

resource null_resource ibmcloud_login {
  provisioner "local-exec" {
    command = "${path.module}/scripts/ibmcloud-login.sh ${var.region} ${var.resource_group_name}"

    environment = {
      APIKEY = var.ibmcloud_api_key
    }
  }
}

resource null_resource determine_registry_region {
  triggers = {
    always = timestamp()
  }

  provisioner "local-exec" {
    command = "${path.module}/scripts/determine-registry-region.sh '${var.region}' '${local.registry_region_file}'"
  }
}

data local_file registry_region {
  depends_on = [null_resource.determine_registry_region]

  filename = local.registry_region_file
}

# this should probably be moved to a separate module that operates at a namespace level
resource null_resource create_registry_namespace {
  depends_on = [null_resource.ibmcloud_login]

  provisioner "local-exec" {
    command = "${path.module}/scripts/create-registry-namespace.sh '${var.resource_group_name}' '${local.registry_region}' '${local.registry_namespace}' '${var.upgrade_plan}' '${local.registry_server_file}'"
  }
}

data local_file registry_server {
  depends_on = [null_resource.create_registry_namespace]

  filename = local.registry_server_file
}
