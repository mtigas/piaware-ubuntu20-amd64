#!/bin/bash
INSTALL_DIRECTORY=${PWD}

echo -e "\e[32mUpdating\e[39m"
sudo apt update

echo -e "\e[32mInstalling build tools\e[39m"
sudo apt install -y git build-essential debhelper pkg-config dh-systemd

echo -e "\e[32mInstalling dependencies \e[39m"
sudo apt install -y librtlsdr-dev libncurses5-dev lighttpd libbladerf-dev libhackrf-dev liblimesuite-dev

sudo systemctl enable lighttpd
sudo systemctl restart lighttpd

echo -e "\e[32mCloning dump1090-fa source code\e[39m"
cd ${INSTALL_DIRECTORY}
git clone https://github.com/flightaware/dump1090

cd ${INSTALL_DIRECTORY}/dump1090
git fetch --all
git reset --hard origin/master

if [[ `lsb_release -sc` == "kali-rolling" ]]; then
sudo sed -i 's/dh-systemd,//' debian/control
fi

echo -e "\e[32mBuilding dump1090-fa package\e[39m"
sudo dpkg-buildpackage -b --no-sign


echo -e "\e[32mInstalling dump1090-fa \e[39m"
VER=$(git describe --tags | sed 's/^v//')
cd ../
sudo dpkg -i dump1090-fa_${VER}_*.deb

sudo systemctl enable dump1090-fa
sudo systemctl restart dump1090-fa

echo ""
echo -e "\e[32mDUMP1090-FA INSTALLATION COMPLETED \e[39m"
echo -e "\e[31mREBOOT Computer \e[39m"
echo -e "\e[31mREBOOT Computer \e[39m"
echo -e "\e[31mREBOOT Computer \e[39m"
echo ""




