#!/bin/bash

source components/common.sh

LOG_FILE=/tmp/roboshop.log
rm -rf $LOG_FILE

USER_ID=$(id -u)
if [ ${USER_ID} -ne 0 ]; then
  Print "You need to be a root user to run the script."
  exit 1
fi

Print "Cleanup existing mongodb content"
StatCheck $?

Print "Downloading mongodb repository"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>$LOG_FILE
StatCheck $?

Print "Installing mongodb"
yum install -y mongodb-org &>>$LOG_FILE
StatCheck $?

Print "ADD IP ADDRESS"
sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
StatCheck $?

Print "Starting mongodb"
systemctl restart mongod && systemctl enable mongod
StatCheck $?

Print "Downloading schemas of mongodb"
curl -f -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip" &>>$LOG_FILE
StatCheck $?

Print "Extracting schema"
#Use -o option of zip command to overwrite the files
cd /tmp && unzip -o /tmp/mongodb.zip &>>$LOG_FILE
StatCheck $?

Print "Loading schemas e"
mongo < mongodb-main/catalogue.js &>>$LOG_FILE && mongo < mongodb-main/users.js &>>$LOG_FILE
StatCheck $?