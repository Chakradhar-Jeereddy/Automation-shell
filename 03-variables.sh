#!/bin/bash

#Variable
#{},(command),((expression)) understand the usage
#Assigning a name to set of data that is called variable
#In bash shell we declare variable as VAR=DATA
#In bash shell we access the variables as $VAR or ${var}
#Special characters not allowed and also name can not start with number

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

Date=$(date +%F)
echo Todays data is $(Date)
echo a is $((a*2))

#Variable can store array using () with tab separation and index starts from zero
#Scalar
d = 100
echo $d
#Array
c=(10 20 "small large")
echo First value of array = ${c[0]}
echo Thrid value of array = ${c[2]}
echo All values of arry   = ${c[*]}

#By default variable is readwrite, we can change it to readonly
#to send values for variables in program we use environment variables, to be accessible from scripts

echo Training = ${TRAINING}
