terraform {
  required_version = ">= 0.14"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0"
    }
  }
}

data "external" "aws_region" {
  program = ["bash", "-c", "aws configure get region --profile ${var.profile} | jq --raw-input '. | { region: (.) }'"]
}

provider "aws" {
  profile = var.profile
  region  = data.external.aws_region.result.region

  default_tags {
    tags = {
      Name = "ooblistener"
    }
  }
}