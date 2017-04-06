#marathon 0.10


#Execute build script to start deploy marathon docker image


#Start the marathon 
```
root@mesos1:~# docker  run --net=host -d hchenxa1986/marathon /opt/bin/start --master mesos1.eng.platformlab.ibm.com:5050 --zk zk://mesos1.eng.platformlab.ibm.com:2181/marathon
```

## Testing
You can use your browser to open the marathon GUI by 8080 port
