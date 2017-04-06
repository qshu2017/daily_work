# Base Ubuntu Precise 12.04 LTS image
#
FROM ubuntu:latest
MAINTAINER hchenxa@cn.ibm.com

# Set correct source list
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN echo "deb http://archive.ubuntu.com/ubuntu precise-updates main universe" >> /etc/apt/sources.list

ENV http_proxy=http://9.21.62.203:3128
ENV https_proxy=http://9.21.62.203:3128

#install a few other useful packages plus Open Jdk 7
RUN apt-get update && apt-get upgrade -y && apt-get install -y less openjdk-7-jre-headless net-tools vim-tiny sudo openssh-server iputils-ping python2.7

# Set JAVA_HOME
ENV JAVA_HOME /usr/lib/jvm/java-1.7.0-openjdk-amd64/jre

