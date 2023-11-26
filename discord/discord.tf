resource "discord_server" "this" {
  name                          = local.server_name
  default_message_notifications = 0
  region                        = var.region
}

resource "discord_category_channel" "general" {
  name      = "general"
  server_id = discord_server.this.id
}

resource "discord_text_channel" "all" {
  name                     = "all"
  server_id                = discord_server.this.id
  category                 = discord_category_channel.general.id
  sync_perms_with_category = false
}

resource "discord_text_channel" "smtp" {
  name                     = "smtp"
  server_id                = discord_server.this.id
  category                 = discord_category_channel.general.id
  sync_perms_with_category = false
}

resource "discord_text_channel" "dns" {
  name                     = "dns"
  server_id                = discord_server.this.id
  category                 = discord_category_channel.general.id
  sync_perms_with_category = false
}

resource "discord_text_channel" "http" {
  name                     = "http"
  server_id                = discord_server.this.id
  category                 = discord_category_channel.general.id
  sync_perms_with_category = false
}

resource "discord_text_channel" "exfil" {
  name                     = "exfil"
  server_id                = discord_server.this.id
  category                 = discord_category_channel.general.id
  sync_perms_with_category = false
}

resource "discord_webhook" "all" {
  channel_id = discord_text_channel.all.id
  name       = local.bot_name
}

resource "discord_webhook" "dns" {
  channel_id = discord_text_channel.dns.id
  name       = local.bot_name
}

resource "discord_webhook" "smtp" {
  channel_id = discord_text_channel.smtp.id
  name       = local.bot_name
}

resource "discord_webhook" "http" {
  channel_id = discord_text_channel.http.id
  name       = local.bot_name
}

resource "discord_webhook" "exfil" {
  channel_id = discord_text_channel.exfil.id
  name       = local.bot_name
}

resource "discord_invite" "this" {
  channel_id = resource.discord_text_channel.all.id
  max_age    = 0
}
