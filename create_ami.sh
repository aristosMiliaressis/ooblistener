#!/bin/bash

profile="default"
region=$(aws configure get region --profile $profile)

packer init .
packer build  -var "region=$region" ooblistener.pkr.hcl