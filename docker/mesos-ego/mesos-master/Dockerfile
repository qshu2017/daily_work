FROM ubuntu:14.04
MAINTAINER Hui XA Chen<hchenxa@cn.ibm.com>


<<<<<<< HEAD
ENV http_proxy=http://hchen1.eng.platformlab.ibm.com:3128
ENV https_proxy=http://hchen1.eng.platformlab.ibm.com:3128
=======
>>>>>>> 8fb06469459d7c15a07a56c034d59a17136adfcf
ENV TERM=xterm-256color

RUN apt-get update && apt-get install tzdata-java && apt-get install libapr1 libcurl3-nss libgflags2 libsasl2-2 libsvn1 gcj-4.8-jre-headless gcj-jre-headless libcurl3 libsasl2-modules -y && apt-get autoclean

COPY ./files/* /opt/ibm/
RUN dpkg -i /opt/ibm/*.deb && rm -rf /opt/ibm/*.deb

ENV PATH=$PATH:/opt/ibm/mesos/sbin:/opt/ibm/mesos/bin

RUN mkdir -p /var/lib/mesos /var/log/mesos

#Include libmesos on library path
ENV LD_LIBRARY_PATH $MESOS_HOME/lib


<<<<<<< HEAD
ENTRYPOINT ["/opt/ibm/configure.sh"]
=======
ENTRYPOINT ["/opt/ibm/bootstrap.sh"]
>>>>>>> 8fb06469459d7c15a07a56c034d59a17136adfcf
