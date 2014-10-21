#!/bin/bash
echo $PWD

serverIP=$1
echo "Starting Headnode " $serverIP " ........."
scp -o StrictHostKeyChecking=no -i ./mykeypair.pem ./headnode.sh ubuntu@$serverIP:/home/ubuntu/ &> /dev/null
ssh -o StrictHostKeyChecking=no -i ./mykeypair.pem ubuntu@$serverIP 'sudo /home/ubuntu/headnode.sh &> /dev/null' &
echo "Headnode " $serverIP " started!"
sleep 10 

for workerIP in ${@:2}
do
    echo "Starting worker " $workerIP " ........."
    scp -o StrictHostKeyChecking=no -i mykeypair.pem worker.sh ubuntu@$workerIP:/home/ubuntu &> /dev/null
    ssh -o StrictHostKeyChecking=no -i mykeypair.pem ubuntu@$workerIP <<EOF &> /dev/null &
sudo /home/ubuntu/worker.sh $serverIP 
EOF
    echo "Worker " $workerIP " started!"
done
