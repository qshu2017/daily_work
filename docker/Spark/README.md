#Apache Spark V1.1.0 Docker images


#Pull the basement image
docker pull ubuntu:precise

#Build the images
If you want to build directly from the Dockerfile, you can build the images as:
```
./build
```

#Start the container
```
#Start the Spark master node
docker run --net=host spark-master:1.1.0 $1 $2 $3 $4 $5 $6 $7 $8
Parameter definitions:
$1: Host name or IP of the Spark master node
$2: Web UI port of the Spark master node
$3: Port of the Spark master node
$4: Port of the Spark worker node
$5: Web UI port of the Spark worker node
$6: Total number of cores to allow the Spark applications to use on the machine. If specifying it as default, then all available cores can be used.
$7: Total amount of memory to allow the Spark applications to use on the machine, such as 1000m or 2g. If specifying it as default, use the total memory minus 1 GB.
$8: Memory to allocate to the Spark master and worker daemons themselves. If specifying it as default, use 512m.

eg: docker run --net=host spark-master:1.1.0 10.28.241.170 8080 7077 8889 8081 default default default

#Start Spark worker node (if there is not enough memory, run the Spark worker node in a different host from the Spark master node)
docker run --net=host spark-worker:1.1.0 $1 $2 $3 $4 $5 $6 $7 $8
Parameter definitions:
$1: Host name or IP of the Spark master node
$2: Web UI port of the Spark master node
$3: Port of the Spark master node
$4: Port of the Spark worker node
$5: Web UI port of the Spark worker node
$6: Total number of cores to allow the Spark applications to use on the machine. If specifying it as default, then all available cores can be used.
$7: Total amount of memory to allow the Spark applications to use on the machine, such as 1000m or 2g. If specifying it as default, use the total memory minus 1 GB.
$8: Memory to allocate to the Spark master and worker daemons themselves. If specifying it as default, use 512m.

eg: docker run --net=host spark-worker:1.1.0 10.28.241.170 8080 7077 8889 8081 default default default
(If you specified the hostname of the Spark master when starting the Spark master container, then you must specify the hostname of the Spark master as the parameter, not the IP of the Spark master;
if you specified the IP of the Spark master when starting the Spark master container, then you must specify IP of the Spark master as the parameter, not the hostname of the Spark master.)

#Start the Spark shell container
docker run --net=host spark-shell:1.1.0 $1 $2 $3 $4 $5 $6 $7 $8
Parameter definitions:
$1: Host name or IP of the Spark master node;
$2: Web UI port of the Spark master node;
$3: Port of the Spark master node;
$4: Port of the Spark worker node;
$5: Web UI port of the Spark worker node;
$6: Total number of cores to allow the Spark applications to use on the machine. If specifying it as default, then all available cores can be used.
$7: Total amount of memory to allow the Spark applications to use on the machine, such as 1000m or 2g. If specifying it as default, use the total memory minus 1 GB.
$8: Memory to allocate to the Spark master and worker daemons themselves. If specifying it as default, use 512m.

eg: docker run --rm -i -t --net=host spark-shell:1.1.0 10.28.241.170 8080 7077 8889 8081 default default default
(If you specified the hostname of the Spark master when starting the Spark master container, then you must specify the hostname of the Spark master as the parameter, not the IP of the Spark master;
if you specified the IP of the Spark master when starting the Spark master container, then you need to specify IP of the Spark master as the parameter, not the hostname of the Spark master.)
```

## Testing
You can run one of the following stock examples:
```
#Start and go into the Spark shell after starting the Spark master node, worker node containers and one existing HDFS 2.4.1 namenode

#Run these commands into the Spark shell
val textFile = sc.textFile("hdfs://10.28.241.170:8020/user/root/input/core-site.xml")(10.28.241.170:8020 is the ip and port for the existing HDFS 2.4.1 namenode)
textFile.count()
textFile.map({line => line}).collect()
```