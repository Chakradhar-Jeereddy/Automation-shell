#!/bin/bash

source ./common.sh
app_name=catalogue

check_root
app_setup
nodejs_setup
systemd_setup

cp $script_dir/mongo.repo /etc/yum.repos.d/mongo.repo
validate $? "Copy mongo repo"

dnf install mongodb-mongosh -y &>>$log_file
validate $? "Install MongoDB client"


INDEX=$(mongosh $mongodb_host --quiet --eval "db.getMongo().getDBNames().indexOf('catalogue')")

if [ $INDEX -le 0 ]; then
    mongosh --host $mongodb_host </app/db/master-data.js &>>$log_file
    validate $? "Load catalogue products"
else
    echo -e "Catalogue products already loaded ... $Y SKIPPING $N"
fi

app_restart
print_total_time