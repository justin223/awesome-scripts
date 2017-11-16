#!/bin/bash

# Filter AD users 80xxxx into file users.txt
dscl . list /Users GeneratedUID | grep -v ^_.*  | grep ^80 | awk '{print $1}' > users.txt

# Read from file users.txt line by line, and remove it
while read -r line
do
	uid="$line"
	echo $uid
	sysadminctl -deleteUser $uid -secure > null 2>&1
done < users.txt

# Remove user with ID $1 (the first parameter)
USERID=`dscl . list /Users GeneratedUID | grep -v ^_.*  | grep $1 | awk '{print $1}'`
echo $USERID
sysadminctl -deleteUser $USERID -secure > null 2>&1
