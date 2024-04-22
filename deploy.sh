#!/bin/bash

PROVIDERS=('aws' 'hetzner')

domain=$1
provider=${2:-aws}
if [[ $# -lt 1 || ! $(echo ${PROVIDERS[@]} | fgrep -w "$provider") ]]
then
    echo "USAGE: $0 <domain> <provider [$(echo $PROVIDERS | tr ' ' '|')]>"
    exit 1
fi

terraform -chdir=terraform/$provider init
terraform -chdir=terraform/$provider apply -auto-approve -var="domain=$domain"
vps_ip=$(terraform -chdir=terraform/$provider output -raw vps_ip)

echo "All Done!"
echo "Now add the following NS records on your domain registry and wait for them to propagate"
printf "$domain\tNS\tns1.$domain\n"
printf "$domain\tNS\tns2.$domain\n"
printf "ns1.$domain\tA\t$vps_ip\n"
printf "ns2.$domain\tA\t$vps_ip\n"
