# Spark
FROM spark-base:1.1.0
MAINTAINER IBM

# EXPOSE
EXPOSE 4040

ADD files /root/spark_shell_files

# Add the entrypoint script for the spark shell
CMD ["-h"]
ENTRYPOINT ["/root/spark_shell_files/default_cmd"]
