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
  
    t1=$(timestamp) 
    tstart=$t1 
    #calicoctl profile add $container
    tprof="$(($(timestamp)-$tstart))"

    port=$((3000+$i))  
    tstart=$(timestamp)
    $DOCKER run --name $container -tid busybox -p $port:3000 busybox httpd -f -p 3000
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

    # now test connectivity
    # this should be done differently (exploit JSON from one sinle inspect on loop above to get all values)
    # but it will do for now
    tstart=$(timestamp)
    host=$($DOCKER inspect -f {{.Node.IP}} $container)
    #host=$($DOCKER inspect -f '{{(index (index .NetworkSettings.Ports "3000/tcp") 0).HostIp}}' $container)
    echo $host
    #container_ip=$($DOCKER inspect -f {{.NetworkSettings.IPAddress}} $container)
    while ! echo exit | nc $host $port; do sleep 0.01; done
    #ssh $host ping -c 1 -w 60 $container_ip 
    tping="$(($(timestamp)-$tstart))"

    echo $t1 $i $tprof $tlaunched $trun $tping

    echo $t1 $i $tprof $tlaunched $trun $tping >> $CURR_DIR/$FILE 
  done
fi

if [ $1 = 'clean' ]; then
  for (( i=1; i<=$MAX_CONTAINERS; i++ ))
  do
    container=cont$i
    profile=$container
  
    $DOCKER rm -f $container 
    #calicoctl profile remove $container
  done
fi
 


