#!/bin/bash

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

script_dir=$PWD
script_name=$( echo $0|cut -d "." -f1 )
START_TIME=$(date +%s)
log_folder="/var/log/shell-roboshop"
log_file="/$log_folder/${script_name}.log"
mongodb_host=mongodb.chakra86.store
mysql_host=mysql.chakra86.store

mkdir -p $log_folder
echo "Script started executed at: $(date)" | tee -a $log_file

check_root(){
 userid=$(id -u)
 if [ $userid -ne 0 ]; then
   echo -e "$R Please use run the script with root privileges $N"
   exit 1
 fi
}

validate() {
 if [ $1 -ne 0 ]; then
    echo -e "$R $2 ...FAILED  $N" | tee -a  $log_file
    exit 1
 else
    echo -e "$G $2 ....SUCCESS $N"  | tee -a  $log_file
 fi
}

app_setup(){ 
 id roboshop  &>> $log_file
  if [ $? -ne 0 ]; then
    useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop  &>> $log_file
    validate $? "Adding application user"
  else
    echo -e "\e[33m User already exists on the system ...skipping \e[0m" | tee -a $log_file
  fi
  mkdir -p /app
  validate $? "Creating app directory"

  curl -o /tmp/${app_name}.zip https://roboshop-artifacts.s3.amazonaws.com/${app_name}-v3.zip  &>> $log_file
  validate $? "Downloading application"

  cd /app
  validate $? "Switching to App directory"

  rm -rf /app/*
  validate $? "Removing existing code"

  unzip /tmp/${app_name}.zip  &>> $log_file
  validate $? "Extracting application code"
}

setup_nodejs(){
    dnf module disable nodejs -y &>> $log_file
    validate $? "Disabling current module"
    dnf module enable nodejs:20 -y &>> $log_file
    validate $? "Enabling current module"
    dnf install nodejs -y  &>> $log_file
    validate $? "Installing nodejs"
    npm install  &>> $log_file
    validate $? "Installing dependencies"
}

java_setup(){
    dnf list installed maven &>> $log_file
    if [ $? -ne 0 ]; then
       dnf install maven -y  &>> $log_file
       validate $? "Installing maven"
    else
       echo -e "$Y Maven already installed ... skipping $N"
    fi
    mvn clean package  &>> $log_file
    validate $? "Installing dependencies"
    mv target/shipping-1.0.jar shipping.jar  &>> $log_file
    validate $? "Renaming jar file to shipping.jar"
}

python_setup(){
    dnf install python36 gcc python3-devel -y &>> $log_file
    validate $? "Installing python3"
    pip3 install -r requirements.txt  &>> $log_file
    validate $? "Installing dependencies"
}

nginx_setup(){
    dnf module disable nginx -y &>> $log_file
    validate $? "Disabling default module"
    dnf module enable nginx:1.24 -y &>> $log_file
    validate $? "Enabling version 1.24"
    dnf install nginx -y  &>> $log_file
    validate $? "Installing nginx"
}

systemd_setup(){
    cp $script_dir/${app_name}-service /etc/systemd/system/${app_name}.service
    validate $? "Configuring ${app_name} service"
    systemctl daemon-reload
    systemctl enable --now ${app_name}  &>> $log_file
    validate $? "Enabling and starting the service"
}

app_restart(){
  systemctl restart ${app_name}  &>> $log_file
  validate $? "Restarted ${app_name}"
}

print_total_time(){
    END_TIME=$(date +%s)
    TOTAL_TIME=$(( $END_TIME - $START_TIME ))
    echo -e "Script executed in: $Y $TOTAL_TIME Seconds $N"
}