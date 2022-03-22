#!/bin/bash

#Below command consider $1 as special character (fist argument)
echo Apple cost is $100
#TO disable special character using single quotes
echo 'Apple cost is $100'
#Double quotes will not disable special character
echo "Apple cost is $100"
#Uase back word slash \ to disable special character inside double quotes
echo "Apple cost is \$100"
Training = Devops
echo 'Im in ${Training} training'
echo "Im in ${Training} training"