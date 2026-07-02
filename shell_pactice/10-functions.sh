#!/bin/bash
userid=$(id -u)

if [ $userid -ne 0 ]; then
    echo "Please run this script with root privileges"
    exit 1 #failure if other then 0
fi

validate() {
    if [ $1 -ne 0 ]; then
        echo "Installing $2 is failed"
        exit 1
    else
        echo "Installing $2 is Success"
    fi
}

dnf install mysql -y
validate $? mysql

dnf install nginx -y
validate $? nginx