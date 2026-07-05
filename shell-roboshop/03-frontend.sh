#!/bin/bash

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

script_dir=$(pwd)
script_name=$( echo $0|cut -d "." -f1 )
log_folder="/var/log/shell-roboshop"
log_file="/$log_folder/${script_name}.log"
mkdir -p $log_folder

userid=$(id -u)

if [ $userid -ne 0 ]; then
   echo -e "$R Please use run the script with root privileges $N"
   exit 1
fi

validate() {
 if [ $1 -ne 0 ]; then
    echo -e "$R $2 ...FAILED  $N" | tee -a  $log_file
    exit 1
 else
    echo -e "$G $2 ....SUCCESS $N"  | tee -a  $log_file
 fi
}


dnf module disable nginx -y &>> $log_file
validate $? "Disabling default module"
dnf module enable nginx:1.24 -y &>> $log_file
validate $? "Enabling version 1.24"
dnf install nginx -y  &>> $log_file
validate $? "Installing nginx"

systemctl enable nginx &>> $log_file
validate $? "Enabling nginx"

systemctl start nginx
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

systemctl restart nginx
validate $? "Restart nginx"