#!/bin/bash

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

mongodb_host=mongodb.chakra86.store
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


dnf module disable nodejs -y &>> $log_file
validate $? "Disabling current module"
dnf module enable nodejs:20 -y &>> $log_file
validate $? "Enabling current module"
dnf install nodejs -y  &>> $log_file
validate $? "Installing nodejs"

id roboshop  &>> $log_file
if [ $? -ne 0 ]; then
    useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop  &>> $log_file
    validate $? "Adding application user"
else
   echo -e "\e[33m User already exists on the system ...skipping \e[0m" | tee -a $log_file
fi

mkdir -p /app
validate $? "Creating app directory"

curl -L -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart-v3.zip  &>> $log_file
validate $? "Downloading application"

cd /app
validate $? "Switching to App directory"

rm -rf /app/*
validate $? "Removing existing code"

unzip /tmp/cart.zip  &>> $log_file
validate $? "Extracting application code"

npm install  &>> $log_file
validate $? "Installing dependencies"

cp $script_dir/cart.service /etc/systemd/system/cart.service
validate $? "Configuring cart service"

systemctl daemon-reload

systemctl enable --now cart  &>> $log_file
validate $? "Enabling and starting the service"

systemctl restart cart
validate $? "Restarted cart"