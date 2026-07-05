#!/bin/bash

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

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





cp mongo-repo /etc/yum.repos.d/mongo.repo
validate $? "Adding mongodb repo"

dnf list installed mongodb-org &>>  $log_file
if [ $? -ne 0 ]; then
 dnf install mongodb-org -y &>>  $log_file
 validate $? "Installing mongodb"
else
 echo -e "$Y mongodb already installed on the server ....skipping $N" | tee -a  $log_file
fi

systemctl enable --now mongod &>>  $log_file
validate $? "Starting mongodb"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
validate $? "Allowing remote connections to MongoDB"

systemctl restart mongod
validate $? "Restart mongodb"