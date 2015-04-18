#!/bin/bash

SLAVES=`cat /etc/dnsmasq.d/0hosts | grep address | grep slave | cut -d"/" -f2`

for slave in $SLAVES
do
    echo "executing \"$1\" on $slave"
    ssh $slave "$1"
done
