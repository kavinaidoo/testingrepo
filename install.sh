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

echo "\nUpdate, Upgrade, Install\n"

apt update
apt upgrade -y
apt-get -y install --no-install-recommends build-essential git autoconf automake libtool \
    libpopt-dev libconfig-dev libasound2-dev avahi-daemon libavahi-client-dev libssl-dev libsoxr-dev


#echo "\nRunning as $real_user\n"

echo "\nCloning and Make\n"

#sudo -i -u $real_user bash << EOF
cd /home/$real_user/
git clone https://github.com/mikebrady/shairport-sync.git
cd /home/$real_user/shairport-sync
autoreconf -fi
./configure --sysconfdir=/etc --with-alsa \
    --with-soxr --with-avahi --with-ssl=openssl --with-systemd
make
#EOF

echo "\nMake Install\n"

#echo "\nRunning as root\n"

#cd /home/$real_user/
make install

#echo "\nRunning as $real_user\n"

#sudo -u $real_user 

echo "\nRun shairport-sync\n"

shairport-sync