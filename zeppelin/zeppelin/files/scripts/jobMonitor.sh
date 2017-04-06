#!/bin/bash

source ./scripts/common.inc
sleep 5s

export DATADIR=$NOTEBOOK_DATA_DIR
export DEPLOY_UNTAR_TOP=$NOTEBOOK_DEPLOY_DIR/zeppelin-0.5.0-incubating-bin-spark-1.4.0_hadoop-2.3/zeppelin-0.5.0-incubating
PORT_FILE=$DATADIR/ports

read port < $PORT_FILE
portcheck=0

while [ 1 ]
do
        sleep 3
        $DEPLOY_UNTAR_TOP/bin/zeppelin-daemon.sh --config $DATADIR/conf/ status
        if [ $? -eq 0 ] ;then
                read pidnum < $DATADIR/run/zeppelin-$SPARK_EGO_USER-*
                netstat -antup|grep $pidnum |grep $port
                if [ $? -eq 0 ] ;then
                        URL=http://$EGOSC_INSTANCE_HOST:$port
                        echo "UPDATE_INFO '$URL'"
                        echo "UPDATE_STATE 'READY'"
                        echo "END"
                else
                        if [ $portcheck -lt 100 ] ;then
                                let portcheck++
                                echo "UPDATE_STATE 'TENTATIVE'"
                        else
                                k=1
                                while read line;do
                                portarray[k]=$line
                                ((k++))
                                done < $PORT_FILE

                                rm -rf $NOTEBOOK_PORT_LOCK_PATH/${portarray[1]}
                                rm -rf $NOTEBOOK_PORT_LOCK_PATH/${portarray[2]}

                                echo "UPDATE_STATE 'ERROR'"
                        fi
                fi
        else
           echo "UPDATE_STATE 'TENTATIVE'"
        fi
done
