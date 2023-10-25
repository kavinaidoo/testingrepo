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

echo "\n**** installating ubuntu font ****\n"

cd /home/$real_user/pmap

curl -O https://github.com/google/fonts/raw/main/ufl/ubuntu/Ubuntu-Regular.ttf

mkdir ubuntu_font_docs
cd /home/$real_user/pmap/ubuntu_font_docs

curl -O https://raw.githubusercontent.com/google/fonts/main/ufl/ubuntu/COPYRIGHT.txt
curl -O https://raw.githubusercontent.com/google/fonts/main/ufl/ubuntu/TRADEMARKS.txt
curl -O https://raw.githubusercontent.com/google/fonts/main/ufl/ubuntu/UFL.txt

echo "\n**** installating ubuntu font complete ****\n"

# END pmap installation ****************************************************

