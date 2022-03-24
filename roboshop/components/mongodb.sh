#!/bin/bash
USER_ID=$(id -u)
if [ ${USER_ID} -ne 0 ]; then
  echo -e "\e[36m You need to be a root user to run the script\e[0m."
  exit 1
fi

print() {
  echo -e "\e[36m $1 \e[0m"
}

StatCheck() {
  if [ 0 -eq $1 ]; then
    echo -e "\e[32mSUCCESS\e[0m"
  else
    echo -e "\e[32mFAILURE\e[0m"
    exit 2
  fi
}
print "Cleanup existing  mongodb content"
rm -rf /tmp/mongodb*
StatCheck $?

print "Downloading mongodb repository"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo
StatCheck $?

print "Installing mongodb"
yum install -y mongodb-org
StatCheck $?

#1. Update Listen IP address from 127.0.0.1 to 0.0.0.0 in config file
#
#Config file: `/etc/mongod.conf`

print "Starting mongodb"
systemctl start mongod
systemctl enable mongod
StatCheck $?

print "Downloading schemas of mongodb"
curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip"
cd /tmp

print "Extracting schema files"
unzip /tmp/mongodb.zip
StatCheck $?

print "Loading schemas into the database"
mongo < mongodb-main/catalogue.js
mongo < mongodb-main/users.js
StatCheck $?