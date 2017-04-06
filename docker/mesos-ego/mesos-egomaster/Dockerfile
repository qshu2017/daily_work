<<<<<<< HEAD
FROM mesos-master:test
MAINTAINER Hui XA Chen<hchenxa@cn.ibm.com>

ENV http_proxy=http://hchen1.eng.platformlab.ibm.com:3128
ENV https_proxy=http://hchen1.eng.platformlab.ibm.com:3128
=======
FROM hchenxa1986/mesos-master:0.27.0
MAINTAINER Hui XA Chen<hchenxa@cn.ibm.com>

>>>>>>> 8fb06469459d7c15a07a56c034d59a17136adfcf
ENV TERM=xterm-256color

COPY ./files/* /opt/ibm/
RUN dpkg -i /opt/ibm/mesos-ego_*.deb && rm -rf /opt/ibm/mesos-ego_*.deb
<<<<<<< HEAD
ENTRYPOINT ["/opt/ibm/configure.sh"]
=======
ENTRYPOINT ["/opt/ibm/bootstrap.sh"]
>>>>>>> 8fb06469459d7c15a07a56c034d59a17136adfcf
