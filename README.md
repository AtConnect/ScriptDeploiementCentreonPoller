# Script déploiement Plugins pour Centreon Poller
## /!\ A déployer après avoir effectuer le wizard de Centreon /!\

This script has been written by Kévin Perez for AtConnect Anglet

![asciicast](http://www.atconnect.net/images/header/logo.png)
![image](https://image.noelshack.com/fichiers/2019/17/3/1556112297-telechargement.png)

## Compatible with Centos 7 at least
#### Need Bash 4.2 at least to run.

# Step 1 - Run update and install git
```
yum install git-core -y && yum install curl -y

```
# Step 2 - Clone the repository and install it
```
cd /tmp
git clone https://github.com/AtConnect/ScriptDeploiementCentreonPoller
cd ScriptDeploiementCentreonPoller
chmod a+x lancercescriptsurcentreonpoller.sh
./lancercescriptsurcentreonpoller.sh
```

## /!\ You want to reboot Centreon ? A command has been defined for that /!\
```
reboot-centreon
```

## Versions
- **1.0** Kévin Perez
  - *New:* Repository added
  - *New:* Add reboot function


