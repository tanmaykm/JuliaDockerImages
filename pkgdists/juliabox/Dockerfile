# Docker file for JuliaBox
# Tag: tanmaykm/juliaboxpkgdist
# Version:v0.3.6_build_1

FROM tanmaykm/julia:v0.3.6

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
    libnlopt0 \
    && apt-get clean

ADD texlive.profile /tmp/tl/texlive.profile
RUN cd /tmp/tl; wget http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz; \
    tar -xzf install-tl-unx.tar.gz; cd install-tl-*; \
    ./install-tl --profile=../texlive.profile; cd /; rm -rf /tmp/tl; \
    echo "export PATH=/usr/local/texlive/2014/bin/x86_64-linux:\$PATH" > /etc/profile.d/texlive.sh; \
    echo "export INFOPATH=/usr/local/texlive/2014/texmf-dist/doc/info:\$INFOPATH" >> /etc/profile.d/texlive.sh; \
    echo "export MANPATH=/usr/local/texlive/2014/texmf-dist/doc/man:\$MANPATH" >>  /etc/profile.d/texlive.sh; \
    chmod 755 /etc/profile.d/texlive.sh

# Sundials
RUN apt-get install -y \
    libsundials-cvode1 \
    libsundials-cvodes2 \
    libsundials-ida2 \
    libsundials-idas0 \
    libsundials-kinsol1 \
    libsundials-nvecserial0 \
    libsundials-serial \
    libsundials-serial-dev \
    && apt-get clean

# NLopt
RUN apt-get install -y \
    libnlopt-dev \
    && apt-get clean

# Ipopt
RUN mkdir ipopt; cd ipopt; wget  http://www.coin-or.org/download/source/Ipopt/Ipopt-3.11.7.tgz; \
    tar -xzf Ipopt-3.11.7.tgz; cd Ipopt-3.11.7; \
    cd ThirdParty/Blas; ./get.Blas; ./configure --prefix=/usr/local --disable-shared --with-pic; make install; cd ../..; \
    cd ThirdParty/Lapack; ./get.Lapack; ./configure --prefix=/usr/local --disable-shared --with-pic; make install; cd ../..; \
    cd ThirdParty/Mumps; ./get.Mumps; cd ../..; \
    ./configure --prefix=/usr/local --enable-dependency-linking --with-blas=/usr/local/lib/libcoinblas.a --with-lapack=/usr/local/lib/libcoinlapack.a; \
    make install; \
    echo "/usr/local/lib" > /etc/ld.so.conf.d/ipopt.conf; ldconfig; \
    cd ../..; \
    rm -rf ipopt

# Cbc
RUN mkdir cbc; cd cbc; wget http://www.coin-or.org/download/source/Cbc/Cbc-2.8.12.tgz; \
    tar -xzf Cbc-2.8.12.tgz; cd Cbc-2.8.12; \
    ./configure --prefix=/usr/local --enable-dependency-linking --without-blas --without-lapack --enable-cbc-parallel; \
    make install; \
    echo "/usr/local/lib" > /etc/ld.so.conf.d/cbc.conf; ldconfig; \
    cd ../..; \
    rm -rf cbc

# MPI
RUN apt-get install -y \
    openmpi-bin \
    libopenmpi-dev \
    && apt-get clean

# Stan
RUN mkdir stan; cd stan; wget https://github.com/stan-dev/cmdstan/releases/download/v2.5.0/cmdstan-2.5.0.tar.gz; \
    tar -xzvf cmdstan-2.5.0.tar.gz; mv cmdstan /usr/share/cmdstan; \
    (cd /usr/share/cmdstan && make build); \
    echo "export CMDSTAN_HOME=/usr/share/cmdstan" > /etc/profile.d/cmdstan.sh; \
    chmod 755 /etc/profile.d/cmdstan.sh; \
    cd ..; \
    rm -rf stan

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

# Nemo
RUN apt-get install -y \
    m4 \
    && apt-get clean

# SymPy
RUN pip install --upgrade sympy

RUN mkdir mpir; cd mpir; wget http://mpir.org/mpir-2.7.0-alpha11.tar.bz2; \
    tar -xvf mpir-2.7.0-alpha11.tar.bz2; cd mpir-2.7.0; \
    ./configure M4=/usr/bin/m4 --enable-gmpcompat --disable-static --enable-shared; \
    make; make install; \
    cd ../..; \
    rm -rf mpir

RUN mkdir mpfr; cd mpfr; wget http://www.mpfr.org/mpfr-current/mpfr-3.1.2.tar.bz2; \
    tar -xvf mpfr-3.1.2.tar.bz2; cd mpfr-3.1.2; \
    ./configure --with-gmp=/usr/local --disable-static --enable-shared; \
    make; make install; \
    cd ../..; \
    rm -rf mpfr

RUN mkdir flint2; cd flint2; git clone https://github.com/wbhart/flint2.git; \
    cd flint2; \
    ./configure --disable-static --enable-shared --with-mpir --with-mpfr; \
    make; make install; \
    cd ../..; \
    rm -rf flint2

ADD setup_julia.sh /tmp/setup_julia.sh

RUN mkdir /.juliabox

RUN /tmp/setup_julia.sh
