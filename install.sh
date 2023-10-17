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

apt update
apt upgrade -y
apt-get -y install --no-install-recommends build-essential git autoconf automake libtool \
    libpopt-dev libconfig-dev libasound2-dev avahi-daemon libavahi-client-dev libssl-dev libsoxr-dev

sudo -u $real_user git clone https://github.com/mikebrady/shairport-sync.git
sudo -u $real_user cd shairport-sync
sudo -u $real_user autoreconf -fi
sudo -u $real_user ./configure --sysconfdir=/etc --with-alsa \
    --with-soxr --with-avahi --with-ssl=openssl --with-systemd --with-airplay-2
sudo -u $real_user make

make install

sudo -u $real_user shairport-sync