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

# Expressions are important
#1 String test
# Operations : == , != , -z (variable has data or not)


a='abc'
if [ "$a" == "abc" ]; then
  echo -e "\e[36m Both are equal. \e[0m"
fi

if [ "$a" != "abc" ]; then
  echo -e "\e[31m Both are not equal. \e[0m"
fi

