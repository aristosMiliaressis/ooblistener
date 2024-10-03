terraform {
  required_version = ">= 0.14"

  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.45"
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

provider "hcloud" {
  token = var.hcloud_token
}
