#!/bin/bash

source components/common.sh

Print "Setup yum repos"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>$LOG_FILE
StatCheck $?

Print "Installing mongodb"
yum install -y mongodb-org &>>$LOG_FILE
StatCheck $?

Print "Update mongodb listener address"
sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
StatCheck $?

Print "Starting mongodb"
systemctl restart mongod &>>$LOG_FILE && systemctl enable mongod &>>$LOG_FILE
StatCheck $?

Print "Downloading schemas"
curl -f -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip" &>>$LOG_FILE
StatCheck $?

Print "Extracting schema"
#Use -o option of zip command to overwrite the files
cd /tmp && unzip -o mongodb.zip &>>$LOG_FILE
StatCheck $?

Print "Loading schemas"
cd mongodb-main
for schema in catalogue users; do
  echo -e "\n...Loading $schema schema..." &>>$LOG_FILE
  mongo < ${schema}.js &>>$LOG_FILE
  StatCheck $?
done

