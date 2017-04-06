#!/bin/bash

#Configure ego allocator modules.json
sed -i -e "s/localhost/${MASTER_HOST}/g" /opt/ibm/mesos/etc/mesos/modules.json
sed -i -e "s/plan_x/${RESPLAN}/g" /opt/ibm/mesos/etc/mesos/modules.json

#Start mesos-master
mesos-master --work_dir=/var/log/work --log_dir=/var/log/mesos --modules=file:///opt/ibm/mesos/etc/mesos/modules.json --allocator=com_ibm_EGOAllocatorModule $*
