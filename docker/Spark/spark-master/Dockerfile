# Spark
FROM spark-base:1.1.0
MAINTAINER IBM

# Expose TCP ports 7077 8080
EXPOSE 7077 8080

ADD files /root/spark_master_files

CMD ["-h"]
ENTRYPOINT ["/root/spark_master_files/default_cmd"]
