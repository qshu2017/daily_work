#!/bin/bash

source ./scripts/common.inc

# remove history deamon custom Spark properties file
rm -rf ./history_conf

$SPARK_HOME/sbin/stop-history-server.sh