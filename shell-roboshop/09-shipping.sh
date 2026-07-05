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

dnf list installed maven &>> $log_file
if [ $? -ne 0 ]; then
  dnf install maven -y  &>> $log_file
  validate $? "Installing maven"
else
 echo -e "$Y Maven already installed ... skipping $N"
fi

id roboshop  &>> $log_file
if [ $? -ne 0 ]; then
    useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop  &>> $log_file
    validate $? "Adding application user"
else
   echo -e "\e[33m User already exists on the system ...skipping \e[0m" | tee -a $log_file
fi

mkdir -p /app
validate $? "Creating app directory"

curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping-v3.zip  &>> $log_file
validate $? "Downloading application"

cd /app
validate $? "Switching to App directory"

rm -rf /app/*
validate $? "Removing existing code"

unzip /tmp/shipping.zip  &>> $log_file
validate $? "Extracting application code"

mvn clean package  &>> $log_file
validate $? "Installing dependencies"

mv target/shipping-1.0.jar shipping.jar  &>> $log_file
validate $? "Move jar file to app directoty"

cp $script_dir/shipping.service /etc/systemd/system/shipping.service  &>> $log_file
validate $? "Configuring shipping service"

systemctl daemon-reload

systemctl enable --now shipping  &>> $log_file
validate $? "Enabling and starting the service"

dnf install mysql -y &>> $log_file
validate $? "Installing mysql"

mysql -h $mysql_host -uroot -pRoboShop@1 -e 'use cities' &>> $log_file
if [ $? -ne 0 ]; then
  mysql -h $mysql_host -uroot -pRoboShop@1 < /app/db/schema.sql  &>> $log_file
  mysql -h $mysql_host -uroot -pRoboShop@1 < /app/db/app-user.sql   &>> $log_file
  mysql -h $mysql_host -uroot -pRoboShop@1 < /app/db/master-data.sql  &>> $log_file
else
  echo -e "Shipping data is already loaded ... $Y SKIPPING $N"
fi

systemctl restart shipping
validate $? "Restarting shipping"