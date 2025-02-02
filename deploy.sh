#!/bin/bash

PROVIDERS=('aws' 'hetzner')

domain=$1
provider=${2:-aws}
if [[ $# -lt 1 || ! $(echo ${PROVIDERS[@]} | fgrep -w "$provider") ]]
then
    echo "USAGE: $0 <domain> <provider [$(echo $PROVIDERS | tr ' ' '|')]>"
    exit 1
fi

terraform -chdir=infra/$provider init
terraform -chdir=infra/$provider apply -auto-approve -var="domain=$domain"
vps_ip=$(terraform -chdir=infra/$provider output -raw vps_ip)

echo "All Done!"
echo "Now add the following NS records on your domain registry and wait for them to propagate"
printf "$domain\tNS\t$(dig +short -x $vps_ip)\n"
printf "$domain\tNS\tone.one.one.one"
