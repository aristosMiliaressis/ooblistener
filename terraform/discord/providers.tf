terraform {
  required_providers {
    discord = {
      source  = "Lucky3028/discord"
      version = "1.5.0"
    }
  }
}

provider "discord" {
  token = var.discord_token
}
