#!/bin/bash

if [ $# -ne 2 ]
then
    echo "Usage: $0 <start|stop> <num slaves>"
    exit 1
fi

NNODES=$2
TOTNODES=$(( NNODES + 1 ))
PWD=`pwd`

if [ $NNODES -lt 1 ]
then
    echo "Invalid number of slaves: $NNODES"
    exit 1
fi

echo "Will $1 $TOTNODES nodes with $NNODES slaves"

if [ $1 == "start" ]
then
    echo "Creating network..."
    docker network create julia

    echo "Starting slaves..."
    for NNUM in `seq 1 $NNODES`
    do
        echo "    slave$NNUM..."
        docker run -d -t --net julia -e NODE_TYPE=d --name slave${NNUM} -h slave${NNUM}.julia --entrypoint /hadoop/start.sh julialang/hadoop
    done

    sleep 5
    echo "Starting master..."
    docker run -d -t --net julia -e NODE_TYPE=n -e NNODES=$NNODES -P --name master -h master.julia --entrypoint /hadoop/start.sh julialang/hadoop

    echo "To log in to master node:"
    echo "docker exec -it master /bin/bash"
else
    echo "Stopping $TOTNODES nodes with $NNODES slaves"

    if docker inspect master >/dev/null 2>&1
    then
        echo "Stopping master..."
        docker kill master
        docker rm master
    else
        echo "    master not running"
    fi

    echo "Stopping slaves..."
    for NNUM in `seq 1 $NNODES`
    do
        if docker inspect slave$NNUM >/dev/null 2>&1
        then
            echo "    slave$NNUM..."
            docker kill slave${NNUM}
            docker rm slave${NNUM}
        else
            echo "    slave${NNUM} not running"
        fi
    done
fi

echo "DONE"
