#!/bin/bash
#Loops are two types
#Loop based done condition/expression, while loop command
#Loop based done inputs, for loop command

i=10
while [ $i -lt 20 ]; do
  echo Iteration is $i
  i=$(($i+1))
done

for firm in SG TCS WIPRO; do
  echo I joined in $firm
done
