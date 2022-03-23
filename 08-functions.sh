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
STAT() {
  echo hello
  return 1
  echo bye
}

#Main program
a=10
Print_message devops
echo "First argument in main scrip = $1"
echo "Value of b = $b"
STAT
echo "Exit status of function STAT = $?"



#Note, Function should always be declared first and than you can call the function later in the code.
# Functions will have it own set of variables like return
# Variables declared in main program can be overwritten on function and vise versa.
# Functions is a command, it will have exit status as well.
