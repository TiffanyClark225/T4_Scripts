#!/bin/bash

echo "Firewall Starting"

SERVER_IF="eth1"
ROUTER_IF="eth2"

EXPERIMENTAL_IF="eth0"

# Flush Tables
sudo iptables --flush

echo "Firewall Active"
