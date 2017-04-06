<<<<<<< HEAD
#mesos-ego


#build asc docker image
```
bash build
```


#Start asc
```
docker run asc:1.1 --privileged --net=host -d asc:1.1
```

#Start mesos-ego
```
root@mesos1:~# docker  run --net=host -e "MASTER_HOST=<asc_hostname>" -e "RESPLAN=<asc_mds_resplan_name>" -d mesos-egomaster:latest  --zk zk://mesos1.eng.platformlab.ibm.com:2181/mesos --quorum=1
```
=======
#Mesos-EGO based on mesos 0.27.0



#Build the images
If you want to build directly from the Dockerfile, you can build the images as for each mesos component:
```
./build 
```

Start ASC Master
```
root@mesos1:~# docker run  --privileged --net=host -d platform-asc:1.1.1
21c62b4786e37639de6b0c76a3b8146348e2bebb03e5fb985f25b4d4d1615c94

```
After the ASC service startup, Startup the mesos-master with ego allocator:
```
root@mesos1:~# docker run --privileged --net=host --volumes-from ${ASC_CONTAINER_ID} -e "MASTER_HOST=${ASC_MASTER_HOSTNAME}" -e "RESPLAN=${MDS_RESPLAN_NAME}" -d mesos-egomaster:test --zk=zk://${ZOOKEEPER_HOSTNAME}:2181/mesos --quorum=1
67d9e5ecb5f0be69cf8906dab822b2b3b51fd3cd7bac9e0677015391f5d72f46

```

Start the Mesos-slave and ASC Compute

1) Start the mesos-slave:
```
root@mesos2:/opt/docker/mesos-ego/mesos-slave# docker  run --privileged --net=host --pid=host --volume=/:/rootfs:ro --volume=/sys:/sys:ro --volume=/dev:/dev --volume=/var/lib/docker/:/var/lib/docker:rw --volume=/var/run:/var/run:rw -d mesos-slave:0.27.0 --master=zk://${ZOOKEEPTER_HOSTNAME}:2181/mesos 
498c9729b1ac7625cea285ee06701206f7efe55d3918556e4bef3f82618c2d5b
```


2) Start the ASC Compute:
```
root@mesos2:/opt/docker/mesos-ego/asc# docker  run --net=host --privileged -e "MASTER_HOST=${ASC_MASTER_HOSTNAME}" -d platform-asc:1.1.1
9fe0d0979c29ca65b84a829e5cbb832c67cad7d24e75be1fdf3bb467829fe128

```


Where:

${ASC_CONTAINER_ID}: is the container ID of ASC master.

${ASC_MASTER_HOSTNAME}: is the hostname of ASC master.

${MDS_RESPLAN_NAME}: is the asc mds resplan name which used for mesos-ego allocator.

${ZOOKEEPTER_HOSTNAME}: is the zookeeper hostname
>>>>>>> 8fb06469459d7c15a07a56c034d59a17136adfcf
