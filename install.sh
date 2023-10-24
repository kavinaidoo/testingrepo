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

echo "\n Welcome to the pmap installation script\n"
echo " Usage of this script is at your own risk\n"
echo " Designed for RPiOS Lite (32-bit Bookworm) on Pi Zero 2 \n"
echo " The following will be installed:"
echo " * shairport-sync with AirPlay 2 enabled"
echo " * pmap with basic functionality\n"
echo " Script will reboot Pi once completed\n"
echo " To stop it from running, press ctrl+c within the next 30 seconds\n"

sleep 30

echo "\n**** Running apt-get update and upgrade ****\n"

apt update
apt upgrade -y

# BEGIN enable i2c and spi and modifying config.txt ****************************************************

echo "\n**** Enabling SPI and I2C using raspi-config ****\n"

raspi-config nonint do_spi 0
raspi-config nonint do_i2c 0


echo "\n**** Adding lines to config.txt to recognize Pirate Audio pHAT ****\n"

echo "dtoverlay=hifiberry-dac" >> /boot/config.txt
echo "gpio=25=op,dh" >> /boot/config.txt

# END enable i2c and spi and modifying config.txt ****************************************************

# BEGIN shairport-sync installation ****************************************************
# Install Steps have been replicated from -> https://github.com/mikebrady/shairport-sync/blob/master/BUILD.md

echo "\n**** Installing shairport-sync ****\n"

echo "\n* Installing Requirements *\n"

apt-get -y install --no-install-recommends build-essential git autoconf automake libtool \
    libpopt-dev libconfig-dev libasound2-dev avahi-daemon libavahi-client-dev libssl-dev libsoxr-dev \
    libplist-dev libsodium-dev libavutil-dev libavcodec-dev libavformat-dev uuid-dev libgcrypt-dev xxd


echo "\n* Cloning, making and installing nqptp *\n"

cd /home/$real_user/
git clone https://github.com/mikebrady/nqptp.git
cd /home/$real_user/nqptp
autoreconf -fi
./configure --with-systemd-startup
make
make install

#TODO - remove these lines when switching to manually starting nqptp
echo "\n* Enabling nqptp as a service *\n"
systemctl enable nqptp
systemctl start nqptp


echo "\n* Cloning, making and installing shairport-sync *\n"

cd /home/$real_user/
git clone https://github.com/mikebrady/shairport-sync.git
cd /home/$real_user/shairport-sync
autoreconf -fi
./configure --sysconfdir=/etc --with-alsa \
    --with-soxr --with-avahi --with-ssl=openssl --with-systemd --with-airplay-2
make
make install

#TODO - remove these lines when switching to manually starting shairport-sync
echo "\n* Enabling shairport-sync as a service *\n"
systemctl enable shairport-sync

echo "\n**** Installation of shairport-sync completed ****\n"

# END shairport-sync installation ****************************************************

# BEGIN pmap installation ****************************************************

echo "\n**** Installing dependencies and downloading pmap ****\n"

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

# END pmap installation ****************************************************

echo "\n* Rebooting in 30 seconds *\n"
sleep 30

reboot now