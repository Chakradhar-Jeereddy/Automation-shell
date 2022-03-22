#!/bin/bash

read -p 'Enter you name: ' name
echo "You name = $name"

echo "what is your name?"
read name
echo "My name is $name"
read remark
echo "$name , that is good name"

#We can not use the "Read" in automation as it is prompting for input
#Special variables are used for input
# $0-n, $*, . $@, $#
echo Script name = $0
echo First argument = $1
echo All arguments = $*
echo Number of Arguments = $#