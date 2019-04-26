#!/bin/bash
# Define OID of cpu
oidCpu=1.3.6.1.4.1.13191.10.3.3.1.2.1.0
#Define Argument
version=$1
community=$2
hostname=$3
cpusystem=`snmpwalk -v $version -c $community $hostname $oidCpu | awk '{print $4}' | cut -d '"' -f2`
limit50=50
limit97=97

if [ $cpusystem -gt $limit97 ]; then
	echo "CPU : $cpusystem %"
	echo "CPU : $cpusystem %|'Usage CPU'=$cpusystem%;50;97;;"
	exit 2
elif [ $cpusystem -gt $limit50 ]; then
	echo "CPU : $cpusystem %|'Usage CPU'=$cpusystem%;50;97;;"
	exit 1
else	
	echo "CPU : $cpusystem %|'Usage CPU'=$cpusystem%;50;97;;"
	exit 0
fi

