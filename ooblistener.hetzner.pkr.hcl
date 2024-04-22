packer {
  required_plugins {
    ansible = {
      source  = "github.com/hashicorp/ansible"
      version = "~> 1"
    }
    hcloud = {
      source  = "github.com/hetznercloud/hcloud"
      version = "~> 1"
    }
  }
}

variable "hcloud_token" {
  description = "The Hetzner Cloud API token."
  type        = string
  sensitive   = true
}

source "hcloud" "ooblistener" {
  token = var.hcloud_token
  image = "ubuntu-22.04"
  location = "nbg1"
  server_type = "cx11"
  ssh_username = "root"
  snapshot_labels = {"name" = "ooblistener"}
}

build {
  sources = [
    "source.hcloud.ooblistener"
  ]

  provisioner "shell" {
    inline = ["/usr/bin/cloud-init status --wait"]
  }

  provisioner "ansible" {
    playbook_file = "./tasks/setup_python.yml"
  }

  provisioner "ansible" {
    playbook_file = "./tasks/setup_golang.yml"
  }

  provisioner "ansible" {
    playbook_file = "./tasks/setup_notify.yml"
  }
  
  provisioner "ansible" {
    playbook_file = "./tasks/setup_interactsh.yml"
  }
  
  provisioner "ansible" {
    playbook_file = "./tasks/setup_xsshunterlite.yml"
  }
  
  provisioner "ansible" {
    playbook_file = "./tasks/setup_cron.yml"
  }
}