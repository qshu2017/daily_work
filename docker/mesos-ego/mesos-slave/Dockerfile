FROM ubuntu:14.04
MAINTAINER Hui XA Chen<hchenxa@cn.ibm.com>


ENV TERM=xterm-256color

RUN apt-get update && apt-get install tzdata-java && apt-get install libapr1 libcurl3-nss libgflags2 libsasl2-2 libsvn1 gcj-4.8-jre-headless gcj-jre-headless libcurl3 libsasl2-modules -y && apt-get autoclean

COPY ./files/* /opt/ibm/
RUN dpkg -i /opt/ibm/mesos_*.deb && rm -rf /opt/ibm/mesos_*.deb

ENV PATH=$PATH:/opt/ibm/mesos/sbin:/opt/ibm/mesos/bin
RUN mkdir -p /var/lib/mesos /var/log/mesos

# Include libmesos on library path
ENV LD_LIBRARY_PATH $MESOS_HOME/lib

ENTRYPOINT ["mesos-slave", "--docker_socket=/var/run/docker.sock", "--work_dir=/var/lib/mesos", "--log_dir=/var/log/mesos"]
