#Mesos 0.26


#Pull the basement image
docker pull ubuntu:14.04

#Build the images
If you want to build directly from the Dockerfile, you can build the images as:
```
docker build -t mesos:latest .
```

#Start the mesos master
```
root@mesos1:~# docker  run --privileged  --net=host -d  mesos:latest mesos-master --work_dir=/var/lib/mesos
```

#Start the mesos slave
```
root@mesos1:~# docker  run --privileged  --net=host -d  mesos:latest mesos-slave --master=localhost:5050
```

## Testing
You can use your browser to open the Mesos cluster WEB GUI
