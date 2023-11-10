terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "service_mesh_configuration_error_in_istio" {
  source    = "./modules/service_mesh_configuration_error_in_istio"

  providers = {
    shoreline = shoreline
  }
}