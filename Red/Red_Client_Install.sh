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

echo "Installing hping3..."
sudo apt-get -y install hping3
echo "hping3 installed"

echo "Installing slowhttptest..."
sudo apt-get -y install slowhttptest
echo "slowhttpest installed"

echo "Installing tcdump ..."
sudo apt-get -y install tcdump
echo "tcdump installed"

echo "Installing nmap ..."
sudo apt-get -y install nmap
echo "nmap installed"

echo "Installing telnet ..."
sudo apt-get -y install telnet
echo "telnet installed"
