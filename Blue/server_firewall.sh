#!/bin/bash

echo "Firewall Starting"

GATEWAY_IF="eth1"

EXPERIMENT_IF="eth0"

# Clear firewall rules
sudo iptables --flush

# -- PRIMARY POLICY --

# Allow all established and related traffic
sudo iptables -i $GATEWAY_IF -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
sudo iptables -o $GATEWAY_IF -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Allow ssh traffic on the experimental network interface
sudo iptables -i $EXPERIMENT_IF -A INPUT -p tcp --dport 22 -j ACCEPT
sudo iptables -o $EXPERIMENT_IF -A OUTPUT -p tcp --dport 22 -j ACCEPT

# -- CUSTOM POLICIES -- 

# Drop all UDP traffic
sudo iptables -i $GATEWAY_IF -A INPUT -p udp -j DROP
sudo iptables -o $GATEWAY_IF -A OUTPUT -p udp -j DROP

# Drop all ICMP traffic
sudo iptables -i $GATEWAY_IF -A INPUT -p icmp -j DROP
sudo iptables -o $GATEWAY_IF -A OUTPUT -p icmp -j DROP

# Block NULL packets
sudo iptables -A INPUT -p tcp --tcp-flags ALL NONE -j DROP

# Block XMAS packets
sudo iptables -A INPUT -p tcp --tcp-flags ALL ALL -j DROP

# Ignores internal packets in the server 
sudo iptables -A INPUT -s gateway -j DROP

# Block SYN flood attack
sudo iptables -A INPUT -p tcp ! --syn -m state --state NEW -j DROP

# Block new packets that are not SYN
sudo iptables -t mangle -A PREROUTING -p tcp ! --syn -m state --state NEW -j DROP

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

# Prevent Sockstress attack
sudo iptables -A INPUT -p tcp --dport 80 -m state --state NEW -m recent --set
sudo iptables -A INPUT -p tcp --dport 80 -m state --state NEW -m recent --update --seconds 2 --hitcount 4 -j DROP

# Limit MSS
sudo iptables -t mangle -A PREROUTING -p tcp -m state --state NEW -m tcpmss ! --mss 536:65535 -j DROP

# Sloloris Defense
sudo iptables -A INPUT -p tcp --dport 80 -m connlimit --connlimit-above 20 --connlimit-mask 30 -j DROP

# Block DDoS Attacks
sudo iptables -i $GATEWAY_IF -A INPUT -p tcp --dport 22 -m limit --limit 2/s -j ACCEPT
sudo iptables -i $GATEWAY_IF -A INPUT -p tcp --dport 80 -m limit --limit 2/s -j ACCEPT
sudo iptables -i $GATEWAY_IF -A INPUT -p tcp --dport 443 -m limit --limit 2/s -j ACCEPT

# -- ALLOW POLICY --

# Accept new TCP connections
sudo iptables -i $GATEWAY_IF -A INPUT -m state --state NEW -p tcp --dport 80 -j ACCEPT
sudo iptables -i $GATEWAY_IF -A INPUT -m state --state NEW -p tcp --dport 443 -j ACCEPT

# -- DROP POLICY --

# Ignore all other traffic
sudo iptables -i $GATEWAY_IF -A INPUT -j DROP

echo "Firewall Active"
