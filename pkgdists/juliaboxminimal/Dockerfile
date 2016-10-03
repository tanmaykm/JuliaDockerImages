# Docker file for JuliaBox Minimal
# Tag: julialang/juliaboxminpkgdist
# Version:latest

FROM julialang/julia:latest

MAINTAINER Tanmay Mohapatra

# Install additional packages required for Julia packages
RUN apt-get update \
    && apt-get install -y \
    imagemagick \
    inkscape \
    pandoc \
    pdf2svg \
    hdf5-tools \
    python-sympy \
    python-numpy \
    python-scipy \
    python-matplotlib \
    glpk-utils \
    && apt-get clean

ADD texlive.profile /tmp/tl/texlive.profile
RUN cd /tmp/tl; wget http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz; \
    tar -xzf install-tl-unx.tar.gz; cd install-tl-*; \
    ./install-tl --profile=../texlive.profile; cd /; rm -rf /tmp/tl; \
    echo "export PATH=/usr/local/texlive/2014/bin/x86_64-linux:\$PATH" > /etc/profile.d/texlive.sh; \
    echo "export INFOPATH=/usr/local/texlive/2014/texmf-dist/doc/info:\$INFOPATH" >> /etc/profile.d/texlive.sh; \
    echo "export MANPATH=/usr/local/texlive/2014/texmf-dist/doc/man:\$MANPATH" >>  /etc/profile.d/texlive.sh; \
    chmod 755 /etc/profile.d/texlive.sh

ENV PATH /usr/local/texlive/2014/bin/x86_64-linux:/usr/local/bin:/usr/bin:/bin:/usr/games:/sbin:/usr/sbin

# Cairo
RUN apt-get install -y \
    gettext \
    libpango1.0-dev \
    libpango1.0-0 \
    libgvc6 \
    graphviz \
    libgraphviz-dev \
    && apt-get clean

# SymPy
RUN pip install --upgrade sympy

ENV PATH /usr/local/texlive/2014/bin/x86_64-linux:/usr/local/bin:/usr/bin:/bin:/usr/games:/sbin:/usr/sbin:/opt/julia/bin
ADD setup_julia.sh /tmp/setup_julia.sh
RUN mkdir /.juliabox
RUN /tmp/setup_julia.sh
