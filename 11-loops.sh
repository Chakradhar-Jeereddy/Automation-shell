#!/bin/bash
#Loops are two types
#Loop based done condition/expression, while loop command
#Loop based done inputs, for loop command

i=10
while [ $i -gt 0 ]; do
  echo Iteration is $i
  i=$(($i-1))
done

for name in chakra ravi rama; do
  echo My name is $name
done