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
    ssh \
    openjdk-7-jdk \
    dnsmasq \
    iputils-ping \
    daemontools \
    libssl-dev \
    && apt-get clean

# setup julia
RUN mkdir -p /opt/julia && \
    curl -s -L https://status.julialang.org/stable/linux-x86_64 | tar -C /opt/julia -x -z --strip-components=1 -f -

RUN echo "PATH=\"/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/opt/julia/bin\"" > /etc/environment && \
    echo "export PATH" >> /etc/environment && \
    echo "source /etc/environment" >> /root/.bashrc

# setup dnsmasq
ADD dnsmasq/dnsmasq.conf /etc/dnsmasq.conf
ADD dnsmasq/resolv.dnsmasq.conf /etc/resolv.dnsmasq.conf

# setup serf
RUN wget https://dl.bintray.com/mitchellh/serf/0.6.4_linux_amd64.zip \
    && unzip 0.6.4_linux_amd64.zip \
    && mv serf /bin \
    && rm 0.6.4_linux_amd64.zip
ADD serf /etc/serf
ENV SERF_CONFIG_DIR /etc/serf

# configure service startups
RUN mkdir -p /var/run/sshd
ADD svc /etc/service

# setup hduser to run hadoop
RUN addgroup hadoop
RUN useradd -d /home/juser -m -s /bin/bash -G hadoop juser

# setup ssh keys for passwordless login
ADD ssh_config /tmp/ssh_config
RUN ssh-keygen -t rsa -f ~/.ssh/id_rsa -P '' \
    && cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys \
    && cp /tmp/ssh_config ~/.ssh/config \
    && rm /tmp/ssh_config

# setup hadoop
RUN mkdir /hadoop \
    && mkdir /data \
    && cd /hadoop \
    && wget http://apache.cs.utah.edu/hadoop/common/hadoop-2.6.0/hadoop-2.6.0.tar.gz \
    && tar -xzf hadoop-2.6.0.tar.gz

ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/hadoop/hadoop-2.6.0/bin
ENV HADOOP_PREFIX /hadoop/hadoop-2.6.0
ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64
ENV LD_LIBRARY_PATH /hadoop/hadoop-2.6.0/lib/native:/usr/lib/jvm/java-7-openjdk-amd64/jre/lib/amd64/server
ENV USER root

ADD setenv.sh /hadoop/setenv.sh
ADD onslaves.sh /hadoop/onslaves.sh
ADD start.sh /hadoop/start.sh
RUN echo ". /hadoop/setenv.sh" >> ~/.bashrc
RUN echo ". /hadoop/setenv.sh" >> /hadoop/hadoop-2.6.0/etc/hadoop/hadoop-env.sh

ADD configs /hadoop/configs

# install julia hadoop packages
ENV PATH /usr/local/texlive/2014/bin/x86_64-linux:/usr/local/bin:/usr/bin:/bin:/usr/games:/sbin:/usr/sbin:/opt/julia/bin
ADD setup_julia.sh /tmp/setup_julia.sh
RUN /tmp/setup_julia.sh

# SSH and SERF ports
EXPOSE 22 7373 7946 

# HDFS ports
EXPOSE 9000 50010 50020 50070 50075 50090 50475

# YARN ports
EXPOSE 8030 8031 8032 8033 8040 8042 8060 8088 50060


ENTRYPOINT /bin/bash
