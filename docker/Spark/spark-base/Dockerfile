# Spark 1.1.0
# Version 1.1.0
#
FROM java-precise

MAINTAINER IBM

ENV SCALA_VERSION 2.10.3
ENV SPARK_VERSION 1.1.0
ENV SCALA_HOME /opt/scala-$SCALA_VERSION
ENV SPARK_HOME /opt/spark-$SPARK_VERSION
ENV PATH $SPARK_HOME:$SCALA_HOME/bin:$PATH

# Install Scala
#ADD http://www.scala-lang.org/files/archive/scala-$SCALA_VERSION.tgz /
COPY scala-$SCALA_VERSION.tgz  /
RUN (cd / && gunzip < scala-$SCALA_VERSION.tgz)|(cd /opt && tar -xvf -)
RUN rm /scala-$SCALA_VERSION.tgz

# Install Spark 
#ADD http://d3kbcqa49mib13.cloudfront.net/spark-$SPARK_VERSION-bin-hadoop2.4.tgz /
COPY spark-$SPARK_VERSION-bin-hadoop2.4.tgz /
RUN (cd / && gunzip < spark-$SPARK_VERSION-bin-hadoop2.4.tgz)|(cd /opt && tar -xvf -)
RUN (ln -s /opt/spark-$SPARK_VERSION-bin-hadoop2.4 /opt/spark-$SPARK_VERSION && rm /spark-$SPARK_VERSION-bin-hadoop2.4.tgz)

# Add Shark config files and configure script
ADD files /root/spark_files
