variable "hcloud_token" {
  description = "The Hetzner Cloud API token."
  type        = string
  sensitive   = true
}

variable "domain" {
  description = "The domain name."
  type        = string
}
