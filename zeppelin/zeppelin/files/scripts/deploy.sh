#!/bin/bash

source ./scripts/common.inc

mkdir -p $NOTEBOOK_DEPLOY_DIR

# check if mkdir succeed
if [ $? != 0 ]; then
    echo "Location \"${NOTEBOOK_DEPLOY_DIR}\" does not have write permission."
    exit 1
fi

# if $NOTEBOOK_DEPLOY_DIR already exist, "mkdir -p $NOTEBOOK_DEPLOY_DIR" will always succeed.
# check write permission
touch ${NOTEBOOK_DEPLOY_DIR}/temp.txt
if [ $? != 0 ]; then 
    echo "Location \"${NOTEBOOK_DEPLOY_DIR}\" does not have write permission."
    exit 1
fi
rm -f ${NOTEBOOK_DEPLOY_DIR}/temp.txt

# check whether current user has enough write and read permission to NOTEBOOK_DATA_BASE_DIR
if [ -d ${NOTEBOOK_DATA_BASE_DIR} ]; then
    # check write permission
    touch ${NOTEBOOK_DATA_BASE_DIR}/temp.txt
    if [ $? != 0 ]; then 
        echo "Location \"${NOTEBOOK_DATA_BASE_DIR}\" does not have write permission."
        exit 1
    fi
    rm -f ${NOTEBOOK_DATA_BASE_DIR}/temp.txt
else
    mkdir -p $NOTEBOOK_DATA_BASE_DIR
    # check if mkdir succeed
    if [ $? != 0 ]; then
        echo "Location \"${NOTEBOOK_DATA_BASE_DIR}\" does not have write permission."
        exit 1
    fi
    rm -f $NOTEBOOK_DATA_BASE_DIR
fi

cp -r ./scripts $NOTEBOOK_DEPLOY_DIR/
cp ./package/zeppelin-0.5.0-incubating-bin-spark-1.4.0_hadoop-2.3.tgz $NOTEBOOK_DEPLOY_DIR/

cd $NOTEBOOK_DEPLOY_DIR; tar xzvf zeppelin-0.5.0-incubating-bin-spark-1.4.0_hadoop-2.3.tgz --no-same-owner 

