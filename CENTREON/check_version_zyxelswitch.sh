#!/bin/bash
# Define OID of version
oidVersion=1.3.6.1.4.1.890.1.15.3.1.6.0
#Define Argument
version=$1
community=$2
hostname=$3

versionsystem=`snmpwalk -v $version -c $community $hostname $oidVersion | awk '{print $4}' | cut -d '"' -f2`
datesystem=`/usr/bin/snmpwalk -v $version -c $community $hostname $oidVersion | awk '{print $6}' | cut -d '"' -f1`
checkdate=`/usr/bin/snmpwalk -v $version -c $community $hostname $oidVersion | awk '{print $6}' | cut -d '"' -f1 | cut -d '/' -f3`
anneeactuelle=`date +%Y`
anneeactuellemoins2=$anneeactuelle-2
if(($anneeactuelle > $anneeactuellemoins2)); then
	echo "Version : $versionsystem Date : $datesystem"
	exit 0
	else
	echo "Version : $versionsystem Date : $datesystem"
	exit 1
fi
