#!/bin/bash

source components/common.sh

Print "Configuring repos"
curl -L https://raw.githubusercontent.com/roboshop-devops-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo &>>$LOG_FILE
StatCheck $?

Print "Installing Redis"
yum install redis -y &>>$LOG_FILE
StatCheck $?

Print "Service setup"
if [ -f /etc/redis.conf && -f /etc/redis/redis.conf ]; then
  sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf -e 's/127.0.0.1/0.0.0.0/' /etc/redis/redis.conf
else
  Print "File does not exists"
  exit 2
fi
StatCheck $?

Print "Starting Redis Database"
systemctl enable redis &>>$LOG_FILE && systemctl start redis &>>$LOG_FILE
StatCheck $?