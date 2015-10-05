#!/bin/bash

# Start standalone:
# - start the docker container: "docker run -it julialang/hadoop"
# - from the docker container, run: "/hadoop/start.sh"

# Start cluster:
# - Start the master node in daemon mode to use with APIs only:
#   docker run -d -t --dns 127.0.0.1 -e NODE_TYPE=n -e NNODES=2 -P --name master -h master.julia julialang/hadoop /hadoop/start.sh
# - Or, start master node in interactive mode:
#   docker run -i -t --dns 127.0.0.1 -e NODE_TYPE=n -e NNODES=2 -P --name master -h master.julia julialang/hadoop
#   And, run "/hadoop/start.sh" in the docker container shell.
# - Start the data nodes (as many as NNODES, with different hostnames):
#   docker run -d -t --dns 127.0.0.1 -e NODE_TYPE=d -e JOIN_IP=master --link master:master --name slave1 -h slave1.julia julialang/hadoop /hadoop/start.sh

if [ "$NODE_TYPE" = "d" ]; then
    echo "Starting datanode..."
    cp /hadoop/configs/cluster/dn/* $HADOOP_PREFIX/etc/hadoop/
    /usr/bin/svscan /etc/service/
elif [ "$NODE_TYPE" = "n" ]; then
    /usr/bin/svscan /etc/service/ &
    sleep 6
    echo "Waiting for datanodes to come up..."
    nnodes=`serf members | grep alive | cut -d" " -f1 | wc -l`
    while [ $nnodes -lt $NNODES ]
    do
        echo "$nnodes nodes, waiting till $NNODES"
        sleep 2
        nnodes=`serf members | grep alive | cut -d" " -f1 | wc -l`
    done
    echo "Starting namenode..."
    echo "master.julia" > $HADOOP_PREFIX/etc/hadoop/masters
    serf members | grep alive | cut -d" " -f1 > $HADOOP_PREFIX/etc/hadoop/slaves
    cp /hadoop/configs/cluster/nn-dn/* $HADOOP_PREFIX/etc/hadoop/
    #$HADOOP_PREFIX/bin/hdfs namenode -format
    # format if we are starting fresh, else /data may be an earlier volume mounted here
    if [ "$(ls -A /data 2> /dev/null)" == "" ]; then
        $HADOOP_PREFIX/bin/hdfs namenode -format
    fi
    $HADOOP_PREFIX/sbin/start-dfs.sh
    $HADOOP_PREFIX/sbin/start-yarn.sh

    serf members | grep alive | cut -d" " -f1 > $SPARK_HOME/conf/slaves
    #echo "Starting spark..."
    #$SPARK_HOME/sbin/start-all.sh

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
