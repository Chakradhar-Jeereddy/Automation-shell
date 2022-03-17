#!/bin/bash

read -p "Enter your name: " name
echo "Your Name =$name"

#Special variables
# $0-$n , $* / $@,$#
echo Script name = $0
echo first argument = $1
echo All arguments = $*
echo Number of arguments = $#