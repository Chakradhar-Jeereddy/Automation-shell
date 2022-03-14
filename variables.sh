#!/bin/bash
a=100
b=devops

echo ${a}times
echo $b

#{} are needed if variable is combined with other variables without space

DATE=2202-03-12
echo Today date is $DATE

DATE=$(date +%F)
echo Today date is $DATE

x=10
y=20
ADD=$(($x+$y))
echo ADD = $ADD