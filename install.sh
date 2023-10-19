#!/bin/bash

if ! [ $(id -u) = 0 ]; then
   echo "The script needs to be run as root." >&2
   exit 1
fi

if [ $SUDO_USER ]; then
    real_user=$SUDO_USER
else
    real_user=$(whoami)
fi


apt-get -y install python3-smbus 

cd /home/$real_user/
mkdir UPS_HAT_C
cd UPS_HAT_C
curl -O https://raw.githubusercontent.com/kavinaidoo/pmap/dev/INA219.py

python3 /home/$real_user/UPS_HAT_C/INA219.py
