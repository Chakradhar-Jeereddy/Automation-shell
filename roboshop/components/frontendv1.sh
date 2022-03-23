#!/bin/bash

#issues
#1. Installation failed, but my script still continued
#2. Installation failed, because I am not a root user
#3. Installation failed, because I have not validated that I have root privileges
#4. The information I would like to provide if success or failure
#example change the zip to zp in curl command and run the script.
#5 Any step failed, but my script continued
#6 Repetitive code is there, in order to deal with this I need to use functions/methods

USER_ID=$(id -u)
if [ "$USER_ID" -ne 0 ]; then
  echo -e "\e[36m You should run the script as sudo or root user. \e[0m"
  exit 1
fi

STAT() {
  if [ ${1} -eq 0 ]; then
    echo -e "\e[32mSUCCESS\e[0m"
  else
    echo -e "\e[31mFAILURE\e[0m"
    return 1
  fi
}

echo -e "\e[36m Installing nginx \e[0m"
yum install nginx -y
STAT $?

echo -e "\e[36m Downloading nginx content \e[0m"
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip"
STAT $?

echo -e "\e[36m Cleanup old nginx content and unarchive new content \e[0m"
rm -rf /usr/share/nginx/html/*
cd /usr/share/nginx/html/
unzip /tmp/frontend.zip
mv frontend-main/* .
mv static/* .
rm -rf frontend-main README.md
mv localhost.conf /etc/nginx/default.d/roboshop.conf
STAT $?


echo -e "\e[36m starting nginx \e[0m"
systemctl restart nginx
systemctl enable nginx
STAT $?





