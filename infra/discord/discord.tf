resource "discord_server" "this" {
  name                          = local.server_name
  default_message_notifications = 0
  region                        = var.region
}

resource "discord_category_channel" "general" {
  name      = "general"
  server_id = discord_server.this.id
}

resource "discord_text_channel" "status" {
  name                     = "status"
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

resource "discord_text_channel" "ldap" {
  name                     = "ldap"
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

resource "discord_text_channel" "smb" {
  name                     = "smb"
  server_id                = discord_server.this.id
  category                 = discord_category_channel.general.id
  sync_perms_with_category = false
}

resource "discord_text_channel" "xss" {
  name                     = "xss"
  server_id                = discord_server.this.id
  category                 = discord_category_channel.general.id
  sync_perms_with_category = false
}

resource "discord_webhook" "dns" {
  channel_id = discord_text_channel.dns.id
  name       = local.bot_name
}

resource "discord_webhook" "status" {
  channel_id = discord_text_channel.status.id
  name       = local.bot_name
}

resource "discord_webhook" "smtp" {
  channel_id = discord_text_channel.smtp.id
  name       = local.bot_name
}

resource "discord_webhook" "ldap" {
  channel_id = discord_text_channel.ldap.id
  name       = local.bot_name
}

resource "discord_webhook" "http" {
  channel_id = discord_text_channel.http.id
  name       = local.bot_name
}

resource "discord_webhook" "smb" {
  channel_id = discord_text_channel.smb.id
  name       = local.bot_name
}

resource "discord_webhook" "xss" {
  channel_id = discord_text_channel.xss.id
  name       = local.bot_name
}

resource "discord_invite" "this" {
  channel_id = resource.discord_text_channel.dns.id
  max_age    = 0
}
