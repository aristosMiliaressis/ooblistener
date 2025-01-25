#!/bin/bash

if [[ $# -lt 1 ]]
then
    echo "USAGE: $0 <domain>"
    exit 1
fi

domain=$1

terraform -chdir=infra/contabo init -upgrade
terraform -chdir=infra/contabo apply -auto-approve -var="domain=$domain"
vps_ip=$(terraform -chdir=infra/contabo output -raw vps_ip)

echo "All Done!"
echo "Now add the following NS records on your domain registry and wait for them to propagate"
printf "$domain\tNS\t$(dig +short -x $vps_ip)\n"
printf "$domain\tNS\tone.one.one.one"
