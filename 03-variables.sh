#!/bin/bash

#Variable
#{},(command),((expression)) understand the usage
#Assigning a name to set of data that is called variable
#In bash shell we declare variable as VAR=DATA
#In bash shell we access the variables as $VAR or ${var}

a=100
b=devops

#{} are needed if variable is combined with other words without spaces
echo ${a}times
echo $b Training

DATE=2022-03-22
echo Today data is $DATE

#As above all the time we will not hardcode the values of variables and we need the data
#dynamically, in that case we use command or arithmetic substitution.
#var = $(command), the command output will be stored in variable

#var=$((expresssion)), this is arithmetic subst, output goes to variable. example is $((2+3))

Date=date
echo Todays data is $(Date)
echo a is $((a*2))