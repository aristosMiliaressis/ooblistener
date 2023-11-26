output "all_channel_webhook" {
  value     = discord_webhook.all.url
  sensitive = true
}

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

output "exfil_channel_webhook" {
  value     = discord_webhook.exfil.url
  sensitive = true
}

output "invite" {
  value = resource.discord_invite.this.id
}
