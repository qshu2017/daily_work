# Base Ubuntu Precise 12.04 LTS image
#
#FROM ubuntu:precise
FROM centos:7.0
MAINTAINER IBM

# Setup a volume for data
VOLUME ["/data"]

# Set correct source list
#RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
#RUN echo "deb http://archive.ubuntu.com/ubuntu precise-updates main universe" >> /etc/apt/sources.list

# install a few other useful packages plus Open Jdk 7
#RUN apt-get update && apt-get upgrade -y && apt-get install -y less openjdk-7-jre-headless net-tools vim-tiny sudo openssh-server iputils-ping python2.7

RUN yum install -y less java-1.7.0-openjdk net-tools vim sudo openssh-server iputils python

# Docker messes up /etc/hosts and adds two entries for 127.0.0.1
# we try to recover from that by giving /etc/resolv.conf and therefore
# the nameserver priority
RUN sed -i s/"files dns"/"dns files"/ /etc/nsswitch.conf

# add config file templates
ADD files /root/config_files

# Set JAVA_HOME
ENV JAVA_HOME /usr/lib/jvm/jre-1.7.0-openjdk
