#!/bin/bash
a=100
b=devops

echo ${a}times
echo $b

#{} are needed if variable is combined with other variables without space

DATE=2202-03-12
echo Today date is $DATE

#()command substitution

DATE=$(date +%F)
echo Today date is $DATE

#(()) - arthimetic substitution
x=10
y=20
ADD=$(($x+$y))
echo ADD = $ADD

c=(19 small big hello)
the value of arrays is ${c[*]}
the fist value of array is ${c[0]}