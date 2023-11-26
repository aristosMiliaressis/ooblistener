#!/bin/bash
set -ouex

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

interactsh-server -hi /opt/www/ssrf.html -se -dr -hd /opt/www -d $DOMAIN -ip $IP -csh nginx -dv -wc -t "$token" &

sleep 2

interactsh-client -json -o /opt/pingbacks.json -s "127.0.0.1" -t "$token" | notify -silent -bulk -provider discord -id oob &

while true 
do
    sleep 2

    cat /opt/pingbacks.json \
        | grep -iv 'Sec-fetch-Site: same-origin' \
        | jq -c 'select( .protocol == "http" )' \
        | anew /opt/http-pingbacks.json \
        | jq -c 'select( ."unique-id" != "exfil.u.'$DOMAIN'" )' \
        | jq -r '"\(."remote-address")\n\(."raw-request")"' \
        | notify -silent -bulk -provider discord -id http

    cat /opt/http-pingbacks.json | jq -c 'select( ."unique-id" == "exfil.u.'$DOMAIN'" )' \
        | anew /opt/exfil.json \
        | jq -r '"\(."remote-address")\n\(."raw-request")"' \
        | notify -silent -bulk -provider discord -id exfil

    cat /opt/pingbacks.json \
        | jq -c 'select( .protocol == "dns" )' \
        | anew /opt/dns-pingbacks.json \
        | jq -r '"\(."remote-address")\n\(."raw-request")"' \
        | notify -silent -bulk -provider discord -id dns
    
    cat /opt/pingbacks.json \
        | jq -c 'select( .protocol == "smtp" )' \
        | anew /opt/smtp-pingbacks.json \
        | jq -r '"\(."remote-address")\n\(."raw-request")"' \
        | notify -silent -bulk -provider discord -id smtp
done