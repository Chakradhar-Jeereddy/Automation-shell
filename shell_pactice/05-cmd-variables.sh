#!/bin/bash
#command is ()

#date +%Y-%m-%d-%H-%M-%S
#date +%F
DATE=$(date +%F)
START_TIME=$(date +s)
sleep 10
END_TIME=$(date +s)

#For calucation use $((expression)) syntax. Here expression is the mathematical expression to be evaluated.
TOTAL_TIME=$(($END_TIME - $START_TIME))
echo "Script executed in: $TOTAL_TIME seconds"