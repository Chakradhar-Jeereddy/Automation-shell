#!/bin/bash

if [ $(id -u) -ne 0 ]; then echo "Please run the script $(echo $0|cut -d '.' -f1) as root user"; exit 1; fi

# Functions for reusability
# Install only when not already installed


validation(){
dnf list installed $1
if [ $? -ne 0 ]; then dnf install $1 -y;if [ $? -eq 0 ]; then echo "Installing $1 is Successful"; else echo "Installing $1 is Failed"; fi; else echo "$1 already exists...skippig"; fi
#if [ $? -eq 0 ]; then echo "Installing $1 is Successful"; else echo "Installing $1 is Failed"; fi
}

for i in mysql nginx python3; do validation $i; done
