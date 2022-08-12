ARG spark_version
FROM apache/spark:v${spark_version}


ENV SPARK_MASTER_HOST spark-master
ENV SPARK_MASTER_PORT 7077
ENV PYSPARK_PYTHON python3

USER root

WORKDIR ${SPARK_HOME}

RUN mkdir /opt/spark/conf/

COPY spark-default.conf /opt/spark/conf/

EXPOSE 8081

CMD bin/spark-class org.apache.spark.deploy.worker.Worker spark://${SPARK_MASTER_HOST}:${SPARK_MASTER_PORT}
