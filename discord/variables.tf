variable "discord_token" {
  description = "The discord authentication token."
  type        = string
  sensitive   = true
}

variable "region" {
  description = "The server region."
  default     = "us-east"
}

locals {
  bot_name    = "listenerBot"
  server_name = "oobListenerSrv"
}
