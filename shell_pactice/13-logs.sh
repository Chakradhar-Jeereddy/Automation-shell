#!/bin/bash

#Redirections
# > overwrite the file with standard output
# >> append the file with standard output
# 2> overwrite the file with standard error
# 2>> append the file with standard error
# &> overwrite the file with standard output and standard error

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

LOG_FOLDER=/var/log/shell_script
SCRIPT_NAME=$( echo $0| cut -d '.' -f1 )
LOG_FILE=$LOG_FOLDER/$SCRIPT_NAME.log
mkdir -p $LOG_FOLDER

USERID=$(id -u)

if [ $USERUD -ne 0 ]; then
    echo -e "${R}Please run this script with root privileges${N}"
    exit 1 #failure if other then 0
fi

validate() {
    if [ $1 -ne 0 ]; then
        echo -e "${R}Installing $2 is failed${N}"
        exit 1
    else
        echo -e "${G}Installing $2 is Success${N}"
    fi
}

dnf list installed mysql &> $LOG_FILE
#Install if not found
if [ $? -ne 0 ]; then
   dnf install mysql -y
   validate $? mysql
else
    echo -e "Nginx already exist ... $Y SKIPPING $N"
fi

dnf list installed nginx &> $LOG_FILE
#Install if not found
if [ $? -ne 0 ]; then
  dnf install nginx -y
  validate $? nginx
else
    echo -e "Nginx already exist ... $Y SKIPPING $N"
fi