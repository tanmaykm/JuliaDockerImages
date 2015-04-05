export HADOOP_PREFIX=/hadoop/hadoop-2.6.0

export HADOOP_HOME=$HADOOP_PREFIX  
export HADOOP_MAPRED_HOME=$HADOOP_PREFIX  
export HADOOP_COMMON_HOME=$HADOOP_PREFIX  
export HADOOP_HDFS_HOME=$HADOOP_PREFIX
export HADOOP_CONF_DIR=$HADOOP_PREFIX/etc/hadoop   
export YARN_HOME=$HADOOP_PREFIX
export YARN_CONF_DIR=$HADOOP_PREFIX/etc/hadoop

export PATH=$PATH:$HADOOP_PREFIX/bin:$HADOOP_PREFIX/sbin
export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HADOOP_PREFIX/lib/native:$JAVA_HOME/jre/lib/amd64/server

CLASSPATH1=$(JARS=("$HADOOP_PREFIX"/share/hadoop/common/*.jar); IFS=:; echo "${JARS[*]}")
CLASSPATH2=$(JARS=("$HADOOP_PREFIX"/share/hadoop/common/lib/*.jar); IFS=:; echo "${JARS[*]}")
CLASSPATH3=$(JARS=("$HADOOP_PREFIX"/share/hadoop/hdfs/*.jar); IFS=:; echo "${JARS[*]}")
CLASSPATH4=$(JARS=("$HADOOP_PREFIX"/share/hadoop/hdfs/lib/*.jar); IFS=:; echo "${JARS[*]}")
CLASSPATH5=$(JARS=("$HADOOP_PREFIX"/share/hadoop/tools/lib/*.jar); IFS=:; echo "${JARS[*]}")
export CLASSPATH=${CLASSPATH1}:${CLASSPATH2}:${CLASSPATH3}:${CLASSPATH4}:${CLASSPATH}
