#!/bin/bash
#
#1> is to write output to file
#1>> is to append output to file
#2> is to write errors to file
#2>> is to append errors to file
# &> or &>> is to write/append both output and error to file
# >>/dell/null If we do not need any kind of output or error to a file for future reference we try to
#nullify the output with the help of /dev/null file
#
#Concept of alias
#alias gp='git pull &>>/dev/null
#TO COMMENT ALL LINES IN INTELIJ USE CONTROL + /