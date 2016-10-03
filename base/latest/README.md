Note: Images for other Julia versions also available. Replace desired version number in instructions below.

See <https://github.com/tanmaykm/JuliaDockerImages> and <https://hub.docker.com/r/julialang/julia/tags/>

## Julia latest Docker Image

This docker image bundles: 
- Latest Julia 0.3.12, Julia 0.4.7, Julia 0.5.0 and Julia 0.6.0-dev. Julia v0.4.7 is the default.
- Jupyter 4.2.x

image: julialang/julia
version: latest (replace x with the latest minor version number)

## Getting the image:

To pull a pre-built image from dockerhub, run `docker pull <image>:<version>`

Alternatively, to build locally, run `git clone https://github.com/tanmaykm/JuliaDockerImages.git && docker build -t julialang/julia:latest JuliaDockerImages/base/latest`

## Running

- Run to get a shell prompt: docker run -it <image>:<version>
- Run Julia: docker run -it --entrypoint="/opt/julia/bin/julia" <image>:<version>
- Run Jupyter: docker run -it --net="host" --entrypoint="/usr/local/bin/jupyter" <image>:<version> notebook
