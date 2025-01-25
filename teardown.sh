#!/bin/bash

vps_ip=$(terraform -chdir=infra/contabo output -raw vps_ip)
ssh-keygen -R $vps_ip

terraform -chdir=infra/contabo destroy -auto-approve -var="domain="
