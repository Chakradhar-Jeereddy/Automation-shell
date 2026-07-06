#!/bin/bash

source ./common.sh

cp $script_dir/mongo.repo /etc/yum.repos.d/mongo.repo
validate $? "Adding mongodb repo"

dnf list installed mongodb-org &>>  $log_file
if [ $? -ne 0 ]; then
 dnf install mongodb-org -y &>>  $log_file
 validate $? "Installing mongodb"
else
 echo -e "$Y mongodb already installed on the server ....skipping $N" | tee -a  $log_file
fi

systemctl enable --now mongod &>>  $log_file
validate $? "Starting mongodb"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
validate $? "Allowing remote connections to MongoDB"

systemctl restart mongod
validate $? "Restart mongodb"