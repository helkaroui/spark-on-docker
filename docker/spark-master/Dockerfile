ARG spark_version
FROM apache/spark:v${spark_version}

EXPOSE 8080 7077

USER root

WORKDIR ${SPARK_HOME}

RUN mkdir /opt/spark/conf/

COPY spark-default.conf /opt/spark/conf/

CMD bin/spark-class org.apache.spark.deploy.master.Master
