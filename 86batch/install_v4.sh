#!/bin/bash
#Functions for reusability
#Install only when not already installed
#Enabling logging
#Adding redirections 1> is for std output 2> is for error &> for both error and std
#Adding mkdir -p to ignore if exists, elase create dir.


if [ $(id -u) -ne 0 ]; then echo "Please run the script $(echo $0|cut -d '.' -f1) as root user"; exit 1; fi
LOGFILE=/tmp/output.log

validation(){
logfile=/tmp/$1_output.log
dnf list installed $1 &>> $logfile
if [ $? -ne 0 ]; then dnf install $1 -y &>> $logfile ;if [ $? -eq 0 ]; then echo "Installing $1 is Successful"; else echo "Installing $1 is Failed"; fi; else echo "$1 already exists...skipping"; fi
#if [ $? -eq 0 ]; then echo "Installing $1 is Successful"; else echo "Installing $1 is Failed"; fi
}

for i in mysql nginx python3; do validation $i; done
