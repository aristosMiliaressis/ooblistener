variable "profile" {
  description = "The local AWS configuration profile to use."
  type        = string
}

variable "domain" {
  description = "The domain name."
  type        = string
}

locals {
  private_key_location = "${data.external.local_home.result.home}/.ssh/ooblistener"
}