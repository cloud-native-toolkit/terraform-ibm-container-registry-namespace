# Resource Group Variables
variable "resource_group_name" {
  type        = string
  description = "The name of the IBM Cloud resource group where the cluster will be created/can be found."
  
}

variable "ibmcloud_api_key" {
  type        = string
  description = "The IBM Cloud api token"
}

variable "region" {
  type        = string
  description = "The region for the image registry been installed."
}

variable "registry_namespace" {
  type        = string
  description = "The namespace that will be created in the IBM Cloud image registry. If not provided the value will default to the resource group"
  default     = ""
}

variable "registry_user" {
  type        = string
  description = "The username to authenticate to the IBM Container Registry"
  default     = "iamapikey"
}

variable "registry_password" {
  type        = string
  description = "The password (API key) to authenticate to the IBM Container Registry. If not provided the value will default to `var.ibmcloud_api_key`"
  default     = ""
}

variable "upgrade_plan" {
  type        = bool
  description = "Flag indicating that the container registry plan should be upgraded from Free to Standard"
  default     = true
}
