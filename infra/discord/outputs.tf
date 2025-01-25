output "dns_channel_webhook" {
  value     = discord_webhook.dns.url
  sensitive = true
}

output "status_channel_webhook" {
  value     = discord_webhook.status.url
  sensitive = true
}

output "smtp_channel_webhook" {
  value     = discord_webhook.smtp.url
  sensitive = true
}

output "ldap_channel_webhook" {
  value     = discord_webhook.ldap.url
  sensitive = true
}

output "http_channel_webhook" {
  value     = discord_webhook.http.url
  sensitive = true
}

output "smb_channel_webhook" {
  value     = discord_webhook.smb.url
  sensitive = true
}

output "xss_channel_webhook" {
  value     = discord_webhook.xss.url
  sensitive = true
}

output "invite" {
  value     = resource.discord_invite.this.id
  sensitive = true
}
