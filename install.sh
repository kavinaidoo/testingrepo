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

echo "\n**** installing dependencies and downloading pmap ****\n"

# required for INA219.py
apt-get -y install python3-smbus
# required for st7789
apt-get -y install python3-rpi.gpio python3-spidev python3-pip python3-pil python3-numpy
# required for pmap.py

cd /home/$real_user/
mkdir pmap
cd pmap

pip3 install st7789 --break-system-packages

curl -O https://raw.githubusercontent.com/kavinaidoo/pmap/dev/INA219.py
curl -O https://raw.githubusercontent.com/kavinaidoo/pmap/dev/pmap.py

echo "\n**** installating dependencies and downloading pmap completed ****\n"