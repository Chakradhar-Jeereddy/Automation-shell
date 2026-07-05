#!/bin/bash

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

mysql_host=mysql.chakra86.store
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


dnf install python3 gcc python3-devel -y  &>> $log_file
validate $? "Installing python"
    

id roboshop  &>> $log_file
if [ $? -ne 0 ]; then
    useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop  &>> $log_file
    validate $? "Adding application user"
else
   echo -e "\e[33m User already exists on the system ...skipping \e[0m" | tee -a $log_file
fi

mkdir -p /app
validate $? "Creating app directory"

curl -L -o  /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment-v3.zip   &>> $log_file
validate $? "Downloading application"

cd /app
validate $? "Switching to App directory"

rm -rf /app/*
validate $? "Removing existing code"

unzip /tmp/payment.zip  &>> $log_file
validate $? "Extracting application code"

pip3 install -r requirements.txt  &>> $log_file
validate $? "Installing dependencies"

cp $script_dir/payment.service /etc/systemd/system/payment.service  &>> $log_file
validate $? "Configuring shipping service"

systemctl daemon-reload

systemctl enable --now payment  &>> $log_file
validate $? "Enabling and starting the service"

systemctl restart payment
validate $? "Restarting payment"