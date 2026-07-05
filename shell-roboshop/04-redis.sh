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



dnf module disable redis -y &>> $log_file
validate $? "Disabling default redis module"

dnf module enable redis:7 -y &>> $log_file
validate $? "Enabling redis v7"

dns list installed redis &>> $log_file
if [ $? -ne 0 ]; then
   dnf install redis -y &>> $log_file
   validate $? "Installing redis"
else
  echo "$Y Redis already installed ...skipping $N" | tee -a  $log_file
fi


sed -i -e 's/127.0.0.1/0.0.0.0/' -e '/protected-mode/ c protected-mode no' /etc/redis/redis.conf
validate $? "Enabling external connections to redis"

systemctl enable --now redis &>> $log_file
validate $? "Enabling and starting Redis"


systemctl restart redis &>> $log_file
validate $? "Restarting Redis"