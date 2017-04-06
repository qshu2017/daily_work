#!/bin/bash



source /opt/scripts/common.inc
# to make sure Spark and EGO use the same hostname
echo "SPARK_MASTER=$1" >> /opt/spark-1.5.2-hadoop-2.6/conf/spark-env.sh
echo "SPARK_MASTER_PORT=$2" >> /opt/spark-1.5.2-hadoop-2.6/conf/spark-env.sh
echo "SPARK_MASTER_WEBUI_PORT=$3" >> /opt/spark-1.5.2-hadoop-2.6/conf/spark-env.sh
echo "SPARK_EGO_DRIVER_CONSUMER=$SPARK_EGO_DRIVER_CONSUMER" >> /opt/spark-1.5.2-hadoop-2.6/conf/spark-env.sh
echo "SPARK_EGO_EXECUTOR_CONSUMER=$SPARK_EGO_EXECUTOR_CONSUMER" >> /opt/spark-1.5.2-hadoop-2.6/conf/spark-env.sh
echo "SPARK_EGO_EXECUTOR_PLAN=$SPARK_EGO_EXECUTOR_PLAN" >> /opt/spark-1.5.2-hadoop-2.6/conf/spark-env.sh
echo "SPARK_EGO_DRIVER_PLAN=$SPARK_EGO_DRIVER_PLAN" >> /opt/spark-1.5.2-hadoop-2.6/conf/spark-env.sh

echo "spark.ego.driver.consumer $SPARK_EGO_DRIVER_CONSUMER" >> /opt/spark-1.5.2-hadoop-2.6/conf/spark-defaults.conf
echo "spark.ego.executor.consumer $SPARK_EGO_EXECUTOR_CONSUMER" >> /opt/spark-1.5.2-hadoop-2.6/conf/spark-defaults.conf
echo "spark.ego.executor.plan $SPARK_EGO_EXECUTOR_PLAN" >> /opt/spark-1.5.2-hadoop-2.6/conf/spark-defaults.conf
echo "spark.ego.driver.plan $SPARK_EGO_DRIVER_PLAN" >> /opt/spark-1.5.2-hadoop-2.6/conf/spark-defaults.conf

echo "EGO_MASTER_LIST=\"$1\"" >> /opt/conf/ego.conf
echo "EGO_KD_PORT=$4" >> /opt/conf/ego.conf
echo "EGO_LIM_PORT=$EGO_BASE_PORT" >> /opt/conf/ego.conf

cp /opt/spark-1.5.2-hadoop-2.6/conf/spark-defaults.conf /opt/master_conf/
cp /opt/spark-1.5.2-hadoop-2.6/conf/spark-env.sh /opt/shuffle_conf/
cp /opt/spark-1.5.2-hadoop-2.6/conf/spark-defaults.conf /opt/shuffle_conf/

# create a master deamon custom Spark properties file
$SPARK_HOME/sbin/start-master.sh --properties-file /opt/master_conf/spark-defaults.conf
while [ 1 ];
do
	tail -f /opt/spark-1.5.2-hadoop-2.6/sbin/../logs/spark--org.apache.spark.deploy.master.*.out
	sleep 5
done

