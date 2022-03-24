#!/bin/bash

source components/common.sh
rm -rf $LOG_FILE

Print "Downloading setup files for catalogue"
curl -fsSL https://rpm.nodesource.com/setup_lts.x | bash - &>>$LOG_FILE
StatCheck $?

Print "Install nodejs"
yum install nodejs gcc-c++ -y &>>$LOG_FILE
StatCheck $?

id roboshop &>>$LOG_FILE

if [ $? -ne 0 ]; then
  Print "Adding application user"
  useradd ${APP_USER} &>>$LOG_FILE
StatCheck $?
fi

Print "Downloading Catalogue"
curl -f -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>$LOG_FILE
StatCheck $?

cd /home/roboshop

Print "Extracting files"
unzip -o /tmp/catalogue.zip &>>$LOG_FILE && mv catalogue-main catalogue &>>$LOG_FILE && cd /home/roboshop/catalogue &>>$LOG_FILE
npm install &>>$LOG_FILE
StatCheck $?

Print "Updating DNS name in catalogue service file"
sed -e -i 's/MONGO_DNSNAME/172.31.86.185/' /home/$APP_USER/catalogue/systemd.service &>>$LOG_FILE
mv /home/$APP_USER/catalogue/systemd.service /etc/systemd/system/catalogue.service &>>$LOG_FILE
StatCheck $?

Print "change permissions"
chown ${APP_USER}:$APP_USER -R /home/roboshop/ &>>$LOG_FILE
chmod -R 777 /home/roboshop/ &>>$LOG_FILE
StatCheck $?

Print "Start catalogue service"
systemctl daemon-reload &>>$LOG_FILE && systemctl start catalogue &>>$LOG_FILE && systemctl enable catalogue &>>$LOG_FILE
StatCheck $?

Print "Cleanup files"
rm -rf /home/roboshop/*
StatCheck $?