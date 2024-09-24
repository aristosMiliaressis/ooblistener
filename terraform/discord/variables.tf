variable "discord_token" {
  description = "The discord authentication token."
  type        = string
  sensitive   = true
}

variable "region" {
  description = "The server region."
  type        = string
  default     = "us-east"
}

locals {
  bot_name    = "ooblistener_bot"
  server_name = "ooblistener_srv"
}
