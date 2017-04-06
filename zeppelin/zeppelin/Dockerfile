FROM hchenxa1986/spark-conductor:1.5.1

MAINTAINER hchenxa@cn.ibm.com

ENV LD_LIBRARY_PATH /opt/spark-1.5.2-hadoop-2.6/lib/native/x86_64/libSparkVEMApi.so:/opt/lib/
ENV DEPLOY_HOME /opt/
ENV SPARK_HOME /opt/spark-1.5.2-hadoop-2.6/
ENV EGO_CONFDIR /opt/conf
ENV DATADIR /opt/data
ADD ./files /opt/

