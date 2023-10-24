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

# BEGIN enable i2c and spi and modifying config.txt ****************************************************

echo "\n**** Enabling SPI and I2C using raspi-config ****\n"

raspi-config nonint do_spi 0
raspi-config nonint do_i2c 0


echo "\n**** Adding lines to config.txt to recognize Pirate Audio pHAT ****\n"

echo "dtoverlay=hifiberry-dac" >> /boot/config.txt
echo "gpio=25=op,dh" >> /boot/config.txt

# END enable i2c and spi and modifying config.txt ****************************************************