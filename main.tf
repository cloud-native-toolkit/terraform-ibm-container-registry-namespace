
locals {
  tmp_dir            = "${path.cwd}/.tmp"
  registry_url_file  = "${local.tmp_dir}/registry_url.val"
  registry_namespace = var.registry_namespace != "" ? var.registry_namespace : var.resource_group_name
  registry_user      = var.registry_user != "" ? var.registry_user : "iamapikey"
  registry_password  = var.registry_password != "" ? var.registry_password : var.ibmcloud_api_key
  registry_url       = data.local_file.registry_url.content
  service            = "container-registry"
  crn                = "crn:v1:bluemix:public:container-registry:${var.region}:::"
}

resource null_resource ibmcloud_login {
  provisioner "local-exec" {
    command = "${path.module}/scripts/ibmcloud-login.sh ${var.region} ${var.resource_group_name}"

    environment = {
      APIKEY = var.ibmcloud_api_key
    }
  }
}

# this should probably be moved to a separate module that operates at a namespace level
resource "null_resource" "create_registry_namespace" {
  depends_on = [null_resource.ibmcloud_login]

  provisioner "local-exec" {
    command = "${path.module}/scripts/create-registry-namespace.sh '${local.registry_namespace}' '${var.region}' '${var.upgrade_plan}' '${local.registry_url_file}'"
  }
}

data "local_file" "registry_url" {
  depends_on = [null_resource.create_registry_namespace]

  filename = local.registry_url_file
}
