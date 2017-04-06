#!/bin/bash

# User should specify DEPLOY_HOME where spark would be deployed. 
if [ -z "$DEPLOY_HOME" ]; then
    export DEPLOY_HOME=/var/conductor/auto/Spark1.5.2
    echo "no DEPLOY_HOME set"
fi
echo "DEPLOY_HOME ready"
export SPARK_HOME=$DEPLOY_HOME/spark-1.5.2-hadoop-2.6
