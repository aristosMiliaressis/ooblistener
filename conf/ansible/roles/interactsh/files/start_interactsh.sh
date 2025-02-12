#!/bin/bash

if [ "$EUID" -ne 0 ]
then
    echo "Please run as root"
    exit 1
fi

. /etc/profile

ip=$(curl -s -4 ifconfig.me)
token=$(cat /dev/random | head -c 48 | base64 | tr -d '=')

interactsh-server -eviction 0 -hi /opt/www/index.html -hd /opt/www -scan-everywhere -dynamic-resp -d $DOMAIN \
    -responder -ldap -http-port 8 -https-port 4 -ip $ip -server-header nginx -disable-version -wildcard -t "$token" &

sleep 5

mkfifo /opt/interaction.fifo 2>/dev/null
interactsh-client -ps -psf ./www/payload -asn -no-http-fallback -json -o /opt/interaction.fifo -s https://127.0.0.1:4 -t "$token" &

while true
do
    timeout 1 cat /opt/interaction.fifo > /tmp/interaction.tmp

    cat /tmp/interaction.tmp \
        | jq -c 'select( .protocol == "http" ) | {"remote-address",asninfo,"raw-request"}'| awk '!x[$0]++' \
        | jq -r '"\(."remote-address") \(.asninfo[0].org)\n\(."raw-request")"' \
        | notify -pc /opt/provider-config.yaml -silent -bulk -provider discord -id http

    cat /tmp/interaction.tmp \
        | jq -c 'select( .protocol == "dns" )' \
        | jq -r '"\(."remote-address") \(.asninfo[0].org)\n\(."raw-request")"' \
        | notify -pc /opt/provider-config.yaml -silent -bulk -provider discord -id dns

    cat /tmp/interaction.tmp \
        | jq -c 'select( .protocol == "smtp" )' \
        | jq -r '"\(."remote-address") \(.asninfo[0].org)\n\(."raw-request")"' \
        | notify -pc /opt/provider-config.yaml -silent -bulk -provider discord -id smtp

    cat /tmp/interaction.tmp \
        | jq -c 'select( .protocol == "smb" )' \
        | jq -r '."raw-request"' \
        | notify -pc /opt/provider-config.yaml -silent -bulk -provider discord -id smb

    cat /tmp/interaction.tmp \
        | jq -c 'select( .protocol == "ldap" )' \
        | jq -r '."raw-request"' \
        | notify -pc /opt/provider-config.yaml -silent -bulk -provider discord -id ldap
done
