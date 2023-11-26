#!/bin/bash

ec2_ip=$(terraform -chdir=aws output -raw ec2_ip)
ssh-keygen -R $ec2_ip
rm ~/.ssh/ooblistener*
rm inventory

profile="default"
region=$(aws configure get region --profile $profile)

terraform -chdir=aws destroy -auto-approve \
            -var="public_key=doesnt_matter" \
            -var="profile=$profile" \
            -var="region=$region"
