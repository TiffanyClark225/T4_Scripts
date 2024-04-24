#!/bin/bash

echo "Firewall Starting"

SERVER_IF="eth1"
ROUTER_IF="eth2"

EXPERIMENTAL_IF="eth0"

# Flush Tables
sudo iptables --flush

# Block SYN flood attack to gateway
sudo iptables -A INPUT -p tcp ! --syn -m state --state NEW -j DROP

# Block SYN flood attack to server
sudo iptables -A FORWARD -p tcp ! --syn -m state --state NEW -j DROP

echo "Firewall Active"
