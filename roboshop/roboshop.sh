#!/bin/bash

if [ ! -e components/$1.sh ]; then
  echo Component does not exists
  exit
fi
bash components/$1.sh

#we need to handle the errors manually
#roboshop.sh xvz