#!/bin/bash
set -ux

if [ "$EUID" -ne 0 ]
then
    echo "Please run as root"
    exit 1
fi

export PATH=$PATH:/home/ec2-user/go/bin

IP=$(curl -s ifconfig.me)
DOMAIN=$(cat /opt/domain.txt)

# setup cronjob to restart listener & grab https cert when dns records have propagated
echo "*/30 * * * * /opt/setup_https.sh" | crontab -

if [[ ! -f token.txt ]]
then
    cat /dev/random | head -c 48 | base64 | tr -d '=' > /opt/token.txt
fi
token=$(cat /opt/token.txt)

interactsh-server -hi /opt/www/index.html -se -dr -hd /opt/www -d $DOMAIN -ip $IP -csh nginx -dv -wc -t "$token" &

sleep 2

while true 
do
    timeout 8s interactsh-client -json -o /opt/pingbacks.json -s "127.0.0.1" -t "$token"

    cat /opt/pingbacks.json \
        | grep -iv 'Sec-fetch-Site: same-origin' \
        | jq -c 'select( .protocol == "http" )' \
        | jq -r '"\(."remote-address") \(.asninfo[0].org)\n\(."raw-request")"' \
        | notify -silent -bulk -provider discord -id http

    cat /opt/pingbacks.json \
        | jq -c 'select( .protocol == "dns" )' \
        | jq -r '"\(."remote-address") \(.asninfo[0].org)\n\(."raw-request")"' \
        | notify -silent -bulk -provider discord -id dns
    
    cat /opt/pingbacks.json \
        | jq -c 'select( .protocol == "smtp" )' \
        | jq -r '"\(."remote-address") \(.asninfo[0].org)\n\(."raw-request")"' \
        | notify -silent -bulk -provider discord -id smtp
done