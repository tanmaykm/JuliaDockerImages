# Julia Docker Images

Docker images for base Julia and Julia packages. 

The Julia base image packages provide just Julia and IJulia but do not include any packages. These are much smaller downloads, but require you to install any packages you need.
To persist installed packages across docker sessions, mount a local volume as the user home folder.

The Julia package distributions build on the base image and bundle a set of packages by default.

Select the appropriate base Julia or a package distribution that matches your requirement and follow the steps below to install and run.

### Installation
- Docker images are available at https://registry.hub.docker.com/u/tanmaykm/
- Pull the selected image with: `docker pull <imagename>:<version>`

### Running
- Run to get a shell prompt: `docker run -it <image>:<version>`
- Run Julia: `docker run -it --entrypoint="/usr/bin/julia" <image>:<version>`
- Run IJulia: `docker run -it --net="host" --entrypoint="/usr/local/bin/ipython" <image>:<version> notebook --profile julia`

The default user in the image is `root` with home directory `/root`. The default working directory is `/`.

## Available Images

Description                     | Image & Latest Version                           | URL
--------------------------------|--------------------------------------------------|-------------------------------------
Base Julia v0.3.6               | `tanmaykm/julia:v0.3.6`                          | [tanmaykm/julia](https://registry.hub.docker.com/u/tanmaykm/julia/)
JuliaBox minimal package bundle | `tanmaykm/juliaboxminpkgdist:v0.3.6_build_1`     | [tanmaykm/juliaboxminpkgdist](https://registry.hub.docker.com/u/tanmaykm/juliaboxminpkgdist/)
JuliaBox package bundle         | `tanmaykm/juliaboxpkgdist:v0.3.6_build_1`        | [tanmaykm/juliaboxpkgdist](https://registry.hub.docker.com/u/tanmaykm/juliaboxpkgdist/)

## Contributing
Please submit pull requests to update/add packages. As far as possible, please extend from an existing image specification to avoid duplication.

