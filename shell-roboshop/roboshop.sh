#!/bin/bash

# Scipt creates the ec2-instance instance and updates DNS recod in route53

zone_id=Z02261422B2DDXKRO1N94
sg_id=sg-0354331bff19aa12f
ami_id=ami-0220d79f3f480ecf5
domain_name=chakra86.store

for instance_name in $@; do
 #Create instance and get the ID of the instance

 instance_id=$(aws ec2 run-instances \
    --image-id $ami_id \
    --instance-type t3.micro \
    --count 1 \
    --security-group-ids $sg_id \
    --subnet-id subnet-0ffed07e6d5191e37 \
    --network-interfaces '{"DeviceIndex":0,"AssociatePublicIpAddress":true}' \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance_name}]" \
    --query 'Instances[0].InstanceId' \
    --output text)

 # Wiat until the IP address is allocated to the instance
 aws ec2 wait instance-running --instance-ids "$instance_id"

 # if instance name is frontend, fetch public IP
 # If not, fetch private IP.

 if [ "$instance_name" == "frontend" ]; then
    ip_address=$(aws ec2 describe-instances \
    --instance-ids $instance_id \
    --query "Reservations[].Instances[].PublicIpAddress" \
    --output text)
 else
   ip_address=$(aws ec2 describe-instances \
    --instance-ids $instance_id \
    --query "Reservations[].Instances[].PrivateIpAddress" \
    --output text)
 fi

 change_batch=$(cat <<EOF
{
  "Changes": [
    {
      "Action": "UPSERT",
      "ResourceRecordSet": {
        "Name": "$instance_name.$domain_name",
        "Type": "A",
        "TTL": 100,
        "ResourceRecords": [
          {
            "Value": "$ip_address"
          }
        ]
      }
    }
  ]
}
EOF
)

 aws route53 change-resource-record-sets \
  --hosted-zone-id "$zone_id" \
  --change-batch "$change_batch"
done



#instance_name=$(aws ec2 describe-instances  --instance-ids $instance_id --filters "Name=tag:Name,Values=frontend" --query "Reservations[].Instances[].PublicIpAddress"  --output text)
