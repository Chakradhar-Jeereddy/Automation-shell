#!/bin/bash
USER_ID=$(id -u)
if [ ${USER_ID} -ne 0 ]; then
  echo -e "\e[36m You need to be a root user to run the script\e[0m."
  exit 1
fi

echo -e "\e[36m Cleanup existing  mongodb content \e[0m"
rm -rf /tmp/mongodb*

echo -e "\e[36m Downloading mongodb repository \e[0m"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo

echo -e "\e[36m Installing mongodb \e[0m"
yum install -y mongodb-org

#1. Update Listen IP address from 127.0.0.1 to 0.0.0.0 in config file
#
#Config file: `/etc/mongod.conf`

echo -e "\e[36m Starting mongodb \e[0m"
systemctl start mongod
systemctl enable mongod

echo -e "\e[36m Downloading schemas of mongodb \e[0m"
curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip"
cd /tmp

echo -e "\e[36m Extracting schema files \e[0m"
unzip /tmp/mongodb.zip


echo -e "\e[36m Loading schemas into database \e[0m"
mongo < mongodb-main/catalogue.js
mongo < mongodb-main/users.js
