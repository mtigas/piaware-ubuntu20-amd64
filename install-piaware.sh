#!/bin/bash

INSTALL_DIRECTORY=${PWD}

echo -e "\e[32mUpdating\e[39m"
sudo apt update
echo -e "\e[32mInstalling build tools\e[39m"
sudo apt install -y git dh-systemd devscripts pkg-config

echo -e "\e[32mBuilding & Installing tcl-tls from source code. \e[39m"
echo -e "\e[32mInstalling tcl-tls dependencies \e[39m"
sudo apt install -y libssl-dev tcl-dev chrpath
echo -e "\e[32mCloning tcl-tls source code \e[39m"

cd  ${INSTALL_DIRECTORY}
git clone http://github.com/flightaware/tcltls-rebuild.git  
echo -e "\e[32mbuilding tcl-tls package \e[39m"
cd  ${INSTALL_DIRECTORY}/tcltls-rebuild
./prepare-build.sh buster
cd package-buster
sudo dpkg-buildpackage -b --no-sign
echo -e "\e[32mInstalling tcl-tls package \e[39m"
cd ../
sudo dpkg -i tcl-tls_*.deb


echo -e "\e[32mInstalling piaware dependencies \e[39m"
sudo apt install -y tcl8.6-dev python3-dev libz-dev 
sudo apt install -y libboost-system-dev libboost-program-options-dev
sudo apt install -y libboost-regex-dev libboost-filesystem-dev
sudo apt install -y net-tools tclx8.4 tcllib itcl3


echo -e "\e[32mCloning piaware source code and building package \e[39m"
cd ${INSTALL_DIRECTORY}
git clone http://github.com/flightaware/piaware_builder     
cd ${INSTALL_DIRECTORY}/piaware_builder
sudo ./sensible-build.sh bionic

echo -e "\e[32mCarrying out Workaround for pyvenv  \e[39m"
cd ${INSTALL_DIRECTORY}/piaware_builder/package-bionic
sudo sed -i 's/pyvenv $(VENV) --without-pip/$(PYTHON3) -m venv $(VENV) --without-pip/' debian/rules
sudo sed -i 's/python3-venv, //' debian/control

echo -e "\e[32mbuilding the piaware package \e[39m"
sudo dpkg-buildpackage -b --no-sign 

echo -e "\e[32mInstalling piaware package\e[39m"
cd ../
sudo dpkg -i piaware_*.deb

echo -e "\e[32mEnabling piaware (for Kali Linux)\e[39m"
sudo systemctl enable piaware
sudo systemctl restart piaware

echo ""
echo -e "\e[32mPIAWARE INSTALLATION COMPLETED \e[39m"
echo ""
echo -e "\e[39mIf you already have  feeder-id, please configure piaware with it \e[39m"
echo -e "\e[39mFeeder Id is available on this address while loggedin: \e[39m"
echo -e "\e[94m    https://flightaware.com/adsb/stats/user/ \e[39m"
echo ""
echo -e "\e[39m    sudo piaware-config feeder-id xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx \e[39m"
echo -e "\e[39m    sudo piaware-config allow-manual-updates yes \e[39m"
echo -e "\e[39m    sudo piaware-config allow-auto-updates yes \e[39m"
echo -e "\e[39m    sudo systemctl restart piaware \e[39m"
echo ""
echo -e "\e[39mIf you dont already have a feeder-id, please go to Flightaware Claim page while loggedin \e[39m"
echo -e "\e[94m    https://flightaware.com/adsb/piaware/claim \e[39m"
echo ""

