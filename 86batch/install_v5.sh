#!/bin/bash
#Functions for reusability
#Install only when not already installed
#Enabling logging
#Adding redirections 1> is for std output 2> is for error &> for both error and std
#Adding mkdir -p to ignore if exists, elase create dir.
#Adding color codes (31-Red, 32-green,34-blue,0-reset) e\[<code>m
#Adding tee command to write the std output to console and logfile, use -a option to append
#Logging start time of the script execution.

G=$(echo -e "\e[32m")
R=$(echo -e "\e[31m")
B=$(echo -e "\e[34m")
N=$(echo -e "\e[0m")


if [ $(id -u) -ne 0 ]; then echo "$R Please run the script $(echo $0|cut -d '.' -f1) as root user $N" | tee -a $logfile; exit 1; fi

validation(){
logfile=/tmp/$1_output.log
echo "${1}_Script executed at $(date)" |tee -a $logfile
dnf list installed $1 &>> $logfile
if [ $? -ne 0 ]; then dnf install $1 -y &>> $logfile ;if [ $? -eq 0 ]; then echo "$G Installing $1 is Successful $N" |tee -a $logfile; else echo "$R Installing $1 is Failed $N" |tee -a $logfile; fi; else echo "$B $1 already exists...skipping $N" |tee -a $logfile; fi
#if [ $? -eq 0 ]; then echo "Installing $1 is Successful"; else echo "Installing $1 is Failed"; fi
}

for i in mysql nginx pthon3; do validation $i; done
