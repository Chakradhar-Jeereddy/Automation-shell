#!/bin/bash

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

USER_ID=$(id -u)
if [ "$USER_ID" -ne 0 ]; then
  echo -e "\e[36m You should run the script as sudo or root user. \e[0m"
  exit 1
fi

LOG_FILE=/tmp/roboshop.log
rm -rf $LOG_FILE

APP_USER=roboshop


STAT() {
  if [ ${1} -eq 0 ]; then
    echo -e "\e[32mSUCCESS\e[0m"
  else
    echo -e "\e[31mFAILURE\e[0m"
    return 1
  fi
}

APP_USER(){
  id ${APP_USER} &>>${LOG_FILE}
  if [ $? -ne 0 ]; then
  Print "Adding application user"
  useradd ${APP_USER} &>>${LOG_FILE}
  StatCheck $?
  fi
  Print "Downloading App Component"
  curl -f -s -L -o /tmp/${COMPONENT}.zip "https://github.com/roboshop-devops-project/{COMPONENT}/archive/main.zip" &>>${LOG_FILE}
  StatCheck $?
  Print "Cleanup files"
  rm -rf /home/roboshop/{COMPONENT} &>>${LOG_FILE}
  StatCheck $?
  Print "Extracting APP Content"
  cd /home/${APP_USER} &>>${LOG_FILE} && unzip -o /tmp/catalogue.zip &>>$LOG_FILE && mv catalogue-main catalogue &>>$LOG_FILE
  npm install &>>$LOG_FILE
  StatCheck $?
}

SERVICE_SETUP() {
  Print "Fix App user permissions"
  chown -R ${APP_USER}:${APP_UER} /home/${APP_USER}
  StatCheck $?
  Print "Setup systemD file"
  sed -i  -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' \
          -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' \
          -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal/' \
          -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' \
          -e 's/CARTENDPOINT/cart.roboshop.internal/' \
          -e 's/DBHOST/mysql.roboshop.internal/' \
          -e 's/CARTHOST/cart.roboshop.internal/' \
          -e 's/USERHOST/user.roboshop.internal/' \
          -e 's/AMQPHOST/rabbitmq.roboshop.internal/' \
          /home/roboshop/${COMPONENT}/systemd.service &>>${LOG_FILE} && mv /home/roboshop/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service  &>>${LOG_FILE}
  StatCheck $?
  Print "Restart $(COMPONENT) SERVICE"
  systemctl daemon-reload  &>>$LOG_FILE && systemctl restart ${COMPONENT} &>>$LOG_FILE && systemctl enable ${COMPONENT} &>>$LOG_FILE
  StatCheck $?
}

NODEJS() {
  Print "Configure Yum repos"
  curl -fsSL https://rpm.nodesource.com/setup_lts.x | bash - &>>${LOG_FILE}
  StatCheck $?

  Print "Install NodeJS"
  yum install nodejs gcc-c++ -y &>>${LOG_FILE}
  StatCheck $?

  APP_SETUP

  Print "Install App Dependencies"
  cd /home/${APP_USER}/${COMPONENT} &>>${LOG_FILE} && npm install &>>${LOG_FILE}
  StatCheck $?

  SERVICE_SETUP

}
