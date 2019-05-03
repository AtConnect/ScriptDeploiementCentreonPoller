#!/bin/bash
warning=$1
critical=$2
host=$3

numberofconnecteduser=`snmpwalk -v 2c -c public $host 1.3.6.1.4.1.890.1.15.3.5.2.1.4 | wc -l`

if [ $numberofconnecteduser -ge $critical ]; then
	exit 2
else if [ $numberofconnecteduser -ge $warning ]; then
	exit 1
else
	exit 0
fi

echo "User Connected : $numberofconnecteduser"

