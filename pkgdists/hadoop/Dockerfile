# Ubuntu Docker file for Julia with Hadoop
# Version:v0.4.6

FROM julialang/julia:v0.4.6

MAINTAINER Tanmay Mohapatra

RUN apt-get update \
    && apt-get upgrade -y -o Dpkg::Options::="--force-confdef" -o DPkg::Options::="--force-confold" \
    && apt-get install -y \
    ssh \
    openjdk-7-jdk \
    iputils-ping \
    daemontools \
    libssl-dev \
    && apt-get clean

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
RUN mkdir /data
#ADD hadoop-2.7.1.tar.gz /hadoop
RUN mkdir /hadoop \
    && cd /hadoop \
    && wget http://apache.cs.utah.edu/hadoop/common/hadoop-2.7.1/hadoop-2.7.1.tar.gz \
    && tar -xzf hadoop-2.7.1.tar.gz

ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/hadoop/hadoop-2.7.1/bin
ENV HADOOP_PREFIX /hadoop/hadoop-2.7.1
ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64
ENV LD_LIBRARY_PATH /hadoop/hadoop-2.7.1/lib/native:/usr/lib/jvm/java-7-openjdk-amd64/jre/lib/amd64/server
ENV USER root

ADD setenv.sh /hadoop/setenv.sh
ADD start.sh /hadoop/start.sh
RUN echo ". /hadoop/setenv.sh" >> ~/.bashrc
RUN echo ". /hadoop/setenv.sh" >> /hadoop/hadoop-2.7.1/etc/hadoop/hadoop-env.sh

ADD configs /hadoop/configs

# setup spark
RUN apt-get install libatlas3-base libopenblas-base

#ADD spark-1.6.2-bin-hadoop2.6.tgz /spark
RUN mkdir /spark \
    && cd /spark \
    && wget http://www-us.apache.org/dist/spark/spark-1.6.2/spark-1.6.2-bin-hadoop2.6.tgz \
    && tar -xzvf spark-1.6.2-bin-hadoop2.6.tgz

ENV SPARK_HOME /spark/spark-1.6.2-bin-hadoop2.6

# setup hive
#ADD apache-hive-1.2.1-bin.tar.gz /hive
RUN mkdir /hive \
    && cd /hive \
    && wget http://www-us.apache.org/dist/hive/hive-1.2.1/apache-hive-1.2.1-bin.tar.gz \
    && tar -xzvf apache-hive-1.2.1-bin.tar.gz

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

# SPARK ports
EXPOSE 8080 7077


ENTRYPOINT /bin/bash
