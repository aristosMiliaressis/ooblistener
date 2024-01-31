#!/bin/bash
set -ux

if [ "$EUID" -ne 0 ]
then
    echo "Please run as root"
    exit 1
fi

PATH="$PATH:/usr/local/go/bin"

IP=$(curl -s ifconfig.me)
DOMAIN=$(cat /opt/domain.txt)

if [[ ! -f token.txt ]]
then
    cat /dev/random | head -c 48 | base64 | tr -d '=' > /opt/token.txt
fi
token=$(cat /opt/token.txt)

interactsh-server -hi /opt/www/index.html -se -dr -hd /opt/www -d $DOMAIN \
    -http-port 8 -https-port 4 -ip $IP -csh nginx -dv -wc -t "$token" &

sleep 2

while true 
do
    timeout 8s interactsh-client -json -o /opt/pingbacks.json -s https://127.0.0.1:4 -t "$token"

    cat /opt/pingbacks.json \
        | grep -iv 'Sec-fetch-Site: same-origin' \
        | jq -c 'select( .protocol == "http" )' \
        | jq -r '"\(."remote-address") \(.asninfo[0].org)\n\(."raw-request")"' \
        | notify -provider-config /opt/provider-config.yaml -silent -bulk -provider discord -id http

    cat /opt/pingbacks.json \
        | jq -c 'select( .protocol == "dns" )' \
        | jq -r '"\(."remote-address") \(.asninfo[0].org)\n\(."raw-request")"' \
        | notify -provider-config /opt/provider-config.yaml -silent -bulk -provider discord -id dns
    
    cat /opt/pingbacks.json \
        | jq -c 'select( .protocol == "smtp" )' \
        | jq -r '"\(."remote-address") \(.asninfo[0].org)\n\(."raw-request")"' \
        | notify -provider-config /opt/provider-config.yaml -silent -bulk -provider discord -id smtp
done