#!/bin/bash

PROVIDERS=('aws' 'hetzner')

provider=${1:-aws}
if [[ ! $(echo ${PROVIDERS[@]} | grep -Fw "$provider") ]]
then
    echo "USAGE: $0 <provider [$(echo $PROVIDERS | tr ' ' '|')]>"
    exit 1
fi

packer init infra/$provider/ooblistener.pkr.hcl

if [[ $provider == "aws" ]]
then
    region=$(aws configure get region --profile "default")
    packer build -var "region=$region" infra/$provider/ooblistener.pkr.hcl
elif [[ $provider == "hetzner" ]]
then
    packer build infra/$provider/ooblistener.pkr.hcl
fi
