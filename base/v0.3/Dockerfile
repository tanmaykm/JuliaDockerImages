# Ubuntu Docker file for Julia
# Version:v0.3.12

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

RUN git clone --recursive --branch 3.x https://github.com/ipython/ipython.git; cd ipython; python setup.py install; cd ..; rm -rf ipython

RUN mkdir -p /opt/julia_0.3.12 && \
    curl -s -L https://julialang.s3.amazonaws.com/bin/linux/x64/0.3/julia-0.3.12-linux-x86_64.tar.gz | tar -C /opt/julia_0.3.12 -x -z --strip-components=1 -f -

RUN ln -fs /opt/julia_0.3.12 /opt/julia

RUN echo "PATH=\"/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/opt/julia/bin\"" > /etc/environment && \
    echo "export PATH" >> /etc/environment && \
    echo "source /etc/environment" >> /root/.bashrc

RUN /opt/julia/bin/julia -e 'Pkg.add("IJulia")'

ENTRYPOINT /bin/bash
