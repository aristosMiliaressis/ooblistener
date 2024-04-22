variable "profile" {
  description = "The local AWS configuration profile to use."
  type        = string
  default     = "default"
}

variable "domain" {
  description = "The domain name."
  type        = string
}
