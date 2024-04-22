#!/bin/bash

PROVIDERS=('aws' 'hetzner')

provider=${1:-aws}
if [[ ! $(echo ${PROVIDERS[@]} | fgrep -w "$provider") ]]
then
    echo "USAGE: $0 <provider [$(echo $PROVIDERS | tr ' ' '|')]>"
    exit 1
fi

vps_ip=$(terraform -chdir=terraform/$provider output -raw vps_ip)
ssh-keygen -R $vps_ip

terraform -chdir=terraform/$provider destroy -auto-approve -var="domain="
