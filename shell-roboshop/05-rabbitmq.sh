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



cp $script_dir/rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo &>> $log_file
validate $? "Copying repository file"

dns list installed rabbitmq-server &>> $log_file
if [ $? -ne 0 ]; then
   dnf install rabbitmq-server -y &>> $log_file
   validate $? "Installing rabbitmq"
else
  echo "$Y Rebbitmq already installed ...skipping $N" | tee -a  $log_file
fi


systemctl enable --now rabbitmq-server &>> $log_file
validate $? "Enabling and starting rabbitmq"


systemctl restart rabbitmq-server &>> $log_file
validate $? "Restarting rabbitmq"

rabbitmqctl add_user roboshop roboshop123 &>> $log_file
validate $? "Adding roboshop user"

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>> $log_file
validate $? "set all permissions to roboshop user"