#!/bin/bash
#Exit status is a number, $? is a special variable that holds this value
# $? will store the exit status of the last executed command
#Range of exit status is 0-255
# 0 - Global success
# 1-125 -> Some failure from the script/command
# 125+ -> system failure
# example lss - command not found with error 127

