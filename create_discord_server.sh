#!/bin/bash

if [ $# -eq 0 ]
then
  echo "USAGE: $0 <discord_bot_token>"
  exit 2
fi

discord_token=$1

terraform -chdir=infra/discord init
terraform -chdir=infra/discord apply -auto-approve -var="discord_token=$discord_token"

status_channel_webhook=$(terraform -chdir=infra/discord output -raw status_channel_webhook)
dns_channel_webhook=$(terraform -chdir=infra/discord output -raw dns_channel_webhook)
smtp_channel_webhook=$(terraform -chdir=infra/discord output -raw smtp_channel_webhook)
ldap_channel_webhook=$(terraform -chdir=infra/discord output -raw ldap_channel_webhook)
smb_channel_webhook=$(terraform -chdir=infra/discord output -raw smb_channel_webhook)
http_channel_webhook=$(terraform -chdir=infra/discord output -raw http_channel_webhook)
xss_channel_webhook=$(terraform -chdir=infra/discord output -raw xss_channel_webhook)

cat >./conf/ansible/roles/notify/files/provider-config.yaml <<EOF
discord:
  - id: "status"
    discord_channel: "status"
    discord_username: "ooblistener_bot"
    discord_format: "{{data}}"
    discord_webhook_url: "${status_channel_webhook}"
  - id: "dns"
    discord_channel: "dns"
    discord_username: "ooblistener_bot"
    discord_format: "{{data}}"
    discord_webhook_url: "${dns_channel_webhook}"
  - id: "http"
    discord_channel: "http"
    discord_username: "ooblistener_bot"
    discord_format: "{{data}}"
    discord_webhook_url: "${http_channel_webhook}"
  - id: "smtp"
    discord_channel: "smtp"
    discord_username: "ooblistener_bot"
    discord_format: "{{data}}"
    discord_webhook_url: "${smtp_channel_webhook}"
  - id: "ldap"
    discord_channel: "ldap"
    discord_username: "ooblistener_bot"
    discord_format: "{{data}}"
    discord_webhook_url: "${ldap_channel_webhook}"
  - id: "smb"
    discord_channel: "smb"
    discord_username: "ooblistener_bot"
    discord_format: "{{data}}"
    discord_webhook_url: "${smb_channel_webhook}"
  - id: "xss"
    discord_channel: "xss"
    discord_username: "ooblistener_bot"
    discord_format: "{{data}}"
    discord_webhook_url: "${xss_channel_webhook}"
EOF

invite=$(terraform -chdir=infra/discord output -raw invite)
echo "Use this invite '$invite' to access the server"
