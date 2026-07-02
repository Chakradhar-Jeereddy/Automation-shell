#!/bin/bash

USERID=$(id -u)

if [ $USERID -ne 0 ]; then
    echo "Please run this script with root privileges"
    exit 1 #failure if other then 0
fi

dnf install mysql -y
if [ $? -ne 0 ]; then
    echo "MySQL installation failed"
    exit 1
else
    echo "Installing MySQL is Success"
fi