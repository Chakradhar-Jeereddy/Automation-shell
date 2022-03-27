#!/bin/bash

source components/common.sh
Zone_ID=Z0044635YWL0HFQYR5YV

COMPONENT=$1
if [ -z "$1" ]; then
  echo -e "\e[31m Name of the machine is needed \e[0m"
  exit
fi

Print "GET Image ID"
AMI_ID=$(aws ec2 describe-images --filters \
"Name=name, Values=Centos-7-DevOps-Practice" | jq .Images[].ImageId | sed -e 's/"//g') &>>${LOG_FILE}
StatCheck $?

Print "Get security group"
SG_ID=$(aws ec2 describe-security-groups --filters \
"Name=group-name, Values=robo-allow" | jq .SecurityGroups[].GroupId | sed -s 's/"//g') &>>${LOG_FILE}
StatCheck $?

create_ec2() {
  Print "Create spot instance"
  PRIVATE_IP=(aws ec2 run-instances \
  --image-id $AMI_ID \
  --instance-type t2.micro \
  --tag-specifications "ResourceType=instance,Tags=[{Key=Name, Value=${COMPONENT}}]" \
  --instance-market-options "MarketType=spot,SpotOptions={SpotInstanceType=persistent,InstanceInterruptionBehavior=stop}" \
  --security-group-ids $SG_ID | jq .Instances[].PrivateIpAddress | sed -e 's/"//g')
  sed -e "s/component/${COMPONENT}/" -e "s/PRIVATE_IP/${PRIVATE_IP}" dnsrecord.json &>/tmp/record.json
  aws route53 change-resource-record-sets --hosted-zone-id ${Zone_ID} --change-batch file:/tmp/record.json | jq
  StatCheck $?
}

if [ $1 == "all"]; then
  for compnent in frontendv1 cart mongodb catalogue redis user mysql ship rabbit payment; do
    COMPONENT=$compnent
    create_ec2
  done
else
  create_ec2
fi

