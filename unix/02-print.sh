#!/bin/bash

echo Hello World
# Color codes
#Red      31
#Green    32
#Yello    33
#Blue     34
#Megenta  35
#Cyan     36

#Syntax : echo -e "\e[COLmhello\e[0m"
# - e is to enable esc seq, without -e \ is considered as text
#"" double quotes are mandatory for colors to work, we can use single quotes also
# \e[COLm -< this will enable color, COL is one of the color codes
# \e[0m -> this is to disable color

echo -e "\e[31mText\e[0m in Red Color"
echo "one more line"

echo -e "Line1\n\nLine2"
echo -e "Word1\t\tWord2"
