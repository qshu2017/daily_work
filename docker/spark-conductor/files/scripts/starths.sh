#!/bin/bash

source ./scripts/common.inc

# default log dir, history server would start failed without log dir
# History service only available when "spark.eventLog.enabled true" in our OOB
# If "spark.eventLog.enabled true", suppose end user did configure "spark.history.fs.logDirectory" and "spark.eventLog.dir" and prepare the path
# no harm to create this default log dir anyway, if no "spark.history.fs.logDirectory" set, history service could still start.
mkdir -p /tmp/spark-events

# create a history deamon custom Spark properties file
rm -rf ./history_conf
mkdir -p ./history_conf
cp $SPARK_HOME/conf/* ./history_conf
sed -i '/spark.port.maxRetries/d' ./history_conf/spark-defaults.conf
echo "spark.port.maxRetries 0" >> ./history_conf/spark-defaults.conf

export SPARK_CONF_DIR=./history_conf

# start history service
$SPARK_HOME/sbin/start-history-server.sh
