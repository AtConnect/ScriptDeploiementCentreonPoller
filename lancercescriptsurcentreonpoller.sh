#!/usr/bin/env bash

set -e -o pipefail

#Update of the system only if update has been run without problem
clear


function CheckVersion(){
	VERSION=$(cat /etc/os-release | grep VERSION_ID | cut -d "=" -f2 | tr -d '"')
	if [[ "$VERSION" < 7 ]]; then
		exit 1
	fi
}

# shellcheck source=concurrent.lib.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/concurrent.lib.sh"

success() {
    local args=(
    	- "Checking version of the system"                 CheckVersion\
        - "Updating System"                                UpdateSystem\
        - "Downloading plugins for Centreon"               InstallPlugins\
        - "Configuration des Sudoers"                      ConfSudoers\
        - "Configuration des script Nagios"                CopyScriptsOfNagios\
        - "Restart Services"                               RestartServices\
        - "End of Installation"                            End\
        --sequential
        
    )
    concurrent "${args[@]}"
}

function UpdateSystem(){
	echo "Update System" >> logs
	yum update && yum upgrade -y >> logs
	yum install htop -y >> logs
	yum install iotop -y >> logs
	yum install gcc -y >> logs	
}

function InstallPlugins(){
	echo "Install Plugins" >> logs
	yum install nagios-plugins-* --skip-broken >> logs
}

function ConfSudoers(){	
	echo "Conf sudoers" >> logs
	echo "Cmnd_Alias CENTENGINE_RESTART = /sbin/service centengine restart" >> /etc/sudoers
	echo "Cmnd_Alias CENTENGINE_RELOAD = /sbin/service centengine reload" >> /etc/sudoers
	echo "centreon ALL=NOPASSWD: CENTENGINE_RESTART, CENTENGINE_RELOAD" >> /etc/sudoers
}

function CopyScriptsOfNagios(){
	echo "Installation plugins nagios" >> logs
	cd /tmp/CENTREON/ ||  exit 1
	cp check_cpuusage_oneaccess.sh /usr/lib64/nagios/plugins/check_cpuusage_oneaccess.sh
	cp check_cpuusage_zyxelusg40.sh /usr/lib64/nagios/plugins/check_cpuusage_zyxelusg40.sh
	cp check_memory_oneaccess.sh /usr/lib64/nagios/plugins/check_memory_oneaccess.sh
	cp check_version_oneaccess.sh /usr/lib64/nagios/plugins/check_version_oneaccess.sh
	cp check_version_zyxelswitch.sh /usr/lib64/nagios/plugins/check_version_zyxelswitch.sh
	cp check_version_zyxelusg40.sh /usr/lib64/nagios/plugins/check_version_zyxelusg40.sh
	cp check_vpn_usg40versionautomatique.sh /usr/lib64/nagios/plugins/check_vpn_usg40versionautomatique.sh
	chmod -R 755 /usr/lib64/nagios/plugins/
}


function RestartServices(){
	echo "Restart Services" >> logs
	service centengine restart
	service cbd restart
	service centcore restart
}

function End(){	

cat <<EOF > /usr/bin/reboot-centreon
	#!/bin/bash
	service centengine restart
	service cbd restart
	service centcore restart
EOF

	echo "Finish" >> logs
}


main() {
    if [[ -n "${1}" ]]; then
        "${1}"
    else
        echo
        echo "################################################################################" 
		echo -e "\033[45m#               Installation of Plugins and rights for Centreon            #\033[0m"
		echo -e "\033[45m#                     Compatible with CentOS 7 at least                       #\033[0m"
		echo "#                    Writed by Kévin Perez for AtConnect                       #"
		echo "# The task is in progress, please wait a few minutes while i'm doing your job !#"
		echo "################################################################################" 
		echo "--------------------------------------------------------------------------------"
        success
        
    fi
}

main "${@}"
