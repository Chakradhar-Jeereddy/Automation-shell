#!/bin/bash
a=100
b=devops

echo ${a}times
echo $b

#{} are needed if variable is combined with other variables without space
DATE=$(date +%F)
echo Today date is $DATE