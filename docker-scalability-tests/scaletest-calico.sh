#!/bin/bash
# this file was written to work with Calico

CURR_DIR=$(cd $(dirname $0) && pwd)
source $CURR_DIR/env.rc

# Define a timestamp function
timestamp() {
  date +"%s"
}

gen_ip(){
  i=$1
  j=$((i / 256 ))
  k=$((i - 256*j))
  echo 192.168.$j.$k
}

rm $CURR_DIR/$FILE

DOCKER="docker -H $MANAGER_IP:$MANAGER_PORT"

if [ -z "$1" ]; then
  echo "usage: $0 <command> "
  echo "    where: <command> = run | clean"
  exit
fi

if [ $1 = 'run' ]; then
  for (( i=1; i<=$MAX_CONTAINERS; i++ )) 
  do
    container=cont$i
    profile=$container
  
    tstart=$(timestamp)  
    calicoctl profile add $container
    tprof="$(($(timestamp)-$tstart))"
  
    tstart=$(timestamp)
    $DOCKER run -e CALICO_IP=$(gen_ip $i) -e CALICO_PROFILE=$profile --name $container -tid busybox  
    # wait until running state
    while [ $($DOCKER inspect -f {{.State.Running}} $container) = 'false'  ]
    do
      sleep 1
    done

    trun="$(($(timestamp)-$tstart))"   

    # now add a new container in the same profile to test connectivity
    k=$((i+1))
    $DOCKER run -e CALICO_IP=$(gen_ip $k) -e CALICO_PROFILE=$profile --name test$container -tid busybox  

    # now test connectivity
    tstart=$(timestamp)
    $DOCKER exec test$container ping -c 1 -w 60 $(gen_ip $i) 
    tping="$(($(timestamp)-$tstart))"

    # now delete extra container
    $DOCKER rm -f test$container 

    echo $tstart $i $tprof $trun $tping

    echo $tstart $i $tprof $trun $tping >> $CURR_DIR/$FILE 
  done
fi

if [ $1 = 'clean' ]; then
  for (( i=1; i<=$MAX_CONTAINERS; i++ ))
  do
    container=cont$i
    profile=$container
  
    $DOCKER rm -f $container 
    calicoctl profile remove $container
  done
fi

