# Official Ubuntu Docker file for Julia
# Version:0.3.6-depsfix7-trusty

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
    imagemagick \
    inkscape \
    gettext \
    pandoc \
    pdf2svg \
    inotify-tools \
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

ADD texlive.profile /tmp/tl/texlive.profile
RUN cd /tmp/tl; wget http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz; \
    tar -xzf install-tl-unx.tar.gz; cd install-tl-*; \
    ./install-tl --profile=../texlive.profile; cd /; rm -rf /tmp/tl; \
    echo "export PATH=/usr/local/texlive/2014/bin/x86_64-linux:\$PATH" > /etc/profile.d/texlive.sh; \
    echo "export INFOPATH=/usr/local/texlive/2014/texmf-dist/doc/info:\$INFOPATH" >> /etc/profile.d/texlive.sh; \
    echo "export MANPATH=/usr/local/texlive/2014/texmf-dist/doc/man:\$MANPATH" >>  /etc/profile.d/texlive.sh; \
    chmod 755 /etc/profile.d/texlive.sh

RUN git clone --recursive https://github.com/ipython/ipython.git; cd ipython; git checkout 3.x; python setup.py install; cd ..; rm -rf ipython

RUN apt-get install -y -o Dpkg::Options::="--force-confdef" -o DPkg::Options::="--force-confold" apt-utils python-software-properties software-properties-common \
    && apt-add-repository -y ppa:staticfloat/juliareleases \
    && add-apt-repository -y ppa:staticfloat/julia-deps \
    && apt-get update \
    && apt-get install -y julia=0.3.6-depsfix7-trusty \
    && apt-get clean

ENTRYPOINT /bin/bash
