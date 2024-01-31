variable "public_key" {
  description = "The SSH public key."
  type        = string
}

variable "profile" {
  description = "The local AWS configuration profile to use."
  type        = string
}

variable "region" {
  description = "The AWS region."
  type        = string
}
