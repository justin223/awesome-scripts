#!/bin/bash

# Filter AD users 80xxxx into file users.txt
dscl . list /Users | grep -v ^_.*  | grep ^80 > users.txt

# Read from file users.txt line by line, and remove it
while read -r line
do
	uid="$line"
	echo $uid
	# sysadminctl -deleteUser $uid -secure > /dev/null 2>&1
	dscl . delete /Users/$uid > /dev/null 2>&1
	rm -rf /Users/$uid
done < users.txt

# Remove user with ID $1 (the first parameter)
USERID=`dscl . list /Users GeneratedUID | grep -v ^_.*  | grep $1 | awk '{print $1}'`
echo $USERID
sysadminctl -deleteUser $USERID -secure > /dev/null 2>&1
