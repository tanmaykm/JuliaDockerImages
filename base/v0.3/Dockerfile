# Ubuntu Docker file for Julia
# Version:v0.3.8

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
    python \
    python-yaml \
    python-m2crypto \
    python-crypto \
    msgpack-python \
    python-dev \
    python-setuptools \
    supervisor \
    python-zmq \
    python-jinja2 \
    python-requests \
    python-isodate \
    python-git \
    python-pip \
    && apt-get clean

RUN git clone --recursive https://github.com/ipython/ipython.git; cd ipython; git checkout 3.x; python setup.py install; cd ..; rm -rf ipython

RUN pip install --upgrade PyDrive google-api-python-client jsonpointer jsonschema tornado sphinx pygments nose readline mistune

RUN mkdir -p /opt/julia && \
    curl -s -L https://status.julialang.org/stable/linux-x86_64 | tar -C /opt/julia -x -z --strip-components=1 -f -

RUN echo "PATH=\"/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/opt/julia/bin\"" > /etc/environment && \
    echo "export PATH" >> /etc/environment && \
    echo "source /etc/environment" >> /root/.bashrc

ENTRYPOINT /bin/bash
