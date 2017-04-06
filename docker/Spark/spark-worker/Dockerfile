# Spark
FROM spark-base:1.1.0
MAINTAINER IBM

# Instead of using a random port, bind the worker to a specific port
EXPOSE 8889 8081

ADD files /root/spark_worker_files

# Add the entrypoint script for the worker
CMD ["-h"]
ENTRYPOINT ["/root/spark_worker_files/default_cmd"]
