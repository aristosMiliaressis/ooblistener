#!/bin/bash

if [ $# -eq 0 ]
then
    echo "USAGE: $0 <domain_name>"
    exit 2
fi

domain=$1
profile="default"

terraform -chdir=aws init
terraform -chdir=aws apply -auto-approve \
            -var="profile=$profile" \
            -var="domain=$domain"
ec2_ip=$(terraform -chdir=aws output -raw ec2_ip)

echo "All Done!"
echo "Now add the following NS records on your domain registry and wait for them to propagate"
printf "$domain\tNS\tns1.$domain\n"
printf "$domain\tNS\tns2.$domain\n"
printf "ns1.$domain\tA\t$ec2_ip\n"
printf "ns2.$domain\tA\t$ec2_ip\n"
