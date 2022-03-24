#!/bin/bash

#Redis is used for in-memory data storage and allows users to access the data over API.
#**Manual Installation of Redis.**
#1. Install Redis.
#
#```bash
#
## curl -L https://raw.githubusercontent.com/roboshop-devops-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo
## yum install redis -y
#```
#
#2. Update the BindIP from `127.0.0.1` to `0.0.0.0` in config file `/etc/redis.conf` & `/etc/redis/redis.conf`
#
#3. Start Redis Database
source components/common.sh

Print "Configuring repos"
curl -L https://raw.githubusercontent.com/roboshop-devops-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo &>>$LOG_FILE
StatCheck $?

Print "Installing Redis"
yum install redis -y &>>$LOG_FILE
StatCheck $?

Print "Service setup"
sed -i -e '/127.0.0.1/0.0.0.0/' /etc/redis.conf \
       -e '/127.0.0.1/0.0.0.0/' /etc/redis/redis.conf
StatCheck $?

Print "Starting Redis Database"
systemctl enable redis &>>$LOG_FILE && systemctl start redis &>>$LOG_FILE
StatCheck $?