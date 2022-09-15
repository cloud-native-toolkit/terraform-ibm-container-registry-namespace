terraform {
}

locals {
  name_prefix = "ee-${random_string.name-prefix.result}"
}

resource "random_string" "name-prefix" {
  length           = 15
  special          = false
  upper = false
  numeric = false
}