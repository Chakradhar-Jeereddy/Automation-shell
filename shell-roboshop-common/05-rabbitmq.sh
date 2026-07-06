#!/bin/bash

source ./common.sh
app_name=rabbitmq
check_root

cp $script_dir/rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo &>> $log_file
validate $? "Copying repository file"

dns list installed rabbitmq-server &>> $log_file
if [ $? -ne 0 ]; then
   dnf install rabbitmq-server -y &>> $log_file
   validate $? "Installing rabbitmq"
else
  echo "$Y Rebbitmq already installed ...skipping $N" | tee -a  $log_file
fi

systemctl enable --now rabbitmq-server &>> $log_file
validate $? "Enabling and starting rabbitmq"

app_restart

rabbitmqctl add_user roboshop roboshop123 &>> $log_file
validate $? "Adding roboshop user"

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>> $log_file
validate $? "set all permissions to roboshop user"

print_total_time