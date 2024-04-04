#!/bin/bash

vps_ip=$(terraform -chdir=aws output -raw vps_ip)
ssh-keygen -R $vps_ip

profile="default"

terraform -chdir=aws destroy -auto-approve \
            -var="profile=$profile" \
            -var="domain="
