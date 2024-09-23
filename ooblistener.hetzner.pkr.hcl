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
    playbook_file = "./ansible/build.yml"
        ansible_env_vars = [ "ANSIBLE_CONFIG=ansible/ansible.cfg" ]
  }
}
