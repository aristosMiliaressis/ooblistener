#!/bin/bash

IP=$(curl -s ifconfig.me)
DOMAIN=$(cat /opt/domain.txt)

# makes sure that dns is setup correctly
if [[ "$IP" != "$(dig +short $DOMAIN)" ]]
then
    exit
fi

# restart ooblistener to generate https cert
systemctl restart ooblistener

# wait for ooblistener to generate ssl cert
sleep 30

/opt/start_xsshunterlite.sh $DOMAIN

# unregister cronjob
sudo crontab -l | grep -v '/opt/setup_https.sh' | sudo crontab -