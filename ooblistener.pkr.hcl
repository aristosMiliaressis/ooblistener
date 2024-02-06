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
      name                = "al2023-ami-2023.*.1-x86_64"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["amazon"]
  }

  instance_type           = "t2.micro"
  region                  = var.region
  ssh_username            = "ec2-user"
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