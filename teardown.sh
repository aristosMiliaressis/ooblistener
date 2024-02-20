#!/bin/bash

ec2_ip=$(terraform -chdir=aws output -raw ec2_ip)
ssh-keygen -R $ec2_ip

profile="default"

terraform -chdir=aws destroy -auto-approve \
            -var="profile=$profile" \
            -var="domain="
