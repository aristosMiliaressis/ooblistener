#!/bin/bash

PROVIDERS=('aws' 'hetzner')

provider=${1:-aws}
if [[ ! $(echo ${PROVIDERS[@]} | fgrep -w "$provider") ]]
then
    echo "USAGE: $0 <provider [$(echo $PROVIDERS | tr ' ' '|')]>"
    exit 1
fi

packer init ooblistener.$provider.pkr.hcl

if [[ $provider == "aws" ]]
then
    region=$(aws configure get region --profile "default")
    packer build -var "region=$region" ooblistener.aws.pkr.hcl
elif [[ $provider == "hetzner" ]]
then
    packer build ooblistener.hetzner.pkr.hcl
fi
