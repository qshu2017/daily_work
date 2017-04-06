#!/bin/bash

# Spark 1.5.2

source ./scripts/common.inc

# install everything first
mkdir -p $DEPLOY_HOME

# check if mkdir succeed
if [ $? != 0 ]; then
    echo "Location \"${DEPLOY_HOME}\" does not have write permission."
    exit 1
fi

# if $DEPLOY_HOME already exist, "mkdir -p $DEPLOY_HOME" will always succeed.
# check write permission
touch ${DEPLOY_HOME}/temp.txt
if [ $? != 0 ]; then 
    echo "Location \"${DEPLOY_HOME}\" does not have write permission."
    exit 1
fi
rm -f ${DEPLOY_HOME}/temp.txt

# remove first in case cp override reminder in re-deployment
rm -rf $DEPLOY_HOME/scripts
rm -f $DEPLOY_HOME/spark-1.5.2-hadoop-2.6.tgz

cp -r ./scripts $DEPLOY_HOME/
cp ./spark-1.5.2-hadoop-2.6.tgz $DEPLOY_HOME/
cd $DEPLOY_HOME; tar xzvf spark-1.5.2-hadoop-2.6.tgz --no-same-owner 

# the default SPARK_WORK_DIR ($SPAKR_HOME/work) need to be 777
# for user set SPARK_WORK_DIR, end user need make sure its existence and the permission is 777
chmod 777 $SPARK_HOME/work

# spark-env.sh is always created after the installation of Spark on EGO in Spark
# for re-deployment case, always override with original spark-env.sh
# replace with correct SPARK_EGO_NATIVE_LIBRARY path in Spark home
cd $SPARK_HOME/conf
sed -i "s#@SPARK_HOME@#$SPARK_HOME#" spark-env.sh 

# no spark-defaults.conf after the installation of Spark on EGO in Spark, always create empty spark-defaults.conf to handle re-deployment case
rm -f spark-defaults.conf
touch spark-defaults.conf

# spark.xxx.xxx is not valid environment variable, conductor backend set environment variable by spark_xxx_xxx
# replace . by _ to get environment variable name, so that we could get the value set.
# also cover some parameter with "-" like spark.akka.failure-detector.threshold
getEnvName() {
    parameterName=$1
    envNameTmp=${parameterName//./_}
    envName=${envNameTmp//-/_}
    echo $envName
}

# spark.xxx.xxx is always in spark-defaults.conf
# SPARK_XXX_XXX is always in spark-env.sh
addParameter() {
    parameterName=$1
    parameterValue=$2
    if [ `echo $parameterName | grep "\."` ]; then
        echo "$parameterName $parameterValue" >> spark-defaults.conf
    else
        echo "$parameterName=$parameterValue" >> spark-env.sh
    fi
}

# all spark parameters
sparkParameterArray=(
spark.app.name
spark.driver.cores
spark.driver.maxResultSize
spark.driver.memory
spark.executor.memory
spark.extraListeners
spark.local.dir
spark.logConf
spark.master
spark.driver.extraClassPath
spark.driver.extraJavaOptions
spark.driver.extraLibraryPath
spark.driver.userClassPathFirst
spark.executor.extraClassPath
spark.executor.extraJavaOptions
spark.executor.extraLibraryPath
spark.executor.logs.rolling.maxRetainedFiles
spark.executor.logs.rolling.maxSize
spark.executor.logs.rolling.strategy
spark.executor.logs.rolling.time.interval
spark.executor.userClassPathFirst
spark.executorEnv.[EnvironmentVariableName]
spark.python.profile
spark.python.profile.dump
spark.python.worker.memory
spark.python.worker.reuse
spark.reducer.maxSizeInFlight
spark.shuffle.blockTransferService
spark.shuffle.compress
spark.shuffle.consolidateFiles
spark.shuffle.file.buffer
spark.shuffle.io.maxRetries
spark.shuffle.io.numConnectionsPerPeer
spark.shuffle.io.preferDirectBufs
spark.shuffle.io.retryWait
spark.shuffle.manager
spark.shuffle.memoryFraction
spark.shuffle.sort.bypassMergeThreshold
spark.shuffle.spill
spark.shuffle.spill.compress
#spark.shuffle.service.enabled
spark.eventLog.compress
spark.eventLog.dir
spark.eventLog.enabled
spark.ui.killEnabled
spark.ui.port
spark.ui.retainedJobs
spark.ui.retainedStages
spark.worker.ui.retainedExecutors
spark.worker.ui.retainedDrivers
spark.sql.ui.retainedExecutions
spark.broadcast.compress
spark.closure.serializer
spark.io.compression.codec
spark.io.compression.lz4.blockSize
spark.io.compression.snappy.blockSize
spark.kryo.classesToRegister
spark.kryo.referenceTracking
spark.kryo.registrationRequired
spark.kryo.registrator
spark.kryoserializer.buffer.max
spark.kryoserializer.buffer
spark.rdd.compress
spark.serializer
spark.serializer.objectStreamReset
spark.broadcast.blockSize
spark.broadcast.factory
spark.cleaner.ttl
spark.executor.cores
spark.default.parallelism
spark.executor.heartbeatInterval
spark.files.fetchTimeout
spark.files.useFetchCache
spark.files.overwrite
spark.hadoop.cloneConf
spark.hadoop.validateOutputSpecs
spark.storage.memoryFraction
spark.storage.memoryMapThreshold
spark.storage.unrollFraction
spark.externalBlockStore.blockManager
spark.externalBlockStore.baseDir
spark.externalBlockStore.url
spark.akka.frameSize
spark.akka.heartbeat.interval
spark.akka.heartbeat.pauses
spark.akka.threads
spark.akka.timeout
spark.blockManager.port
spark.broadcast.port
spark.driver.host
spark.driver.port
spark.executor.port
spark.fileserver.port
spark.network.timeout
spark.port.maxRetries
spark.replClassServer.port
spark.rpc.numRetries
spark.rpc.retry.wait
spark.rpc.askTimeout
spark.rpc.lookupTimeout
spark.cores.max
#spark.locality.wait
#spark.locality.wait.node
#spark.locality.wait.process
#spark.locality.wait.rack
#spark.scheduler.maxRegisteredResourcesWaitingTime
#spark.scheduler.minRegisteredResourcesRatio
spark.scheduler.mode
spark.scheduler.revive.interval
spark.speculation
spark.speculation.interval
spark.speculation.multiplier
spark.speculation.quantile
#spark.task.cpus
spark.task.maxFailures
#spark.dynamicAllocation.enabled
#spark.dynamicAllocation.executorIdleTimeout
spark.dynamicAllocation.cachedExecutorIdleTimeout
spark.dynamicAllocation.initialExecutors
#spark.dynamicAllocation.maxExecutors
#spark.dynamicAllocation.minExecutors
#spark.dynamicAllocation.schedulerBacklogTimeout
#spark.dynamicAllocation.sustainedSchedulerBacklogTimeout
spark.acls.enable
spark.admin.acls
spark.authenticate
spark.authenticate.secret
spark.core.connection.ack.wait.timeout
spark.core.connection.auth.wait.timeout
spark.modify.acls
spark.ui.filters
spark.ui.view.acls
spark.authenticate.enableSaslEncryption
spark.network.sasl.serverAlwaysEncrypt
spark.ssl.enabled
spark.ssl.enabledAlgorithms
spark.ssl.keyPassword
spark.ssl.keyStore
spark.ssl.keyStorePassword
spark.ssl.protocol
spark.ssl.trustStore
spark.ssl.trustStorePassword
spark.streaming.backpressure.enabled
spark.streaming.blockInterval
spark.streaming.receiver.maxRate
spark.streaming.receiver.writeAheadLog.enable
spark.streaming.unpersist
spark.streaming.kafka.maxRatePerPartition
spark.streaming.kafka.maxRetries
spark.streaming.ui.retainedBatches
spark.r.numRBackendThreads
spark.r.command
spark.r.driver.command
SPARK_DAEMON_MEMORY
#SPARK_DAEMON_JAVA_OPTS
SPARK_PUBLIC_DNS
SPARK_HISTORY_OPTS
spark.history.provider
spark.history.fs.logDirectory
spark.history.fs.update.interval
spark.history.retainedApplications
spark.history.ui.port
spark.history.kerberos.enabled
spark.history.kerberos.principal
spark.history.kerberos.keytab
spark.history.ui.acls.enable
spark.history.fs.cleaner.enabled
spark.history.fs.cleaner.interval
spark.history.fs.cleaner.maxAge
HADOOP_CONF_DIR
SPARK_LOCAL_IP
#SPARK_PUBLIC_DNS
SPARK_CLASSPATH
SPARK_LOCAL_DIRS
MESOS_NATIVE_JAVA_LIBRARY
SPARK_EXECUTOR_INSTANCES
SPARK_EXECUTOR_CORES
SPARK_EXECUTOR_MEMORY
SPARK_DRIVER_MEMORY
#SPARK_YARN_APP_NAME
#SPARK_YARN_QUEUE
#SPARK_YARN_DIST_FILES
#SPARK_YARN_DIST_ARCHIVES
#SPARK_MASTER_IP
SPARK_MASTER_PORT
SPARK_MASTER_WEBUI_PORT
SPARK_MASTER_OPTS
SPARK_WORKER_CORES
SPARK_WORKER_MEMORY
SPARK_WORKER_PORT
SPARK_WORKER_WEBUI_PORT
SPARK_WORKER_INSTANCES
SPARK_WORKER_DIR
SPARK_WORKER_OPTS
#SPARK_HISTORY_OPTS
SPARK_SHUFFLE_OPTS
#SPARK_DAEMON_JAVA_OPTS
#SPARK_CONF_DIR
#SPARK_LOG_DIR
#SPARK_PID_DIR
#SPARK_IDENT_STRING
SPARK_NICENESS
SPARK_DIST_CLASSPATH
SPARK_SUBMIT_LIBRARY_PATH
SPARK_SUBMIT_CLASSPATH
SPARKR_DRIVER_R
#DEPLOY_MODE
SPARK_EGO_SUBMIT_FILE_REPLICATION
#spark.ego.submit.file.replication 
SPARK_EGO_ACCESS_NAMENODES 
#spark.ego.access.namenodes
#SPARK_EGO_NATIVE_LIBRARY
#SPARK_EGO_JNI_ENV_NAME
#SPARK_EGO_ENABLE_SESSION_SCHEDULER 
SPARK_EGO_STAGING_DIR
SPARK_EGO_DISTRIBUTE_FILES
#spark.ego.distribute.files
SPARK_WORK_DIR
SPARK_EGO_ACL_PERMISSION
spark.ego.credential
#SPARK_EGO_DRIVER_CONSUMER
#spark.ego.driver.consumer
#SPARK_EGO_EXECUTOR_CONSUMER
#spark.ego.executor.consumer
#SPARK_EGO_UNAME
#spark.ego.uname
#SPARK_EGO_PASSWD
#spark.ego.passwd
#SPARK_EGO_EXECUTOR_PLAN
#spark.ego.executor.plan
#SPARK_EGO_DRIVER_PLAN
#spark.ego.driver.plan
SPARK_EGO_EXECUTOR_SLOTS_RESERVE
#spark.ego.executor.slots.reserve
#SPARK_EGO_RUN_AS_SERVICE
#spark.ego.run.as.service
SPARK_EGO_AUTH_MODE
SPARK_EGO_IMPERSONATION
#SPARK_EGO_ENABLE_COLLECT_USAGE
#spark.ego.enable.collect.usage
SPARK_EGO_LOGSERVICE_PORT
#spark.ego.logservice.port
#SPARK_EGO_EXECUTOR_RESREQ
#spark.ego.executor.resreq
#SPARK_EGO_DRIVER_RESREQ
#spark.ego.driver.resreq
JAVA_HOME
PYSPARK_PYTHON
PYSPARK_DRIVER_PYTHON
spark.shuffle.service.port
spark.master.rest.port
spark.deploy.recoveryMode
spark.deploy.recoveryDirectory
#spark.deploy.zookeeper.url
#spark.deploy.zookeeper.dir
SPARK_EGO_CLIENT_TTL
#spark.ego.client.ttl
SPARK_EGO_AUTH_BY_EGO
SPARK_EGO_APP_SCHEDULE_POLICY
SPARK_EGO_EXECUTOR_IDLE_TIMEOUT
#spark.ego.executor.idle.timeout
SPARK_EGO_EXECUTOR_SLOTS_MAX
#spark.ego.executor.slots.max
SPARK_EGO_SLOTS_MAX
#spark.ego.slots.max
SPARK_EGO_PRIORITY
#spark.ego.priority
)

# echo ${sparkParameterArray[*]}

# add spark parameters into spark-env.sh or spark-defaults.conf
for sparkParameter in ${sparkParameterArray[@]}
do
    #echo $sparkParameter
    if [ `echo $sparkParameter | grep "spark\.executorEnv\."` ]; then
        # spark.executorEnv.[EnvironmentVariableName] is special one
        # would be like spark.executorEnv.LD_LIBRARY_PATH=/usr/lib, from ENV, we would get spark_executorEnv_LD_LIBRARY_PATH=/usr/lib
        for e in `env | grep "spark_executorEnv_"`
        do
            #echo $e
            envValue=${e#*=}
            #echo $envValue
            envName=${e%=*}
            parameterName="spark.executorEnv.""${envName#spark_executorEnv_}"
            #echo $parameterName
            addParameter $parameterName $envValue
        done
    else
        envName=$(getEnvName $sparkParameter)
        #echo $envName
        #echo '$'"$envName"
        envValue=`eval echo '$'"$envName"`
        #echo $envValue
        if [ -n "$envValue" ]; then
            addParameter $sparkParameter $envValue
        fi
    fi
done

# add SPARK_EGO_LOG_DIR, SPARK_EGO_UMASK, SPARK_INSTANCE_GROUP_ID, SPARK_INSTANCE_GROUP_NAME
# should comment SPARK_EGO_LOG_DIR/SPARK_EGO_UMASK/SPARK_INSTANCE_GROUP_ID/SPARK_INSTANCE_GROUP_NAME in spark parameter files, end user shouldn't touch it.
if [ -n "$SPARK_EGO_LOG_DIR_ROOT"  ]; then
    echo "SPARK_EGO_LOG_DIR=$SPARK_EGO_LOG_DIR_ROOT" >> spark-env.sh
fi
echo "SPARK_EGO_UMASK=027" >> spark-env.sh
if [ -n "$APP_UUID"  ]; then
    echo "SPARK_INSTANCE_GROUP_ID=$APP_UUID" >> spark-env.sh
fi
if [ -n "$APP_NAME"  ]; then
    echo "SPARK_INSTANCE_GROUP_NAME=$APP_NAME" >> spark-env.sh
fi

# add JAVA_HOME if no user set
# all service, driver, executor need JAVA_HOME, we shouldn't suppose there is in customer's env.
# we need set it into spark-env.sh, all-in-one package ensures there is "jre" in both management and computer host.
if [ ! -n "$JAVA_HOME"  ]; then
    if [ -n "$EGO_TOP"  ]; then
        case `uname` in
        Linux)
            case `uname -m` in
            ppc64)
                OS_TYPE=linux-ppc64
                ;;
            ppc64le)
                OS_TYPE=linux-ppc64le
                ;;
            x86_64)
                OS_TYPE=linux-x86_64
                ;;
            esac
        esac
        JAVA_HOME_VALUE=`find $EGO_TOP/jre/ -name "$OS_TYPE"`
        if [ -n "$JAVA_HOME_VALUE"  ]; then
            echo "JAVA_HOME=$JAVA_HOME_VALUE" >> spark-env.sh
        fi
    fi
fi

# set spark.executor.extraJavaOptions with "-Djava.security.egd=file:/dev/./urandom" if no user set
if [ ! -n "$spark_executor_extraJavaOptions"  ]; then
    echo "spark.executor.extraJavaOptions -Djava.security.egd=file:/dev/./urandom" >> spark-defaults.conf
fi

# DEPLOY_MODE would always be "cluster" in spark-env.sh
echo "DEPLOY_MODE=cluster" >> spark-env.sh

# SPARK_PID_DIR would always under DEPLOY_HOME
echo "SPARK_PID_DIR=$DEPLOY_HOME" >> spark-env.sh

# SPARK_EGO_RUN_AS_SERVICE would always be "true" in spark-env.sh
echo "SPARK_EGO_RUN_AS_SERVICE=true" >> spark-env.sh

# spark.shuffle.service.enabled would always be "true" in spark-defaults.conf
echo "spark.shuffle.service.enabled true" >> spark-defaults.conf

#select libSparkVEMApi.so
case `uname` in
Linux)
    case `uname -m` in
    ppc64)
        MACHINE_TYPE=ppc64
        ;;
    ppc64le)
        MACHINE_TYPE=ppc64le
        ;;
    x86_64)
        MACHINE_TYPE=x86_64
        ;;
    esac
esac
cd $SPARK_HOME/lib/native/$MACHINE_TYPE
mv * ..
cd ..
rm -rf ppc64 ppc64le x86_64


mv -f $SPARK_HOME/conf/log4j.properties.template $SPARK_HOME/lib/ego/log4j.properties
echo SPARK_EGO_JARS=$SPARK_HOME/lib/ego/:$SPARK_HOME/lib/ego/* >> $SPARK_HOME/conf/spark-env.sh
