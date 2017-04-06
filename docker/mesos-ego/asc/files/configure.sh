#!/bin/bash

#Configure ASC and start the service
source /opt/ibm/platform/profile.platform; egosetsudoers.sh
echo "1" >> ~/.ASCConfigued
ascMaster=`hostname`
source /opt/ibm/platform/profile.platform; egoconfig join ${ascMaster} -f
egoconfig setentitlement /opt/ibm/platform_asc_entitlement.dat
rm -rf /opt/ibm/platform_asc_entitlement.dat
source /opt/ibm/platform/profile.platform
egosh ego start

egosh ego info
while [ $? -ne 0 ]
do
        sleep 5
        egosh ego info
done
