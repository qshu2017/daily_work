#!/bin/bash

CURR_DIR=$(cd $(dirname $0) && pwd)
source $CURR_DIR/env.rc

# Define a timestamp function
timestamp() {
   date +"%s%3N"
}

gen_ip(){
  i=$1
  j=$((i / 256 ))
  k=$((i - 256*j))
  echo 192.168.$j.$k
}

#rm $CURR_DIR/$FILE

KUBECTL="kubectl --server $MANAGER_IP:$MANAGER_PORT"

if [ -z "$1" ]; then
  echo "usage: $0 <command> "
  echo "    where: <command> = run | clean"
  exit
fi

if [ $1 = 'run' ]; then
  for (( i=1; i<=$MAX_CONTAINERS; i++ )) 
  do
    container=cont$i

cat << EOF > test.yaml
apiVersion: v1
kind: Pod
metadata:
  name: $container
spec:
  containers:
  - name: $container
    image: gcr.io/google_containers/pause:0.8.0
    resources:
      limits:
        memory: "8Mi"
        cpu: "1m"
EOF
  
    t1=$(timestamp) 
    tstart=$t1 
    # we do not use profiles here
    tprof="$(($(timestamp)-$tstart))"

    tstart=$(timestamp)
    $KUBECTL create -f test.yaml
    tlaunched="$(($(timestamp)-$tstart))"     
   
    #wait until running state
    tstart=$(timestamp)
    while : ; do
      info=$($KUBECTL describe pod $container)
      if [ Running = $(echo "$info" | grep Status: | awk '{print $2}') ]; then 
        break
      fi
      sleep 0.5
    done
    trun="$(($(timestamp)-$tstart))"   

    echo $t1 $i $tprof $tlaunched $trun

    echo $t1 $i $tprof $tlaunched $trun >> $CURR_DIR/$FILE 
  done
fi

if [ $1 = 'clean' ]; then
  for (( i=1; i<=$MAX_CONTAINERS; i++ ))
  do
    container=cont$i
    $KUBECTL delete pod $container 
    sleep 1
  done
fi
 


