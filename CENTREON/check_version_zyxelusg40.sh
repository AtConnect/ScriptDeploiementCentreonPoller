#!/bin/bash
# Define OID of version
oidVersion=1.3.6.1.4.1.890.1.15.3.1.6.0
#Define Argument
version=$1
community=$2
hostname=$3
versionsystem=`snmpwalk -v $version -c $community $hostname $oidVersion | awk '{print $4}' | cut -d '"' -f2`
echo "Version : $versionsystem"
exit 0

