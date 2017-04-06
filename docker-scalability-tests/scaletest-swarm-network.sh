#!/bin/bash

CURR_DIR=$(cd $(dirname $0) && pwd)
source $CURR_DIR/env.rc

# Define a timestamp function
timestamp() {
   date +"%s%3N"
}

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
    network=$container-net
  
    t1=$(timestamp) 
    tstart=$t1 
    $DOCKER network create --driver overlay $network
    tprof="$(($(timestamp)-$tstart))"

    tstart=$(timestamp)
    $DOCKER run --name $container -tid --net=$network busybox httpd -f -p 80
    tlaunched="$(($(timestamp)-$tstart))"     
   
    #wait until running state
    tstart=$(timestamp)
    k=0
    skip="false"
    while [ "$($DOCKER inspect -f {{.State.Running}} $container)" != 'true' ]
    do
      echo "waiting for container $container to start"
      sleep 0.01
      if [ $k -gt 100 ]; then
        skip="true"
        break;
      fi
      k=$((k+1))
    done
    trun="$(($(timestamp)-$tstart))"   

    # now test connectivity in overlay 
    # launch 2nd container to test connectivity
    $DOCKER run --name $container-test -tid --net=$network busybox httpd -f -p 80
	
    tstart=$(timestamp)
    while ! echo exit | $DOCKER exec $container-test nc $container 80; do sleep 0.01; done
    tconn="$(($(timestamp)-$tstart))"

    # remove test container
    $DOCKER rm -f $container-test

    echo $t1 $i $tprof $tlaunched $trun $tconn

    echo $t1 $i $tprof $tlaunched $trun $tconn >> $CURR_DIR/$FILE 
  done
fi

if [ $1 = 'clean' ]; then
  for (( i=1; i<=$MAX_CONTAINERS; i++ ))
  do
    container=cont$i
    network=$container-net
  
    $DOCKER rm -f $container
    $DOCKER network rm $network
  done
fi
 


