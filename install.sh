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

echo "\n**** Running apt update and upgrade ****\n"

apt update
apt upgrade -y

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

#Not adding nqptp as a service
#systemctl enable nqptp
#systemctl start nqptp


echo "\n* Cloning, making and installing shairport-sync *\n"

cd /home/$real_user/
git clone https://github.com/mikebrady/shairport-sync.git
cd /home/$real_user/shairport-sync
autoreconf -fi
./configure --sysconfdir=/etc --with-alsa \
    --with-soxr --with-avahi --with-ssl=openssl --with-systemd
make
make install

echo "\n* Run nqptp and shairport-sync *\n"

#running both simultaneously -> https://stackoverflow.com/a/52033580
(trap 'kill 0' SIGINT; /home/$real_user/nqptp/nqptp & /home/$real_user/shairport-sync/shairport-sync & wait)
