#!/bin/bash
WORKERPORT="50005"; SERVICEPORT="50010"
export JAVA=/usr/local/bin/jdk1.7.0_51/bin
export SWIFT=/usr/local/bin/swift-trunk/bin
export PATH=$JAVA:$SWIFT:$PATH
umount /mnt
mkdir /scratch;
yes | mdadm --create --verbose /dev/md0 --level=stripe --raid-devices=2 /dev/xvdb /dev/xvdc
mkfs.ext4 /dev/md0; mount -t ext4 /dev/md0 /scratch;
mount -t ext4 /dev/md/* /scratch
chmod 777 /scratch
mkdir /s3; chmod 777 /s3;
cd /home/ubuntu/s3fs-fuse/
rm cps-*
coaster_loop ()
{
    while :
    do
        coaster-service -p $SERVICEPORT -localport $WORKERPORT -nosec -passive &> /var/log/coaster-service.logs
        sleep 10;
    done
}
coaster_loop &
