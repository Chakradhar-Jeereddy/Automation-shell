#!/bin/bash

source ./common.sh
app_name=shipping

check_root
app_setup
java_setup
systemd_setup

dnf install mysql -y &>> $log_file
validate $? "Installing mysql"

mysql -h $mysql_host -uroot -pRoboShop@1 -e 'use cities' &>> $log_file
if [ $? -ne 0 ]; then
  mysql -h $mysql_host -uroot -pRoboShop@1 < /app/db/schema.sql  &>> $log_file
  mysql -h $mysql_host -uroot -pRoboShop@1 < /app/db/app-user.sql   &>> $log_file
  mysql -h $mysql_host -uroot -pRoboShop@1 < /app/db/master-data.sql  &>> $log_file
else
  echo -e "Shipping data is already loaded ... $Y SKIPPING $N"
fi

app_restart
print_total_time