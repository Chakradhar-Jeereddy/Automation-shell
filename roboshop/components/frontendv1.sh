#!/bin/bash

#issues
#1. Installation failed, but my script still continued
#2. Installation failed, because I am not a root user
#3. Installation failed, because I have not validated that I have root privileges
#4. The information I would like to provide if success or failure
#example change the zip to zp in curl command and run the script.
#5 Any step failed, but my script continued
#6 Repetitive code is there, in order to deal with this I need to use functions/methods

STAT() {
  if [ ${1} -eq 0 ]; then
    echo -e "\e[32mSUCCESS\e[0m"
  else
    echo -e "\e[31mFAILURE\e[0m"
    return 1
  fi
}

StatCheck() {
  if [ $1 -eq 0 ]; then
    echo -e "\e[32mSUCCESS\e[0m"
  else
    echo -e "\e[31mFAILURE\e[0m"
    exit 2
  fi
}

Print() {
  echo -e "\e[36m $1 \e[0m"
}

USER_ID=$(id -u)
if [ "$USER_ID" -ne 0 ]; then
  echo -e "\e[36m You should run the script as sudo or root user. \e[0m"
  exit 1
fi

Print "Installing nginx"
yum install nginx -y
StatCheck $?

Print "Downloading nginx content"
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip"
StatCheck $?

Print "Cleanup old nginx content"
rm -rf /usr/share/nginx/html/*
StatCheck $?

cd /usr/share/nginx/html/

Print "Extracting Archive"
#Test && => echo 1 && echo 2 (if first command is ok, it goes to next command)
#Test || =< echo 1 || echo 2 (if first command is ok, the second will not get executed)
unzip /tmp/frontend.zip && mv frontend-main/* . && mv static/* .
StatCheck $?

Print "Update roboshop configuration"
mv localhost.conf /etc/nginx/default.d/roboshop.conf
StatCheck $?

Print "starting nginx"
systemctl restart nginx && systemctl enable nginx
StatCheck $?





