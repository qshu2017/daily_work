FROM ubuntu:14.04
MAINTAINER Hui XA Chen<hchenxa@cn.ibm.com>


ENV TERM=xterm-256color

RUN apt-get update && apt-get install tzdata-java && apt-get install libapr1 libcurl3-nss libgflags2 libsasl2-2 libsvn1 gcj-4.8-jre-headless gcj-jre-headless libcurl3 libsasl2-modules -y && apt-get autoclean

ADD files /opt/mesos/
RUN dpkg -i /opt/mesos/mesos_*.deb && rm -rf /opt/mesos

ENV PATH=$PATH:/opt/ibm/mesos/sbin:/opt/ibm/mesos/bin
RUN mkdir -p /var/lib/mesos
