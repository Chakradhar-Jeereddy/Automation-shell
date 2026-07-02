#!/bin/bash
#umbrella sunglasses sweater

#if raining is true, then wear umbrella and sunglasses. If raining is false, 
#then wear sweater.

number=$1

if [ $number -lt 10 ]; then
   echo "Given number is less than 10"
elif [ $number -eq 10 ]; then
    echo "Given number is equal to 10"
else
   echo "Geven number is greater than 10"
fi

# -gt
# -lt
# -eq
# -ne