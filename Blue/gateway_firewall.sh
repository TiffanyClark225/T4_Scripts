#!/bin/bash

echo "Gateway Firewall Starting..."

ROUTER_ETH="eth0" 
SERVER_ETH="eth1"  

# Clear all existing rules
sudo iptables --flush

# Drop all UDP and ICMP traffic
sudo iptables -A INPUT -i $ROUTER_ETH -p udp -j DROP
sudo iptables -A INPUT -i $SERVER_ETH -p udp -j DROP
sudo iptables -A INPUT -i $SERVER_ETH -p icmp -j DROP
sudo iptables -A OUTPUT -o $ROUTER_ETH -p udp -j DROP
sudo iptables -A OUTPUT -o $SERVER_ETH -p udp -j DROP

# Block null packets
sudo iptables -A INPUT -p tcp --tcp-flags ALL NONE -j DROP

# Block XMAS packets
sudo iptables -A INPUT -p tcp --tcp-flags ALL ALL -j DROP

# Block SYN flood attack
sudo iptables -A INPUT -p tcp ! --syn -m state --state NEW -j DROP
iptables -t mangle -A PREROUTING -p tcp ! --syn -m conntrack --ctstate NEW -j DROP

# Block teardrop attacks
sudo iptables -A INPUT -p UDP -f -j DROP
sudo iptables -A OUTPUT -p UDP -f -j DROP
sudo iptables -A INPUT -p UDP -m length --length 1500 -j DROP
sudo iptables -A INPUT -p UDP -m length --length 58 -j DROP
sudo iptables -A OUTPUT -p UDP -m length --length 1500 -j DROP
sudo iptables -A OUTPUT -p UDP -m length --length 58 -j DROP

# Block packets with invalid TCP flags
sudo iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG NONE -j DROP
sudo iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,SYN FIN,SYN -j DROP
sudo iptables -t mangle -A PREROUTING -p tcp --tcp-flags SYN,RST SYN,RST -j DROP
sudo iptables -t mangle -A PREROUTING -p tcp --tcp-flags SYN,FIN SYN,FIN -j DROP
sudo iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,RST FIN,RST -j DROP
sudo iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,ACK FIN -j DROP
sudo iptables -t mangle -A PREROUTING -p tcp --tcp-flags ACK,URG URG -j DROP
sudo iptables -t mangle -A PREROUTING -p tcp --tcp-flags ACK,FIN FIN -j DROP
sudo iptables -t mangle -A PREROUTING -p tcp --tcp-flags ACK,PSH PSH -j DROP
sudo iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL ALL -j DROP
sudo iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL NONE -j DROP
sudo iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL FIN,PSH,URG -j DROP
sudo iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL SYN,FIN,PSH,URG -j DROP
sudo iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL SYN,RST,ACK,FIN,URG -j DROP

# Sockstress defense
sudo iptables -A INPUT -p tcp --dport 80 -m state --state NEW -m recent --set
sudo iptables -A INPUT -p tcp --dport 80 -m state --state NEW -m recent --update --seconds 2 --hitcount 4 -j DROP

# Prevent IP spoofing
sudo iptables -t mangle -I PREROUTING -p tcp -m tcp --dport 80 -m state --state NEW -m tcpmss ! --mss 536:65535 -j DROP

# Defend against Slowloris
sudo iptables -A INPUT -p tcp --syn --dport 80 -m connlimit --connlimit-above 20 -j DROP

# Prevent DoS attacks
sudo iptables -A INPUT -p tcp --dport 80 -m limit --limit 2/s -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 22 -m limit --limit 2/s -j ACCEPT 
sudo iptables -A INPUT -p tcp --dport 443 -m limit --limit 2/s -j ACCEPT

# Allow established and related connections 
sudo iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT

# Allow outgoing DNS requests
sudo iptables -A OUTPUT -p udp --dport 53 -j ACCEPT 

# Passively ignore all other traffic
sudo iptables -A INPUT -i $ROUTER_ETH -j DROP
sudo iptables -A OUTPUT -o $ROUTER_ETH -j DROP
sudo iptables -A INPUT -i $SERVER_ETH -j DROP
sudo iptables -A OUTPUT -o $SERVER_ETH -j DROP

echo "Gateway Firewall Active!"
