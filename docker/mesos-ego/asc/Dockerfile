<<<<<<< HEAD
FROM mesos-master:test
MAINTAINER Hui XA Chen<hchenxa@cn.ibm.com>


ENV http_proxy=http://hchen1.eng.platformlab.ibm.com:3128
ENV https_proxy=http://hchen1.eng.platformlab.ibm.com:3128
=======
FROM ubuntu:14.04
MAINTAINER Hui XA Chen<hchenxa@cn.ibm.com>


>>>>>>> 8fb06469459d7c15a07a56c034d59a17136adfcf
ENV TERM=xterm-256color

COPY ./files/* /opt/ibm/

RUN apt-get update && apt-get install gettext rpm wget -y

ENV CLUSTERADMIN root
ENV CLUSTERNAME mesos
ENV BASEPORT 7869
ENV SIMPLIFIEDWEM N
<<<<<<< HEAD
RUN wget --no-check-certificate https://lweb.eng.platformlab.ibm.com/engr/pcc/release_eng/work/sym/sym7.1.1/RC3/pssasetup2015_linux-x86_64.bin -O /opt/ibm/pssasetup2015_linux-x86_64.bin && chmod a+x /opt/ibm/pssasetup2015_linux-x86_64.bin && /opt/ibm/pssasetup2015_linux-x86_64.bin --quiet && rm -rf /opt/ibm/pssasetup2015_linux-x86_64.bin

ENTRYPOINT ["/opt/ibm/configure.sh"]
=======


RUN wget --no-check-certificate https://lweb.eng.platformlab.ibm.com/engr/pcc/release_eng/work/sym/sym7.1.1/RC3/pssasetup2015_linux-x86_64.bin -O /opt/ibm/pssasetup2015_linux-x86_64.bin && chmod a+x /opt/ibm/pssasetup2015_linux-x86_64.bin && /opt/ibm/pssasetup2015_linux-x86_64.bin --quiet && rm -rf /opt/ibm/pssasetup2015_linux-x86_64.bin

VOLUME ["/opt/ibm/platform/3.3/linux-x86_64/lib/"]

ENTRYPOINT ["/opt/ibm/bootstrap.sh"]
>>>>>>> 8fb06469459d7c15a07a56c034d59a17136adfcf
