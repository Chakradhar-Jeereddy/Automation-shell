#!/bin/bash

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

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

dnf list installed mysql
#Install if not found
if [ $? -ne 0 ]; then
   dnf install mysql -y
   validate $? mysql
fi

dnf list installed nginx
#Install if not found
if [ $? -ne 0 ]; then
  dnf install nginx -y
  validate $? nginx
fi