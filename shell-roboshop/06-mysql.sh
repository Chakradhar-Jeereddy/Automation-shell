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


dns list installed mysql-server &>> $log_file
if [ $? -ne 0 ]; then
   dnf install mysql-server -y &>> $log_file
   validate $? "Installing mysql"
else
  echo "$Y Mysql already installed ...skipping $N" | tee -a  $log_file
fi


systemctl enable --now mysqld &>> $log_file
validate $? "Enabling and starting mysqld"


systemctl restart mysqld &>> $log_file
validate $? "Restarting rabbitmq"


mysql_secure_installation --set-root-pass RoboShop@1 &>> $log_file
validate $? "Update detault password"