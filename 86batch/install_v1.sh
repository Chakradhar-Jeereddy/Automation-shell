#!/bin/bash
if [ $(id -u) -ne 0 ]; then echo "Please run the script $(echo $0|cut -d '.' -f1) as root user"; exit 1; fi

dnf install mysql -y
if [ $? -eq 0 ]; then echo "Success"; else echo "Failed"; fi
