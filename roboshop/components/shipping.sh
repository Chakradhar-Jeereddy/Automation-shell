#!/bin/bash

source components/common.sh

Print "Install Maven"
yum install maven -y &>>$LOG_FILE
StatCheck $?

APP_SETUP

Print "Extracting Jar file"
cd shipping && mvn clean package >>$LOG_FILE && mv target/shipping-1.0.jar shipping.jar >>$LOG_FILE

COMPONENT=shipping

SERVICE_SETUP