output "dns_channel_webhook" {
  value     = discord_webhook.dns.url
  sensitive = true
}

output "smtp_channel_webhook" {
  value     = discord_webhook.smtp.url
  sensitive = true
}

output "http_channel_webhook" {
  value     = discord_webhook.http.url
  sensitive = true
}

output "invite" {
  value = resource.discord_invite.this.id
}
