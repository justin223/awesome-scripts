#!/bin/bash

if [ $# -lt 2 ]
then
	echo 请输入正确的参数。
	exit
fi

# Computer Name by IP
case $2 in
156|157|158|159)
	PREFIX=17.118.$2
;;

190)
	PREFIX=17.117.$2
;;

0|1)
	PREFIX=10.82.$2
;;

*)
	echo "Invalid argument"
esac

if [[ $PREFIX ]]; then
	IP=`ifconfig | grep $PREFIX | awk '{print $2}'`
	echo $IP
	NEED1=`echo $IP | awk -F. '{print $3}'`
	echo $NEED1
	NEED2=`echo $IP | awk -F. '{print $4}'`
	echo $NEED2
	
	if [ $NEED1 -eq 0 ] || [ $NEED1 -eq 1 ]
	then
		NEED1=82$NEED1
	fi
	
	scutil --set ComputerName CQ$1F$NEED1$NEED2
	scutil --set HostName CQ$1F$NEED1$NEED2
	scutil --set LocalHostName CQ$1F$NEED1$NEED2
else
	echo “No change.”
fi





