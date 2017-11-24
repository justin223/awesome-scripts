#!/bin/sh
# set -x
# Shell script to monitor the disk space
# It will send an email to $SMAIL, if the used perecntage of space is >= $ALERT.

# Set email so that you can get email.
SMAIL=justin223@github.com
# Set alert level, 90% is default
ALERT=90

function mailout() {
    while read output;
    do
        echo $output
        usep=$(echo $output | awk '{print $1}' | sed 's/%//g')
        part=$(echo $output | awk '{print $2}')
        if [ $usep -ge $ALERT ]; then
            echo "Running out of space \"$part ($usep%)\" on server $(hostname), $(date)" | \
            mail -s "Alert: Almost out of disk space $usep%" $SMAIL
        fi
    done
}

df -h | grep -vE '^Filesystem|tmpfs|cdrom' | awk '{print $5 " " $1' | mailout
