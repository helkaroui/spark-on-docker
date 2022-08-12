#!/bin/bash
#
# -- Build Apache Spark Standalone Cluster Docker Images

# ----------------------------------------------------------------------------------------------------------------------
# -- Variables ---------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------------------

BUILD_DATE="$(date -u +'%Y-%m-%d')"

SHOULD_BUILD_SPARK="$(grep -m 1 build_spark build.yml | grep -o -P '(?<=").*(?=")')"
SHOULD_BUILD_JUPYTERLAB="$(grep -m 1 build_jupyter build.yml | grep -o -P '(?<=").*(?=")')"

SHOULD_PUSH_SPARK="$(grep -m 1 push_spark build.yml | grep -o -P '(?<=").*(?=")')"
SHOULD_PUSH_JUPYTERLAB="$(grep -m 1 push_jupyterlab build.yml | grep -o -P '(?<=").*(?=")')"

SPARK_VERSION="$(grep -m 1 spark build.yml | grep -o -P '(?<=").*(?=")')"
JUPYTERLAB_VERSION="$(grep -m 1 jupyterlab build.yml | grep -o -P '(?<=").*(?=")')"

HADOOP_VERSION="3.2"
SCALA_VERSION="2.13.7"
SCALA_KERNEL_VERSION="0.13.0"

# ----------------------------------------------------------------------------------------------------------------------
# -- Functions----------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------------------

function cleanContainers() {

    container="$(docker ps -a | grep 'jupyterlab' | awk '{print $1}')"
    docker stop "${container}"
    docker rm "${container}"

    container="$(docker ps -a | grep 'spark-worker' -m 1 | awk '{print $1}')"
    while [ -n "${container}" ];
    do
      docker stop "${container}"
      docker rm "${container}"
      container="$(docker ps -a | grep 'spark-worker' -m 1 | awk '{print $1}')"
    done

    container="$(docker ps -a | grep 'spark-master' | awk '{print $1}')"
    docker stop "${container}"
    docker rm "${container}"

}

function cleanImages() {

    if [[ "${SHOULD_BUILD_JUPYTERLAB}" == "true" ]]
    then
      docker rmi -f "$(docker images | grep -m 1 'jupyterlab' | awk '{print $3}')"
    fi

    if [[ "${SHOULD_BUILD_SPARK}" == "true" ]]
    then
      docker rmi -f "$(docker images | grep -m 1 'spark-worker' | awk '{print $3}')"
      docker rmi -f "$(docker images | grep -m 1 'spark-master' | awk '{print $3}')"
    fi

}

function cleanVolume() {
  docker volume rm "hadoop-distributed-file-system"
}

function buildImages() {

  if [[ "${SHOULD_BUILD_SPARK}" == "true" ]]
  then
    echo -e "\e[32m Building Spark Images \e[0m"

    docker build \
      --build-arg build_date="${BUILD_DATE}" \
      --build-arg spark_version="${SPARK_VERSION}" \
      -f docker/spark-master/Dockerfile \
      -t spark-master:${SPARK_VERSION} .

    docker build \
      --build-arg build_date="${BUILD_DATE}" \
      --build-arg spark_version="${SPARK_VERSION}" \
      -f docker/spark-worker/Dockerfile \
      -t spark-worker:${SPARK_VERSION} .
  fi

  if [[ "${SHOULD_BUILD_JUPYTERLAB}" == "true" ]]
  then
    echo -e "\e[32m Building Jupyter Images \e[0m"

    docker build \
      --build-arg build_date="${BUILD_DATE}" \
      --build-arg scala_version="${SCALA_VERSION}" \
      --build-arg spark_version="${SPARK_VERSION}" \
      --build-arg jupyterlab_version="${JUPYTERLAB_VERSION}" \
      --build-arg scala_kernel_version="${SCALA_KERNEL_VERSION}" \
      -f docker/jupyterlab/Dockerfile \
      -t jupyterlab:${JUPYTERLAB_VERSION}-spark-${SPARK_VERSION} .
  fi
}


function pushImages() {

  if [[ "${SHOULD_PUSH_SPARK}" == "true" ]]
  then
    echo -e "\e[32m Pushing Spark Images \e[0m"

    docker image tag spark-master:${SPARK_VERSION} helkaroui/spark-master:${SPARK_VERSION}
    docker image push helkaroui/spark-master:${SPARK_VERSION}

    docker image tag spark-worker:${SPARK_VERSION} helkaroui/spark-worker:${SPARK_VERSION}
    docker image push helkaroui/spark-worker:${SPARK_VERSION}
  fi

  if [[ "${SHOULD_PUSH_JUPYTERLAB}" == "true" ]]
  then
    echo -e "\e[32m Pushing Jupyter Images \e[0m"
    docker image tag jupyterlab:${JUPYTERLAB_VERSION}-spark-${SPARK_VERSION} helkaroui/jupyterlab:${JUPYTERLAB_VERSION}-spark-${SPARK_VERSION}
    docker image push helkaroui/jupyterlab:${JUPYTERLAB_VERSION}-spark-${SPARK_VERSION}
  fi
}

# ----------------------------------------------------------------------------------------------------------------------
# -- Main --------------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------------------

cleanContainers;
#cleanImages;
cleanVolume;
buildImages;
#pushImages;