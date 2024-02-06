#!/bin/bash

if [ $# -eq 0 ]
then
  echo "USAGE: $0 <discord_bot_token>"
  exit 2
fi

discord_token=$1

terraform -chdir=discord init
terraform -chdir=discord apply -auto-approve -var="discord_token=$discord_token"

dns_channel_webhook=$(terraform -chdir=discord output -raw dns_channel_webhook)
smtp_channel_webhook=$(terraform -chdir=discord output -raw smtp_channel_webhook)
smb_channel_webhook=$(terraform -chdir=discord output -raw smb_channel_webhook)
http_channel_webhook=$(terraform -chdir=discord output -raw http_channel_webhook)
xss_channel_webhook=$(terraform -chdir=discord output -raw xss_channel_webhook)

cat >./files/conf/provider-config.yaml <<EOF
discord:
  - id: "dns"
    discord_channel: "dns"
    discord_username: "listenerBot"
    discord_format: "{{data}}"
    discord_webhook_url: "${dns_channel_webhook}"
  - id: "http"
    discord_channel: "http"
    discord_username: "listenerBot"
    discord_format: "{{data}}"
    discord_webhook_url: "${http_channel_webhook}"
  - id: "smtp"
    discord_channel: "smtp"
    discord_username: "listenerBot"
    discord_format: "{{data}}"
    discord_webhook_url: "${smtp_channel_webhook}"
  - id: "smb"
    discord_channel: "smb"
    discord_username: "listenerBot"
    discord_format: "{{data}}"
    discord_webhook_url: "${smb_channel_webhook}"
  - id: "xss"
    discord_channel: "xss"
    discord_username: "listenerBot"
    discord_format: "{{data}}"
    discord_webhook_url: "${xss_channel_webhook}"
EOF

invite=$(terraform -chdir=discord output -raw invite)
echo "Use this invite '$invite' to access the server"