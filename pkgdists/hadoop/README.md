## Julia Hadoop Docker Image

This docker image bundles: 
- Hadoop 2.7.1
- Julia 0.4
- HDFS.jl
- Elly.jl
- DistributedArrays.jl

The docker image can be used to easily setup a Hadoop cluster with Julia. It can also be conveniently run in standalone mode for building / testing Julia packages or code.

## Getting the image:

To pull a pre-built image from dockerhub, run:
````
docker pull julialang/hadoop:v0.4.6
docker tag julialang/hadoop:v0.4.6 julialang/hadoop:latest
````

Alternatively, to build locally, run:
````
git clone https://github.com/tanmaykm/JuliaDockerImages.git
docker build -t julialang/julia:v0.4.6 JuliaDockerImages/base/v0.4
docker build -t julialang/hadoop:v0.4.6 JuliaDockerImages/pkgdists/hadoop
docker tag julialang/hadoop:v0.4.6 julialang/hadoop:latest
````

## Start standalone:
1. start the docker container: `docker run -it julialang/hadoop`
2. from the docker container shell, run: `/hadoop/start.sh`

## Start cluster:
1. Create a docker network named "julia": `docker network create julia`
2. Start the data nodes (as many as NNODES, with hostnames like slave`N` where `N` regresents Nth node): `docker run -d -t --net julia -e NODE_TYPE=d --name slave1 -h slave1.julia --entrypoint /hadoop/start.sh julialang/hadoop`
3. Start the master node: `docker run -d -t --net julia -e NODE_TYPE=n -e NNODES=2 -P --name master -h master.julia --entrypoint /hadoop/start.sh julialang/hadoop`
4. Log in to the master node (or any node for that matter): `docker exec -it master /bin/bash`
