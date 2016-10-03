Note: Images for other Julia versions also available. Replace desired version number in instructions below.

See <https://github.com/tanmaykm/JuliaDockerImages> and <https://hub.docker.com/r/julialang/julia/tags/>

## Julia 0.5 Docker Image

This docker image bundles: 
- Latest Julia 0.5.x
- Jupyter 4.2.x

image: julialang/julia
version: 0.5.x (replace x with the latest minor version number)

## Getting the image:

To pull a pre-built image from dockerhub, run `docker pull <image>:<version>`

Alternatively, to build locally, run `git clone https://github.com/tanmaykm/JuliaDockerImages.git && docker build -t julialang/julia:v0.5.x JuliaDockerImages/base/v0.5`

## Running

- Run to get a shell prompt: docker run -it <image>:<version>
- Run Julia: docker run -it --entrypoint="/opt/julia/bin/julia" <image>:<version>
- Run Jupyter: docker run -it --net="host" --entrypoint="/usr/local/bin/jupyter" <image>:<version> notebook
