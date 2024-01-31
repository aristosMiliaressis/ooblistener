#!/bin/bash

if [ $# -eq 0 ]
then
    echo "USAGE: $0 <domain_name>"
    exit 2
fi

domain=$1

profile="default"
region=$(aws configure get region --profile $profile)

mkdir ~/.ssh 2>/dev/null
[[ ! -f ~/.ssh/ooblistener ]] && ssh-keygen -t ed25519 -f ~/.ssh/ooblistener -C ooblistener -N ""

public_key=$(cat ~/.ssh/ooblistener.pub)

terraform -chdir=aws init
terraform -chdir=aws apply -auto-approve \
            -var="public_key=$public_key" \
            -var="profile=$profile" \
            -var="region=$region"
ec2_ip=$(terraform -chdir=aws output -raw ec2_ip)

printf "[listener]\n$ec2_ip" > inventory 

sleep 5
ssh-keyscan -H $ec2_ip | anew ~/.ssh/known_hosts

ansible-playbook ./tasks/start_ooblistener.yml -i inventory --extra-vars "domain=$domain"

echo "All Done!"
echo "Now add the following NS records on your domain registry and wait for them to propagate"
printf "$domain\tNS\t$(dig +short -x $ec2_ip)\n"
printf "$domain\tNS\tone.one.one.one.\n"
