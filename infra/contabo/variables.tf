variable "domain" {
  description = "The domain name."
  type        = string
}

variable "api_user" {
  description = ""
  type        = string
  sensitive   = true
}

variable "api_pass" {
  description = ""
  type        = string
  sensitive   = true
}

variable "client_id" {
  description = ""
  type        = string
  sensitive   = true
}

variable "client_secret" {
  description = ""
  type        = string
  sensitive   = true
}
