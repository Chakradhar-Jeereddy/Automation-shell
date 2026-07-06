#!/bin/bash

source ./common.sh
app_name=mysqld

check_root

dns list installed mysql-server &>> $log_file
if [ $? -ne 0 ]; then
   dnf install mysql-server -y &>> $log_file
   validate $? "Installing mysql"
else
  echo "$Y Mysql already installed ...skipping $N" | tee -a  $log_file
fi

systemctl enable --now mysqld &>> $log_file
validate $? "Enabling and starting mysqld"

app_restart

mysql_secure_installation --set-root-pass RoboShop@1 &>> $log_file
validate $? "Update detault password"

print_total_time