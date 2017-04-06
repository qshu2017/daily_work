#!/bin/bash


function create_spark_directories() {
    rm -rf /root/.ssh
    mkdir /root/.ssh
    chmod go-rx /root/.ssh
    mkdir /var/run/sshd

    rm -rf /opt/spark-$SPARK_VERSION/work
    mkdir -p /opt/spark-$SPARK_VERSION/work
    #chown hdfs.hdfs /opt/spark-$SPARK_VERSION/work
    mkdir /tmp/spark
    #chown hdfs.hdfs /tmp/spark
    # this one is for Spark shell logging
    rm -rf /opt/spark-$SPARK_VERSION/logs
    mkdir -p /opt/spark-$SPARK_VERSION/logs
    #chown hdfs.hdfs /opt/spark-$SPARK_VERSION/logs
}

function deploy_spark_files() {
    cp /root/config_files/id_rsa /root/.ssh
    chmod go-rwx /root/.ssh/id_rsa
    cp /root/config_files/authorized_keys /root/.ssh/authorized_keys
    chmod go-wx /root/.ssh/authorized_keys

    cp /root/spark_files/spark-env.sh /opt/spark-$SPARK_VERSION/conf/
    cp /root/spark_files/log4j.properties /opt/spark-$SPARK_VERSION/conf/
}		

function configure_spark() {
    sed -i s/__MASTER__/$1/ /opt/spark-$SPARK_VERSION/conf/spark-env.sh
    sed -i s/__MASTER_PORT__/$3/ /opt/spark-$SPARK_VERSION/conf/spark-env.sh
    #sed -i s/__MASTER__/master/ /opt/spark-$SPARK_VERSION/conf/spark-env.sh
    sed -i s/__SPARK_HOME__/"\/opt\/spark-${SPARK_VERSION}"/ /opt/spark-$SPARK_VERSION/conf/spark-env.sh
    sed -i s/__JAVA_HOME__/"\/usr\/lib\/jvm\/jre-1.7.0-openjdk"/ /opt/spark-$SPARK_VERSION/conf/spark-env.sh
    echo "export SPARK_MASTER_WEBUI_PORT=$2" >> /opt/spark-$SPARK_VERSION/conf/spark-env.sh
    echo "export SPARK_MASTER_PORT=$3" >> /opt/spark-$SPARK_VERSION/conf/spark-env.sh
    echo "export SPARK_WORKER_PORT=$4" >> /opt/spark-$SPARK_VERSION/conf/spark-env.sh
    echo "export SPARK_WORKER_WEBUI_PORT=$5" >> /opt/spark-$SPARK_VERSION/conf/spark-env.sh
    if [ ! $6 = "default" ] ; then
        echo "export SPARK_WORKER_CORES=$6" >> /opt/spark-$SPARK_VERSION/conf/spark-env.sh
    fi
    if [ ! $7 = "default" ] ; then
        echo "export SPARK_WORKER_MEMORY=$7" >> /opt/spark-$SPARK_VERSION/conf/spark-env.sh
    fi
    if [ ! $8 = "default" ] ; then
        echo "export SPARK_DAEMON_MEMORY=$8" >> /opt/spark-$SPARK_VERSION/conf/spark-env.sh
    fi
}

function prepare_spark() {
    create_spark_directories
    deploy_spark_files
    configure_spark $1 $2 $3 $4 $5 $6 $7 $8
}

