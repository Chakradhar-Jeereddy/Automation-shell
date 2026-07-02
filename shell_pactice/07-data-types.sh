#!/bin/bash

# Everything in shell is treated as a string. There are no data types in shell scripting.
Number1=100
Number2=200
NAME=DevOps

SUM=$(($Number1 + $Number2)) # This will perform arithmetic addition
echo "The sum of $Number1 and $Number2 is: $SUM"

SUM=$(($Number1 + $Number2 + $NAME)) # This will perform string concatenation
echo "The sum of $Number1 and $Number2 and $NAME is: $SUM"

#Array in shell scripting
#Index starts from 0.
LEADERS=("MODI" "TRUMP" "PUTIN")

echo "All leaders are: ${LEADERS[@]}"
echo "First leader is: ${LEADERS[0]}"
echo "Second leader is: ${LEADERS[1]}"
echo "Third leader is: ${LEADERS[2]}"