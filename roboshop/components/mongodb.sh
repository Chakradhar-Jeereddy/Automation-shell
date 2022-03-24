#!/bin/bash
USER_ID=$(id -u)
if [ ${USER_ID} -ne 0 ]; then
  echo -e "\e[36m You need to be a root user to run the script."
  exit 1
fi
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo

yum install -y mongodb-org

#1. Update Listen IP address from 127.0.0.1 to 0.0.0.0 in config file
#
#Config file: `/etc/mongod.conf`

systemctl start mongod
systemctl enable mongod

rm -rf /tmp/mongodb*

curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip"
cd /tmp
unzip /tmp/mongodb.zip
cd mongodb-main
mongo < catalogue.js
mongo < users.js