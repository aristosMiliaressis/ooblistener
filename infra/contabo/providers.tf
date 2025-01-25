terraform {
  required_version = ">= 0.14"

  required_providers {
    contabo = {
      source  = "contabo/contabo"
      version = ">= 0.1.28"
    }
    external = {
      source  = "hashicorp/external"
      version = ">= 2.3.4"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 2.5.2"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 4.0.6"
    }
  }
}

provider "contabo" {
  oauth2_client_id     = var.client_id
  oauth2_client_secret = var.client_secret
  oauth2_user          = var.api_user
  oauth2_pass          = var.api_pass
}
