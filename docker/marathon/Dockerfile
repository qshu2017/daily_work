FROM hchenxa1986/mesos

MAINTAINER Hui XA Chen <hchenxa@cn.ibm.com>


ADD marathon /opt/

RUN apt-get update && apt-get install -y python-software-properties software-properties-common && add-apt-repository -y ppa:openjdk-r/ppa && apt-get update && apt-get install -y openjdk-8-jdk && apt-get autoclean 
RUN ln -s /opt/bin/start ./marathon

ENV MESOS_NATIVE_JAVA_LIBRARY=/opt/ibm/mesos/lib/libmesos.so

