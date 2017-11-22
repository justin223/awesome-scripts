#!/bin/bash

# Revoke administrative privileges from user $1 on macOS

# get user '$1' UUID
USERID=`dscl . list /Users GeneratedUID | grep -v ^_.* | grep $1 | awk '{print $2}'`

# remove user '$1' from group /Groups/admin
if [[ $USERID ]]; then
	dscl . delete /Groups/admin GroupMembers $USERID
fi

dscl . delete /Groups/admin GroupMembership $1
