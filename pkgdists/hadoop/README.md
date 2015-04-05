## Julia Hadoop Docker Image

This docker image bundles: 
- Hadoop 2.6.0 
- Julia 0.4.0 
- HDFS.jl
- Elly.jl

The docker image can be used to easily setup a Hadoop cluster with Julia. It can also be conveniently run in standalone mode for building / testing Julia packages or code.

## Start standalone:
1. start the docker container: `docker run -it julialang/hadoop`
2. from the docker container shell, run: `/hadoop/start.sh`

## Start cluster:
1. Start the master node
  - either in daemon mode to use with APIs only: `docker run -d -t --dns 127.0.0.1 -e NODE_TYPE=n -e NNODES=2 -P --name master -h master.julia julialang/hadoop /hadoop/start.sh`
  - or, in interactive mode: `docker run -i -t --dns 127.0.0.1 -e NODE_TYPE=n -e NNODES=2 -P --name master -h master.julia julialang/hadoop`
  - run `/hadoop/start.sh` in the docker container shell, when in interactive mode.
2. Start the data nodes (as many as `NNODES`, each with different hostnames):
`docker run -d -t --dns 127.0.0.1 -e NODE_TYPE=d -e JOIN_IP=master --link master:master --name slave1 -h slave1.julia julialang/hadoop /hadoop/start.sh`
