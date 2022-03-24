#!/bin/bash
#VI editor require manual intervention to edit the file, not good for automation
#head /etc/passwd > /tmp/passwd
#cat /tmp/passwd
#To substitute word using sed s
#sed 's/root/admin/ passwd
#to change the file not just output
#sed -i 's/root/admin' passwd
#To delete first line
#sed -e '1 d' passwd
#to inset new line
#sed -e '1 i hello' passwd
#to replace line
#sed -e '1 c 'hello' passwd
#syntax
#sed 'expression' <filename>
