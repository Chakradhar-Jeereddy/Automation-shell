#!/bin/bash
#To Install Nginx.

echo -e "\e[31mInstall NGINX package\e[0m"
yum install nginx -y


echo -e "\e[33mDownload frontend files\e[0m"
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip"
echo $?
if [$? -ge 0]; then
  echo "download failed"
  exit
fi
echo -e "\e[33mCleanup files\e[0m"
rm -rf /usr/share/nginx/html/
cd /usr/share/nginx/html

echo -e "\e[32mUnarchive files\e[0m"
unzip /tmp/frontend.zip
mv frontend-main/* .
mv static/* .
rm -rf frontend-main README.md
mv localhost.conf /etc/nginx/default.d/roboshop.conf

echo -e "\e[32mStart nginx\e[0m"
systemctl enable nginx
systemctl start nginx

