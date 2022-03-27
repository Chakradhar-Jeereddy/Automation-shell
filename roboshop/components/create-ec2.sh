#!/bin/bash

source components/common.sh

COMPONENT=$1
if [ -z "$1" ]; then
  echo -e "\e31m Name of the machine is needed \e[0m"
  exit
fi

Print "GET Image ID"
AMI_ID=$(aws ec2 describe-images --filters \
"Name=name, Values=Centos-7-DevOps-Practice" | jq .Images[].ImageId | sed -e 's/"//g')
StatCheck $?

Print "Get security group"
SG_ID=$(aws ec2 describe-security-groups --filters \
"Name=group-name, Values=robo-allow" | jq .SecurityGroups[].GroupId | sed -s 's/"//g')
StatCheck $?

Print "Create spot instance"
aws ec2 run-instances --image-id $AMI_ID --instance-type t2.micro \
--tag-specifications "ResourceType=instance,Tags=[{Key=Name, Value=${COMPONENT}}]" \
--instance-market-options "MarketType=spot" --security-group-ids $SG_ID
StatCheck $?