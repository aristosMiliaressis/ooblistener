#!/bin/bash

IP=$(curl -s ifconfig.me)
DOMAIN=$(cat /opt/domain.txt)

if [[ "$IP" != "$(dig +short $DOMAIN)" ]]
then
    exit
fi

# restart ooblistener to generate https cert
systemctl restart ooblistener

# unregister cronjob
sudo crontab -l | grep -v '/opt/setup_https.sh' | sudo crontab -