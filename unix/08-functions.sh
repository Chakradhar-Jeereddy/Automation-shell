#!/bin/bash

# Variable : If we assign a name to set of data that is variable
# Function : If we assign a name to set of commands that is called function

#Syntax
#function_name() {
#command1
#command2
#}

#To access a function we use
#funtion_name

#Declare a function

Print_message() {
  echo Hello
  echo Good morning
  echo Welcome to ${1} Training
  echo "First argument in function = $1"
  a=20
  echo "Value of a = $a"
  b=20
}
STAT1() {
   echo hello
   return 1
   echo bye
}

STAT() {
  if [ ${1} -eq 0 ]; then
    echo -e "\e[32mSUCCESS\e[0m"
  else
    echo -e "\e[31mFAILURE\e[0m"
    return 1
  fi
}

#Main program
a=10
echo $a
Print_message devops
echo "First argument in main script = $1"
echo "Value of b = $b"
STAT1
echo "Exit status of function STAT = $?"




#Note, Function should always be declared first and than you can call the function later in the code.
# Functions will have it own set of variables like return
# Variables declared in main program can be overwritten on function and vise versa.
# Functions is a command, it will have exit status as well.
