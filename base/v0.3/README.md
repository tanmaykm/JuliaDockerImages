## Julia 0.3 Docker Image

This docker image bundles: 
- Latest Julia 0.3.x
- IJulia

image: julialang/julia
version: 0.3.x (replace x with the latest minor version number)

## Getting the image:

To pull a pre-built image from dockerhub, run `docker pull <image>:<version>`

Alternatively, to build locally, run `git clone https://github.com/tanmaykm/JuliaDockerImages.git && docker build -t julialang/julia:v0.3.x JuliaDockerImages/base/v0.3`

## Running

- Run to get a shell prompt: docker run -it <image>:<version>
- Run Julia: docker run -it --entrypoint="/usr/bin/julia" <image>:<version>
- Run IJulia: docker run -it --net="host" --entrypoint="/usr/local/bin/ipython" <image>:<version> notebook --profile julia
