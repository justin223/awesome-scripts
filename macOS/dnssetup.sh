#!/bin/bash

# get Ethernet interface
ETHERNET=`networksetup -listallnetworkservices | grep Ethernet`

echo $ETHERNET

# set DNS servers
if [[ $ETHERNET ]]; then
		networksetup -setdnsservers "$ETHERNET" DNS1 DNS2
fi

# show DNS servers
networksetup -getdnsservers "$ETHERNET"
