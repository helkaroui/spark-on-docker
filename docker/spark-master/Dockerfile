ARG spark_version
FROM apache/spark:v{spark_version}

EXPOSE 8080 7077

WORKDIR ${SPARK_HOME}

CMD bin/spark-class org.apache.spark.deploy.master.Master >> logs/spark-master.out
