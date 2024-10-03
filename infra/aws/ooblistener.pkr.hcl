packer {
  required_plugins {
    ansible = {
      source  = "github.com/hashicorp/ansible"
      version = "~> 1"
    }
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "1.0.8"
    }
  }
}

variable "region" {
  type = string
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

source "amazon-ebs" "ooblistener" {
  ami_name = "ooblistener-${local.timestamp}"

  source_ami_filter {
    filters = {
      architecture        = "x86_64"
      name                = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["amazon"]
  }

  instance_type           = "t2.micro"
  region                  = var.region
  ssh_username            = "ubuntu"
  temporary_key_pair_type = "ed25519"
}

build {
  sources = [
    "source.amazon-ebs.ooblistener"
  ]

  provisioner "shell" {
    inline = ["/usr/bin/cloud-init status --wait"]
  }

  provisioner "ansible" {
    playbook_file = "conf/ansible/build.yml"
    ansible_env_vars = [ "ANSIBLE_CONFIG=conf/ansible/ansible.cfg" ]
  }
}
