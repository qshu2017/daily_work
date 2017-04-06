#!/bin/bash

CURR_DIR=$(cd $(dirname $0) && pwd)
source $CURR_DIR/env.rc
PID_FILE=$CURR_DIR/.pids

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

if [ -z "$1" ]; then
  echo "usage: $0 <command> "
  echo "    where: <command> = run | clean"
  exit
fi

if [ $1 = 'run' ]; then
  if [ -s $PID_FILE ]; then
   rm $PID_FILE
  fi
  for (( i=1; i<=$MAX_CONTAINERS; i++ )) 
  do
    container=cont$i
    profile=$container
  
    t1=$(timestamp) 
    tstart=$t1 
    tprof="$(($(timestamp)-$tstart))"
  
    port=$((3000+$i))
    sed -i "s/3000/$port/g" $CURR_DIR/config.json
    tstart=$(timestamp)
    runc --id $container start &
    tlaunched="$(($(timestamp)-$tstart))"     
    echo $! >> $PID_FILE

    tstart=$(timestamp)
    host=$MANAGER_IP
    while ! echo exit | nc $host $port; do sleep 0.01; done
    trun="$(($(timestamp)-$tstart))"
    sed -i "s/$port/3000/g" $CURR_DIR/config.json
    tping=0

    echo $t1 $i $tprof $tlaunched $trun $tping

    echo $t1 $i $tprof $tlaunched $trun $tping >> $CURR_DIR/$FILE 
  done
fi

if [ $1 = 'clean' ]; then
  i=1
  while IFS='' read -r pid || [[ -n "$pid" ]]; do
    container=cont$i
    runc --id $container kill 
    #kill -9 $pid
    # cleanup cgroups since the kill does not do it and the floatsam stays around
    cgdelete hugetlb:/user/1000.user/1.session/$container 2>/dev/null
    cgdelete perf_event:/user/1000.user/1.session/$container 2>/dev/null
    cgdelete blkio:/user/1000.user/1.session/$container 2>/dev/null
    cgdelete freezer:/user/1000.user/1.session/$container 2>/dev/null
    cgdelete devices:/user/1000.user/1.session/$container 2>/dev/null
    cgdelete memory:/user/1000.user/1.session/$container 2>/dev/null
    cgdelete cpu:/user/1000.user/1.session/$container 2>/dev/null
    cgdelete cpuacct:/user/1000.user/1.session/$container 2>/dev/null
    cgdelete cpuset:/user/1000.user/1.session/$container 2>/dev/null
    rm -r /var/run/opencontainer/containers/$container 2>/dev/null
    i=$(($i+1))
  done < "$PID_FILE"
  # cleanup leftover httpd processes
  kill -9 $(ps aux | grep 'httpd' | awk '{print $2}') 2>/dev/null
fi


