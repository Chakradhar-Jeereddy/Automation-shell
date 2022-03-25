#!/bin/bash
source components/common.sh

Print "Configuring repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>>${LOG_FILE}
StatCheck $?

Print "Installing Erlang and RabbitMQ"
yum install https://github.com/rabbitmq/erlang-rpm/releases/download/v23.2.6/erlang-23.2.6-1.el7.x86_64.rpm rabbitmq-server -y &>>${LOG_FILE}
StatCheck $?

Print "Starting RabbitMQ"
systemctl enable rabbitmq-server && systemctl start rabbitmq-server
StatCheck $?

rabbitmqctl list_users | grep roboshop &>>${LOG_FILE}
if [ $? -ne 0 ]; then
  Print "Create Application User"
  rabbitmqctl add_user roboshop roboshop123 &>>${LOG_FILE}
  StatCheck $?
fi

Print "Configure Application User"
rabbitmqctl set_user_tags roboshop administrator &>>${LOG_FILE} && rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>${LOG_FILE}
StatCheck $?