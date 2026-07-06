#!/bin/bash
source ./common.sh
app_name=nginx

check_root
nginx_setup

systemctl enable $app_name &>> $log_file
validate $? "Enabling nginx"

systemctl start $app_name
validate $? "Starting nginx"

rm -rf /usr/share/nginx/html/*
validate $? "Removing default content of nginx"

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip &>> $log_file
validate $? "Downloading frontend content"

cd /usr/share/nginx/html
validate $? "Switching directory"

unzip /tmp/frontend.zip
validate $? "Extracting frontend content"

cp $script_dir/nginx.conf /etc/nginx/nginx.conf
validate $? "Copying nginx configuration"

app_restart
print_total_time