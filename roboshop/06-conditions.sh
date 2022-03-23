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

# if else

#if [ expression ]; then
#commands
#else
#commands
#fi

#else if to check multiple expressions but limitation is if expression 1 is true
#the command will exit, it will not check the next expression

#if [ expression1 ]; then
#command
#elif [ expression2 ]; then
#command
#else
#command

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
#2 Number tests
#operators -ge,-gt,lt,le,ne
#File test operators
# -e to check if file exists or not
#https://tldp.org/LDP/abs/html/fto.html


a='abcd'

if [ "$a" == "abc" ]; then
  echo -e "\e[36m Both are equal. \e[0m"
fi

if [ "$a" != "abc" ]; then
  echo -e "\e[31m Both are not equal. \e[0m"
fi

if [ -z $b ]; then
  echo -e "\e[36m Variable b is empty \e[0m"
fi

#Double quotes in expression of if condition is mandatory


#Example of IF else

if [ "$a" == "abc" ]; then
  echo -e "\e[36m Both are equal. \e[0m"
else
  echo -e "\e[31m Both are not equal. \e[0m"
fi

#Example of elif

if [ "$a" == "abc" ]; then
  echo -e "\e[36m equal. \e[0m"
elif [ "$a" != "abc" ]; then
  echo -e "\e[31m not equal. \e[0m"
else
  echo hello
fi