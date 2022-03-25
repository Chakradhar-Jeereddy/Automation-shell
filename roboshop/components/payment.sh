#!/bin/bash

source components/common.sh
COMPONENT=payment

Print "Installing Python 3"
yum install python36 gcc python3-devel -y $>>${LOG_FILE}
StatCheck $?

APP_SETUP

Print "Install dependencies"
cd /home/roboshop/payment && pip3 install -r requirements.txt

SERVICE_SETUP