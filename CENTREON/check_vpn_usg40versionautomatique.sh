#!/bin/bash
# Define OID of version
OidVpnName=1.3.6.1.4.1.890.1.6.22.2.4.1.2.
OidVpnStatus=1.3.6.1.4.1.890.1.6.22.2.4.1.5.
OidVpnEtat=1.3.6.1.4.1.890.1.6.22.2.4.1.6.

#Define Argument
version=$1
community=$2
hostname=$3
arraynom=()
arrayetat=()
outputfinal=0
nbrvpn=`snmpwalk -v $version -c $community $hostname 1.3.6.1.4.1.890.1.6.22.2.4.1.2 | awk '{print $4}' | wc -l`

for ((i=1;i<=nbrvpn;i++))
do
	NomVPN=`snmpwalk -v $version -c $community $hostname $OidVpnName$i | awk '{print $4}' | cut -d '"' -f2`
	StatusVPN=`snmpwalk -v $version -c $community $hostname $OidVpnStatus$i | awk '{print $4}'`
	EtatVPN=`snmpwalk -v $version -c $community $hostname $OidVpnEtat$i | awk '{print $4}'`

	if [ $StatusVPN -eq '1' ]; then
		if [ $EtatVPN -eq '1' ]; then
			EtatVPN='On'
			output=0			
		else
			output=2
			EtatVPN='Off'
		fi
		var="$NomVPN"
		arraynom+=($var)
		var2="$EtatVPN"
		arrayetat+=($var2)
	fi

	if [ $output -eq '2' ]; then
		outputfinal=2
	fi

done

if [ $outputfinal -eq '2' ]; then
	echo "Défaillance VPN"
else
	echo "VPN Ok"
fi

for ((i=0;i<${#arraynom[@]};i++))
do
	echo "Nom : " ${arraynom[i]} "Etat : " ${arrayetat[i]}
done

exit $outputfinal