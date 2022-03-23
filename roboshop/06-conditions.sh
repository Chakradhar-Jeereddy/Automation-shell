#!/bin/bash

# case and if conditional commands , if command is widely used because it has more options than case
# command

#IF condition
#IF is found in three forms

#Simple if
# if [ expression ]
#then
# commands
#fi

if [ 1 -eq 1 ]; then
  echo -e "\e[36m hello \e[0m"
fi

if [ 1 -eq 1 ]
then
  echo -e "\e[36m Another form of if condition \e[0m"
fi