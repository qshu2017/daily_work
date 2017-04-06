#!/bin/bash

source /opt/scripts/common.inc

# create a shuffle deamon custom Spark properties file
#rm -rf ./shuffle_conf
#mkdir -p ./shuffle_conf
#cp $SPARK_HOME/conf/* ./shuffle_conf
#sed -i '/spark.port.maxRetries/d' ./shuffle_conf/spark-defaults.conf
#echo "spark.port.maxRetries 0" >> ./shuffle_conf/spark-defaults.conf
export SPARK_CONF_DIR=/opt/shuffle_conf

echo "SPARK_MASTER=$1" >> /opt/spark-1.5.2-hadoop-2.6/conf/spark-env.sh
echo "SPARK_EGO_DRIVER_CONSUMER=$SPARK_EGO_DRIVER_CONSUMER" >> /opt/spark-1.5.2-hadoop-2.6/conf/spark-env.sh
echo "SPARK_EGO_EXECUTOR_CONSUMER=$SPARK_EGO_EXECUTOR_CONSUMER" >> /opt/spark-1.5.2-hadoop-2.6/conf/spark-env.sh
echo "SPARK_EGO_EXECUTOR_PLAN=$SPARK_EGO_EXECUTOR_PLAN" >> /opt/spark-1.5.2-hadoop-2.6/conf/spark-env.sh
echo "SPARK_EGO_DRIVER_PLAN=$SPARK_EGO_DRIVER_PLAN" >> /opt/spark-1.5.2-hadoop-2.6/conf/spark-env.sh

echo "spark.ego.driver.consumer $SPARK_EGO_DRIVER_CONSUMER" >> /opt/spark-1.5.2-hadoop-2.6/conf/spark-defaults.conf
echo "spark.ego.executor.consumer $SPARK_EGO_EXECUTOR_CONSUMER" >> /opt/spark-1.5.2-hadoop-2.6/conf/spark-defaults.conf
echo "spark.ego.executor.plan $SPARK_EGO_EXECUTOR_PLAN" >> /opt/spark-1.5.2-hadoop-2.6/conf/spark-defaults.conf
echo "spark.ego.driver.plan $SPARK_EGO_DRIVER_PLAN" >> /opt/spark-1.5.2-hadoop-2.6/conf/spark-defaults.conf

echo "EGO_MASTER_LIST=\"$1\"" >> /opt/conf/ego.conf
echo "EGO_KD_PORT=$2" >> /opt/conf/ego.conf
echo "EGO_LIM_PORT=$EGO_BASE_PORT" >> /opt/conf/ego.conf

cp /opt/spark-1.5.2-hadoop-2.6/conf/spark-defaults.conf /opt/master_conf/
cp /opt/spark-1.5.2-hadoop-2.6/conf/spark-env.sh /opt/shuffle_conf/
cp /opt/spark-1.5.2-hadoop-2.6/conf/spark-defaults.conf /opt/shuffle_conf/

$SPARK_HOME/bin/spark-class org.apache.spark.deploy.ego.EGOShuffleService
