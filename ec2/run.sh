#!/bin/bash

./getIP.py > getIP_log.txt
./init.sh $(cat getIP_log.txt) 
rm getIP_log.txt
