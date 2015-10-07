#!/bin/bash

if [ $# -ne 2 ]
then
    echo "Usage: $0 <start|stop> <num slaves>"
    exit 1
fi

NNODES=$2
TOTNODES=$(( NNODES + 1 ))
PWD=`pwd`
PERMSTORE=$HOME/datasets/hdfs
DATASETS=$HOME/datasets

if [ $NNODES -lt 1 ]
then
    echo "Invalid number of slaves: $NNODES"
    exit 1
fi

echo "Will $1 $TOTNODES nodes with $NNODES slaves"

if [ $1 == "start" ]
then
    echo "Starting master..."
    echo "docker run -d -t --dns 127.0.0.1 -e NODE_TYPE=n -e NNODES=$TOTNODES -P --name master -h master.julia --entrypoint=\"/bin/bash\" julialang/hadoop /hadoop/start.sh"
    #docker run -d -t -v $DATASETS:/datastore -v $PERMSTORE/master:/data --dns 127.0.0.1 -e NODE_TYPE=n -e NNODES=$TOTNODES -P --name master -h master.julia --entrypoint="/bin/bash" julialang/hadoop /hadoop/start.sh
    docker run -d -t -v $DATASETS:/datastore --dns 127.0.0.1 -e NODE_TYPE=n -e NNODES=$TOTNODES -P --name master -h master.julia --entrypoint="/bin/bash" julialang/hadoop /hadoop/start.sh
    echo "Copying the masker ssh key into ./id_rsa"
    docker cp master:/root/.ssh/id_rsa .
    chmod 400 ./id_rsa

    echo "Starting slaves..."
    for NNUM in `seq 1 $NNODES`
    do
        echo "    slave$NNUM..."
        #docker run -d -t -v $PERMSTORE/slave$NNUM:/data --dns 127.0.0.1 -e NODE_TYPE=d -e JOIN_IP=master --link master:master --name slave$NNUM -h slave${NNUM}.julia --entrypoint="/bin/bash" julialang/hadoop /hadoop/start.sh
        docker run -d -t --dns 127.0.0.1 -e NODE_TYPE=d -e JOIN_IP=master --link master:master --name slave$NNUM -h slave${NNUM}.julia --entrypoint="/bin/bash" julialang/hadoop /hadoop/start.sh
    done

    SSHPORT=`docker inspect master | { echo -; echo; cat; } | awk -f JSON.awk | grep HostPort | grep "22/tcp" | cut -d"]" -f2 | cut -d"\"" -f2`
    echo "To log in to master node:"
    echo "ssh -i ${PWD}/id_rsa -p ${SSHPORT} root@localhost"
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

    if [ -f ./id_rsa ]
    then
        chmod +w ./id_rsa
        echo "Removing the master ssh key"
        rm ./id_rsa
    else
        echo "No ssh master key file to be removed"
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
