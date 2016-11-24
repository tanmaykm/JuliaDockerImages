# Ubuntu Docker file for Julia with slurm
# Version:0.0.1

FROM ubuntu:16.04

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
    libgnutls30 \
    libzmq3-dev \
    libzmq5 \
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

# Make v0.5 default julia
RUN ln -fs /opt/julia-0.5 /opt/julia

# Setup juliarc
RUN echo '("JULIA_LOAD_CACHE_PATH" in keys(ENV)) && unshift!(Base.LOAD_CACHE_PATH, ENV["JULIA_LOAD_CACHE_PATH"])' >> /opt/julia-0.4/etc/julia/juliarc.jl
RUN echo '("JULIA_LOAD_CACHE_PATH" in keys(ENV)) && unshift!(Base.LOAD_CACHE_PATH, ENV["JULIA_LOAD_CACHE_PATH"])' >> /opt/julia-0.5/etc/julia/juliarc.jl
RUN echo '("JULIA_LOAD_CACHE_PATH" in keys(ENV)) && unshift!(Base.LOAD_CACHE_PATH, ENV["JULIA_LOAD_CACHE_PATH"])' >> /opt/julia-0.6/etc/julia/juliarc.jl

RUN echo "PATH=\"/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/opt/julia/bin\"" > /etc/environment && \
    echo "export PATH" >> /etc/environment && \
    echo "source /etc/environment" >> /root/.bashrc

ENV SLURM_VER=16.05.6

# Create users, set up SSH keys (for MPI)
RUN useradd -u 2001 -d /home/slurm slurm
RUN useradd -u 6000 -ms /bin/bash juser
ADD etc/sudoers.d/juser /etc/sudoers.d/juser
ADD home/juser/ssh/config /home/juser/.ssh/config
ADD home/juser/ssh/id_rsa /home/juser/.ssh/id_rsa
ADD home/juser/ssh/id_rsa.pub /home/juser/.ssh/id_rsa.pub
ADD home/juser/ssh/authorized_keys /home/juser/.ssh/authorized_keys
RUN chown -R juser:juser /home/juser/.ssh/
RUN chmod 400 /home/juser/.ssh/*

# Install packages
RUN apt-get update && apt-get -y  dist-upgrade
RUN apt-get install -y munge curl gcc make bzip2 supervisor python python-dev \
    libmunge-dev libmunge2 lua5.3 lua5.3-dev libopenmpi-dev openmpi-bin \
    gfortran vim python-mpi4py python-numpy python-psutil sudo psmisc \
    software-properties-common python-software-properties iputils-ping \
    openssh-server openssh-client

# Download, compile and install SLURM
RUN curl -fsL http://www.schedmd.com/download/total/slurm-${SLURM_VER}.tar.bz2 | tar xfj - -C /opt/ && \
    cd /opt/slurm-${SLURM_VER}/ && \
    ./configure && make && make install
ADD etc/slurm/slurm.conf /usr/local/etc/slurm.conf

# Configure OpenSSH
# Also see: https://docs.docker.com/engine/examples/running_ssh_service/
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile
RUN mkdir /var/run/sshd
RUN echo 'juser:juser' | chpasswd
# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
ADD etc/supervisord.d/sshd.conf /etc/supervisor/conf.d/sshd.conf

# Configure munge (for SLURM authentication)
ADD etc/munge/munge.key /etc/munge/munge.key
RUN mkdir /var/run/munge && \
    chown root /var/lib/munge && \
    chown root /etc/munge && chmod 600 /var/run/munge && \
    chmod 755  /run/munge && \
    chmod 600 /etc/munge/munge.key
ADD etc/supervisord.d/munged.conf /etc/supervisor/conf.d/munged.conf

RUN /opt/julia/bin/julia -e 'Pkg.clone("https://github.com/JuliaParallel/Slurm.jl.git")'
RUN /opt/julia/bin/julia -e 'Pkg.add("IJulia")'
RUN /opt/julia/bin/julia -e 'Pkg.build("IJulia")'
RUN /opt/julia/bin/julia -e 'import IJulia; import Slurm'

EXPOSE 22
