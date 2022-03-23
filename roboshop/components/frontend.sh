#!/bin/bash

echo -e "\e[36m Installing nginx \e[0m"
yum install nginx -y

echo -e "\e[36m Downloading nginx content \e[0m"
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip"

echo -e "\e[36m Cleanup old nginx content and unarchive new content \e[0m"
rm -rf /usr/share/nginx/html/*
cd /usr/share/nginx/html/
unzip /tmp/frontend.zip
mv frontend-main/* .
mv static/* .
rm -rf frontend-main README.md
mv localhost.conf /etc/nginx/default.d/roboshop.conf

echo -e "\e[36m starting nginx \e[0m"
systemctl restart nginx
systemctl enable nginx


#issues
#1. Installation failed, but my script still continued
#2. Installation failed, because I am not a root user
#3. Installation failed, because I have not validated that I have root previleges


