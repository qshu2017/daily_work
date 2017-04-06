#!/bin/bash

source ./scripts/common.inc

if [ -n "$SPARK_UPDATE_PARAMETER" ]; then
    exit 0
fi

# remove recovery directory since currently it only support local disk and NFS.
RECOVERY_DIR=`grep "spark.deploy.recoveryDirectory" $SPARK_HOME/conf/spark-defaults.conf | awk '{print $2}'`
if [ "$RECOVERY_DIR" != "" ]; then
    RECOVERY_DIR_VALUE="$RECOVERY_DIR/""$APP_UUID"
    rm -rf $RECOVERY_DIR_VALUE
fi

rm -rf $DEPLOY_HOME

# remove folder of SPARK_EGO_LOG_DIR
if [ -n "$SPARK_EGO_LOG_DIR_ROOT"  ]; then
    if [ -n "$APP_UUID"  ]; then
        SPARK_EGO_LOG_DIR_VALUE="$SPARK_EGO_LOG_DIR_ROOT/""$APP_UUID""*"
        rm -rf $SPARK_EGO_LOG_DIR_VALUE
    fi
fi

