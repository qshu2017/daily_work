#!/bin/bash

[ $# -lt 2 ]&& echo "Usage:./$0 <number of app> <create/delete>"

CURR_DIR=`pwd`


# Define a timestamp function
timestamp() {
   date +"%s%3N"
}


KUBECTL="kubectl -s http://9.21.53.15:8888"
MAX_CONTAINERS=$1

if [ $2 = 'create' ]; then
  fstart=$(timestamp)
  $KUBECTL run $container --image=nginx:latest --requests="cpu=50m,memory=50Mi" --image-pull-policy="IfNotPresent" --replicas=$MAX_CONTAINERS nginx
  tlaunched="$(($(timestamp)-$fstart))"
  echo "the create get response within $tlaunched time"
    #wait until running state
    echo "Start check the pods status"
    tstart=$(timestamp)
    while : ; do
      running_pods=`kubectl -s http://9.21.53.15:8888 get pods | grep Running| wc -l`
      if [ $running_pods == $MAX_CONTAINERS ]; then
    trun="$(($(timestamp)-$tstart))"
        echo $running_pods $trun >> $CURR_DIR/result_${MAX_CONTAINERS}.txt
    break
      fi
      trun="$(($(timestamp)-$tstart))"
      echo $running_pods $trun >> $CURR_DIR/result_${MAX_CONTAINERS}.txt
      sleep 0.1
    done
fi
