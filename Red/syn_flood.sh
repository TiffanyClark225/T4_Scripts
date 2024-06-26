#!/bin/bash

echo "Starting SlowHTTPTest to simulate a slow HTTP attack ..."

slowhttptest -c 1000 -H -g -o my_stats -i 10 -r 15 -t GET -u http://server/1.html -x 24 -p 1


echo "SlowHTTPTest completed. Check my_stats file for output"

# 1000 = num of conn
# -g = statistics generated
# i 10 = 10 sec interval
# r 15 = 15 conn opened every sec
# -x 24 = max len of time in s to keep conn open
# - p 1 = probe interval. every 1 sec check the status of conn
