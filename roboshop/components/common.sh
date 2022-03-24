#!/bin/bash

LOG_FILE=/tmp/roboshop.log
APP_USER=roboshop
StatCheck() {
  if [ $1 -eq 0 ]; then
    echo -e "\e[32mSUCCESS\e[0m"
  else
    echo -e "\e[31mFAILURE\e[0m"
    exit 2
  fi
}

Print() {
  echo -e "\n-----------------------$1---------------------------" &>>$LOG_FILE
  echo -e "\e[36m $1 \e[0m"
}