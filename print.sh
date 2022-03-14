#!/bin/bash

echo Hello World

#Some times echo print errors to grab attention of user it is better to print color

#syntax : echo -e "\e[ColmMESS\e[0m"
# -e is option to enable escape sequence \e
# \e - to enable color
# [COLm - color number
# [0m  - Disable color
# single quotes and double quotes are mandatory, we prefer to use double quotes all the times

# COL NAME   COL CODE
# RED           31
# GREEN         32
# YELLOW        33
# Blue          34
# Magenta       35
# Cyan          36

echo -e "\e[31mRED\e[0m\e32mGREEN\e[0m\e[33mYELLOW\e[0m"

#use bold option

echo -e "\e[1;31mRED\e[1;32mGREEN\e[1;33mYELLOW\e[0m"

# there are two more esc seq generally we use in scripting
# 1. New line \n
# 2. New Tab \t
echo -e "line1\n\line2"
echo -e "Word1\t\tWord2"