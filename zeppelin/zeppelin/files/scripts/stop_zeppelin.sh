#!/bin/bash

source ./scripts/common.inc

export DATADIR=$NOTEBOOK_DATA_DIR

export DEPLOY_UNTAR_TOP=$NOTEBOOK_DEPLOY_DIR/zeppelin-0.5.0-incubating-bin-spark-1.4.0_hadoop-2.3/zeppelin-0.5.0-incubating/

$DEPLOY_UNTAR_TOP/bin/zeppelin-daemon.sh --config $DATADIR/conf/ stop

PORT_FILE=$DATADIR/ports
k=1
while read line;do
portarray[k]=$line
((k++))
done < $PORT_FILE

rm -rf $NOTEBOOK_PORT_LOCK_PATH/${portarray[1]}
rm -rf $NOTEBOOK_PORT_LOCK_PATH/${portarray[2]}

kill -9 $EGO_ACTIVITY_PID
sleep 20s
