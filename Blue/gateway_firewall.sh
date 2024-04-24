#!/bin/bash

echo "Firewall Starting"

SERVER_IF="eth1"
ROUTER_IF="eth2"

EXPERIMENTAL_IF="eth0"

# Flush Tables
sudo iptables --flush

# Block SYN packets
sudo iptables -A FORWARD -p tcp ! --syn -m state --state NEW -j DROP

echo "Firewall Active"
