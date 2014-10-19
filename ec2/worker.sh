#!/bin/bash
HEADNODE=$1
CONCURRENCY=" -c 2 "
#WORKER_INIT_SCRIPT
WORKERPORT="50005"
#Ping timeout
echo HEADNODE=$HEADNODE:$WORKERPORT
echo CONCURRENCY=$CONCURRENCY
export JAVA=/usr/local/bin/jdk1.7.0_51/bin
export SWIFT=/usr/local/bin/swift-trunk/bin
export PATH=$JAVA:$SWIFT:$PATH
umount /mnt
rm /var/log/worker-0099.log
mkdir /scratch;
yes | mdadm --create --verbose /dev/md0 --level=stripe --raid-devices=2 /dev/xvdb /dev/xvdc
mkfs.ext4 /dev/md0; mount -t ext4 /dev/md0 /scratch; 
mount -t ext4 /dev/md/* /scratch
chmod 777 /scratch
mkdir /s3; chmod 777 /s3;
PTIMEOUT=4
#Disk_setup
export ENABLE_WORKER_LOGGING
export WORKER_LOGGING_LEVEL=DEBUG
worker_loop ()
{
    while :
    do
        echo "Connecting to HEADNODE on $HEADNODE"
        worker.pl -w 3600 $CONCURRENCY http://$HEADNODE:$WORKERPORT 0099 /var/log
        sleep 5
    done
}
worker_loop &
