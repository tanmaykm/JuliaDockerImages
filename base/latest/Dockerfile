# Ubuntu Docker file for Julia
# Version:latest

FROM ubuntu:14.04

MAINTAINER Tanmay Mohapatra

RUN apt-get update \
    && apt-get upgrade -y -o Dpkg::Options::="--force-confdef" -o DPkg::Options::="--force-confold" \
    && apt-get install -y \
    man-db \
    libc6 \
    libc6-dev \
    build-essential \
    wget \
    curl \
    file \
    vim \
    screen \
    tmux \
    unzip \
    pkg-config \
    cmake \
    gfortran \
    gettext \
    libreadline-dev \
    libncurses-dev \
    libpcre3-dev \
    libgnutls28 \
    libzmq3-dev \
    libzmq3 \
    python \
    python-yaml \
    python-m2crypto \
    python-crypto \
    msgpack-python \
    python-dev \
    python-setuptools \
    supervisor \
    python-jinja2 \
    python-requests \
    python-isodate \
    python-git \
    python-pip \
    && apt-get clean

RUN pip install --upgrade pyzmq PyDrive google-api-python-client jsonpointer jsonschema tornado sphinx pygments nose readline mistune invoke

RUN pip install 'notebook==4.2'

RUN pip install 'rise==4.0.0b1'; jupyter-nbextension install rise --py --sys-prefix; jupyter-nbextension enable rise --py --sys-prefix

# Install julia 0.3
RUN mkdir -p /opt/julia-0.3.12 && \
    curl -s -L https://julialang.s3.amazonaws.com/bin/linux/x64/0.3/julia-0.3.12-linux-x86_64.tar.gz | tar -C /opt/julia-0.3.12 -x -z --strip-components=1 -f -
RUN ln -fs /opt/julia-0.3.12 /opt/julia-0.3

# Install julia 0.4
RUN mkdir -p /opt/julia-0.4.7 && \
    curl -s -L https://julialang.s3.amazonaws.com/bin/linux/x64/0.4/julia-0.4.7-linux-x86_64.tar.gz | tar -C /opt/julia-0.4.7 -x -z --strip-components=1 -f -
RUN ln -fs /opt/julia-0.4.7 /opt/julia-0.4

# Install julia 0.5
RUN mkdir -p /opt/julia-0.5.0 && \
    curl -s -L https://julialang.s3.amazonaws.com/bin/linux/x64/0.5/julia-0.5.0-linux-x86_64.tar.gz | tar -C /opt/julia-0.5.0 -x -z --strip-components=1 -f -
RUN ln -fs /opt/julia-0.5.0 /opt/julia-0.5

# Install julia 0.6
RUN mkdir -p /opt/julia-0.6.0-dev && \
    curl -s -L https://status.julialang.org/download/linux-x86_64 | tar -C /opt/julia-0.6.0-dev -x -z --strip-components=1 -f -
RUN ln -fs /opt/julia-0.6.0-dev /opt/julia-0.6

# Make v0.4.7 default julia
RUN ln -fs /opt/julia-0.4.7 /opt/julia

RUN echo "PATH=\"/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/opt/julia/bin\"" > /etc/environment && \
    echo "export PATH" >> /etc/environment && \
    echo "source /etc/environment" >> /root/.bashrc

RUN /opt/julia/bin/julia -e 'Pkg.add("IJulia")'
RUN /opt/julia/bin/julia -e 'Pkg.build("IJulia")'

ENTRYPOINT /bin/bash
