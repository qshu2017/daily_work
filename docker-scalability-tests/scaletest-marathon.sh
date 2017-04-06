#!/bin/bash

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

#rm $CURR_DIR/$FILE

if [ -z "$1" ]; then
  echo "usage: $0 <command> "
  echo "    where: <command> = run | clean"
  exit
fi

if [ $1 = 'run' ]; then
  for (( i=1; i<=$MAX_TENANTS; i++ )) 
  do
    container=cont$i
    profile=$container
  
    t1=$(timestamp) 
    tstart=$t1 
    #calicoctl profile add $container
    tprof="$(($(timestamp)-$tstart))"

    port=$((10000+$i)) 
    cp $CURR_DIR/app-data/marathon-app.json.template $CURR_DIR/app-data/marathon-app.json
    sed -i "s/APP_ID/$container/g" $CURR_DIR/app-data/marathon-app.json
    sed -i "s/_PORT_/$port/g" $CURR_DIR/app-data/marathon-app.json
    tstart=$(timestamp)
    curl -i -H 'Content-Type: application/json' -d @$CURR_DIR/app-data/marathon-app.json http://$MANAGER_IP:$MARATHON_PORT/v2/apps   
    if [ $? -ne 0 ]; then
      echo "ERROR: marathon start app request failed, stopping test"
      exit
    fi
    tlaunched="$(($(timestamp)-$tstart))"    

    #wait until running state
    tstart=$(timestamp)
    k=0
    skip="false"
    echo "waiting for container $container to start...."
    while [ -z "$(curl -i -silent -H 'Content-Type: application/json' http://$MANAGER_IP:$MARATHON_PORT/v2/apps/$container | grep '"tasksRunning":1')" ]
    do
      sleep 0.025
      if [ $k -gt 10000 ]; then
         skip="true"
         break;
      fi
      k=$((k+1))
    done
    trun="$(($(timestamp)-$tstart))"   

    if [ skip = "true" ]; then
	echo "skipping to next container"
	continue
    fi

    # now test connectivity
    port=$(curl -sb -silent -H 'Content-Type: application/json' http://$MANAGER_IP:$MARATHON_PORT/v2/apps/$container | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["app"]["tasks"][0]["ports"][0]')
    host=$(curl -sb -silent -H 'Content-Type: application/json' http://$MANAGER_IP:$MARATHON_PORT/v2/apps/$container | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["app"]["tasks"][0]["host"]')
    echo "trying to connect to $host:$port"
    tstart=$(timestamp)
   # while ! echo exit | nc $host $port; do sleep 0.01; done
    tping="$(($(timestamp)-$tstart))"

    echo $t1 $i $tprof $tlaunched $trun $tping

    echo $t1 $i $tprof $tlaunched $trun $tping >> $CURR_DIR/$FILE 
done
fi

if [ $1 = 'clean' ]; then
  for (( i=1; i<=$MAX_TENANTS; i++ ))
  do
    container=cont$i
    profile=$container
    curl -X DELETE -sb -H 'Content-Type: application/json' http://$MANAGER_IP:$MARATHON_PORT/v2/apps/$container 
  done
fi
 


