#!/bin/bash

source ./common.sh
app_name=redis
check_root

dnf module disable redis -y &>> $log_file
validate $? "Disabling default redis module"

dnf module enable redis:7 -y &>> $log_file
validate $? "Enabling redis v7"

dns list installed redis &>> $log_file
if [ $? -ne 0 ]; then
   dnf install redis -y &>> $log_file
   validate $? "Installing redis"
else
  echo "$Y Redis already installed ...skipping $N" | tee -a  $log_file
fi


sed -i -e 's/127.0.0.1/0.0.0.0/' -e '/protected-mode/ c protected-mode no' /etc/redis/redis.conf
validate $? "Enabling external connections to redis"

systemctl enable --now redis &>> $log_file
validate $? "Enabling and starting Redis"

app_restart
print_total_time