#!/bin/bash

source /opt/scripts/common.inc

# remove master deamon custom Spark properties file
#rm -rf ./master_conf

$SPARK_HOME/sbin/stop-master.sh
