# IBM Container Registry module

Module to set up the IBM Container Registry, including creating a namespace and upgrading the plan.

## Software dependencies

The module depends on the following software components:

### Command-line tools

- terraform - v0.15

### Terraform providers

- None

## Module dependencies

This module makes use of the output from other modules:

- Resource group - github.com/cloud-native-toolkit/terraform-ibm-resource-group

## Example usage

```hcl-terraform
module "container_registry" {
  source = "github.com/cloud-native-toolkit/terraform-ibm-container-registry.git"

  resource_group_name = module.resource_group.name
  ibmcloud_api_key    = var.ibmcloud_api_key
  region              = var.region
  registry_namespace  = var.registry_namespace
  upgrade_plan        = var.upgrade_plan
}
```
