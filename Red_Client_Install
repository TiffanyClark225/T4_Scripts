#!/bin/bash
echo "Installing ettercap..."
sudo apt-get -y install zlib1g zlib1g-dev
sudo apt-get -y install build-essential
sudo apt-get -y install ettercap
sudo apt-get -y install ettercap-text-only
echo "Ettercap installed"

echo "Installing netcat..."
sudo apt-get -y install netcat
echo "Netcat installed"

echo "Installing slowhttptest"
cd slowhttptest-1.7
./configure
make
sudo make install
echo "slowhttptest installed"

echo "Installing hping3..."
sudo apt-get -y install hping3
echo "hping3 installed"

echo "Installing slowhttptest..."
sudo apt-get -y install slowhttptest
echo "slowhttpest installed"

