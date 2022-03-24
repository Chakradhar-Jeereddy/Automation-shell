#!/bin/bash

#issues
#1. Installation failed, but my script still continued
#2. Installation failed, because I am not a root user
#3. Installation failed, because I have not validated that I have root privileges
#4. The information I would like to provide if success or failure
#example change the zip to zp in curl command and run the script.
#5 Any step failed, but my script continued
#6 Repetitive code is there, in order to deal with this I need to use functions/methods
source components/common.sh

Print "Installing nginx"
yum install nginx -y &>>$LOG_FILE
StatCheck $?

Print "Downloading nginx content"
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip"  >> $LOG_FILE
StatCheck $?

Print "Cleanup old nginx content"
rm -rf /usr/share/nginx/html/*  &>>$LOG_FILE
StatCheck $?

Print "Cleanup old Nginx content"
rm -rf /usr/share/nginx/html/* &>>$LOG_FILE
StatCheck $?

cd /usr/share/nginx/html/

#Test && => echo 1 && echo 2 (if first command is ok, it goes to next command)
#Test || =< echo 1 || echo 2 (if first command is ok, the second will not get executed)

Print "Extracting Archive"
unzip -o /tmp/frontend.zip &>>$LOG_FILE&& mv frontend-main/* . &>>$LOG_FILE && mv static/* . &>>$LOG_FILE
StatCheck $?

Print "Update roboshop configuration"
mv localhost.conf /etc/nginx/default.d/roboshop.conf  &>>$LOG_FILE
sed -i -e '/catalogue/s/localhost/172.31.89.102/' /etc/nginx/default.d/roboshop.conf
sed -i -e '/user/s/localhost/172.31.80.113/' /etc/nginx/default.d/roboshop.conf
#sed -i -e '/cart/s/localhost/172.31.80.113/' /etc/nginx/default.d/roboshop.conf
#for component in catalogue user cart shipment payment; do
#  echo "Updating ${component} in configuration"
#  sed -i -e "/catalogue/s/localhost/catalogue.roboshop.internal/"  /etc/nginx/default.d/roboshop.conf
#  StatCheck $?
#done
StatCheck $?

Print "starting nginx"
systemctl restart nginx && systemctl enable nginx  &>>$LOG_FILE
StatCheck $?





