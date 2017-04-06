#!/bin/bash

#Configure ego allocator modules.json
if [ ! -z $MASTER_HOST ];then
	sed -i -e "s/localhost/${MASTER_HOST}/g" /opt/ibm/mesos/etc/mesos/modules.json
fi

if [ ! -z $RESPLAN ];then
	sed -i -e "s/plan_x/${RESPLAN}/g" /opt/ibm/mesos/etc/mesos/modules.json
fi

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/ibm/platform/3.3/linux-x86_64/lib/
#Start mesos-master
mesos-master --work_dir=/var/log/work --log_dir=/var/log/mesos --modules=file:///opt/ibm/mesos/etc/mesos/modules.json --allocator=com_ibm_EGOAllocatorModule $*
