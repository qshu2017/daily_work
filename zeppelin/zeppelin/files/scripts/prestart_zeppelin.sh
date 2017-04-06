#!/bin/bash
#It needs following mandatory environment variables
#NOTEBOOK_DATA_DIR
#NOTEBOOK_BASE_PORT
#EGOSC_SERVICE_NAME

PATH=$PATH:/usr/local/bin:/bin:/usr/bin:/sbin/:/usr/sbin
NOTEBOOK_PORT_LOCK_PATH=/tmp/notebooks

if [ "${NOTEBOOK_DATA_DIR}" == "" ] || [ "${EGOSC_SERVICE_NAME}" == ""  ] || [ "${NOTEBOOK_BASE_PORT}" == "" ];then
    exit
fi

#This path will be used by multiple users. The creator needs to set the permission to 777.
mkdir ${NOTEBOOK_PORT_LOCK_PATH} > /dev/null 2>&1
if [ $? -eq 0 ]; then
    chmod 777 ${NOTEBOOK_PORT_LOCK_PATH}
fi

mkdir -p ${NOTEBOOK_DATA_DIR}

NOTEBOOK_PORT_FILE=${NOTEBOOK_DATA_DIR}/ports
rm -rf ${NOTEBOOK_PORT_FILE}
touch ${NOTEBOOK_PORT_FILE}

port=${NOTEBOOK_BASE_PORT}
portCount=0
if [ "${NOTEBOOK_PORT_STEP}" == "" ];then
    NOTEBOOK_PORT_STEP=2
fi

while true
do
#Check if the port is used by Conductor
    mkdir ${NOTEBOOK_PORT_LOCK_PATH}/${port} > /dev/null 2>&1
    if [ $? -eq 0 ]; then
#Check if the port is used by OS
        ss -t -u -an|awk '{print $5"|"}' | grep -q ":$port|" > /dev/null 2>&1
        if [ $? -eq 0 ]; then
            rm -rf ${NOTEBOOK_PORT_LOCK_PATH}/${port}/
        else
#Other user's service may access to it. Change permission.
            chmod 777 ${NOTEBOOK_PORT_LOCK_PATH}/${port}
            mkdir ${NOTEBOOK_PORT_LOCK_PATH}/${port}/${EGOSC_SERVICE_NAME} > /dev/null 2>&1
            if [ $? -eq 0 ]; then
                chmod 777 ${NOTEBOOK_PORT_LOCK_PATH}/${port}/${EGOSC_SERVICE_NAME}
                let portCount+=1
                echo ${port} >> ${NOTEBOOK_PORT_FILE}
                if [ ${portCount} -eq ${NOTEBOOK_PORT_STEP} ]; then
                    break;
                fi
            fi
        fi
    else
        mkdir ${NOTEBOOK_PORT_LOCK_PATH}/${port}/${EGOSC_SERVICE_NAME} > /dev/null 2>&1
        if [ $? -eq 0 ]; then
            rm -rf ${NOTEBOOK_PORT_LOCK_PATH}/${port}/${EGOSC_SERVICE_NAME}
        else
            chmod 777 ${NOTEBOOK_PORT_LOCK_PATH}/${port}/${EGOSC_SERVICE_NAME}
            ss -t -u -an|awk '{print $5"|"}' | grep -q ":$port|" > /dev/null 2>&1
            if [ $? -eq 0 ]; then
                rm -rf ${NOTEBOOK_PORT_LOCK_PATH}/${port}/
            else
                let portCount+=1
                echo ${port} >> ${NOTEBOOK_PORT_FILE}
                if [ ${portCount} -eq ${NOTEBOOK_PORT_STEP} ]; then
                    break;
                fi
            fi
        fi
    fi
    
    #Check next port
    let port+=1

    sleep 1

done

    