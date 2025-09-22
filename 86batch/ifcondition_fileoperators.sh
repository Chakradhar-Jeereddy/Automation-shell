#!/bin/bash
if [ $(id -u) -ne 0 ]; then 
	echo "please run the script from root user"; 
else echo "success";
fi


if [ -d match  ]; then 
	echo "is a directory"
fi

if [ -f chakra ]; then 
	echo "regular file" 
fi

if [ -r chakra ]; then 
	echo "file is readable"
fi

if [ -w chakra ]; then 
	echo "file is writable" 
fi

if [ -x chakra ]; then 
	echo "file is execuatable"
fi	

if [ -z chakra ]; then 
	echo "file exists"
fi

if [ -s chakra ]; then 
	echo "file is not empty"
fi

# Multiple conditions
a=10
b=30
if [[ a -ge 20 && b -ge 20 ]]; then echo "true"; else echo "false"; fi

if [[ a -ge 20 || b -ge 20 ]]; then echo "true"; else echo "false"; fi
