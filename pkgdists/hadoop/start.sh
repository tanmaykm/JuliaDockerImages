#!/bin/bash

# Start standalone:
# - start the docker container: "docker run -it julialang/hadoop"
# - from the docker container, run: "/hadoop/start.sh"

# Start cluster:
# - Create a docker network named "julia"
#   docker network create julia
# - Start the data nodes (as many as NNODES, with hostnames like slave${N} where ${N} regresents Nth node
#   docker run -d -t --net julia -e NODE_TYPE=d --name slave1 -h slave1.julia --entrypoint /hadoop/start.sh julialang/hadoop
# - Start the master node.
#   docker run -d -t --net julia -e NODE_TYPE=n -e NNODES=2 -P --name master -h master.julia --entrypoint /hadoop/start.sh julialang/hadoop
# - Log in to the master node (or any node for that matter) with:
#   docker exec -it master /bin/bash

echo "Starting sshd..."
service ssh start

if [ "$NODE_TYPE" = "d" ]; then
    echo "Starting datanode..."
    cp /hadoop/configs/cluster/dn/* $HADOOP_PREFIX/etc/hadoop/
    echo "Done. Sleeping."
    while true
    do
        sleep 300
    done
elif [ "$NODE_TYPE" = "n" ]; then
    echo "Starting namenode..."
    echo "master.julia" > $HADOOP_PREFIX/etc/hadoop/masters
    echo "master.julia" > $HADOOP_PREFIX/etc/hadoop/slaves
    for idx in `seq 1 $NNODES`
    do
        echo "slave${idx}.julia" >> $HADOOP_PREFIX/etc/hadoop/slaves
    done
    cp /hadoop/configs/cluster/nn-dn/* $HADOOP_PREFIX/etc/hadoop/
    $HADOOP_PREFIX/bin/hdfs namenode -format
    ## format if we are starting fresh, else /data may be an earlier volume mounted here
    #if [ "$(ls -A /data 2> /dev/null)" == "" ]; then
    #    $HADOOP_PREFIX/bin/hdfs namenode -format
    #fi
    $HADOOP_PREFIX/sbin/start-dfs.sh
    $HADOOP_PREFIX/sbin/start-yarn.sh

    echo "master.julia" > $SPARK_HOME/conf/slaves
    for idx in `seq 1 $NNODES`
    do
        echo "slave${idx}.julia" >> $SPARK_HOME/conf/slaves
    done
    echo "Starting spark..."
    $SPARK_HOME/sbin/start-all.sh
    echo "Done. Sleeping... Interrupt to go back to shell."

    while true
    do
        sleep 300
    done
else
    echo "Starting standalone mode..."
    cp /hadoop/configs/single/* $HADOOP_PREFIX/etc/hadoop/
    $HADOOP_PREFIX/bin/hdfs namenode -format
    $HADOOP_PREFIX/sbin/start-dfs.sh
    $HADOOP_PREFIX/sbin/start-yarn.sh
fi
