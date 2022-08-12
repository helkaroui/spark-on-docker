# Spark on Docker

> The project was featured on an **[article](https://www.mongodb.com/blog/post/getting-started-with-mongodb-pyspark-and-jupyter-notebook)** at **Sharek.dev** tech blog

## Introduction

This project gives you an **Apache Spark** cluster in standalone mode with a **JupyterLab** interface built on top of **Docker**.
Learn Apache Spark through its **Scala** and **Python** (PySpark) by running the Jupyter [notebooks](build/workspace/) with examples on how to read, process and write data.

![jupyterlab-latest-version](https://img.shields.io/docker/v/helkaroui/jupyterlab/3.3.0-spark-3.3.0?color=green&label=jupyterlab-latest)
![spark-latest-version](https://img.shields.io/docker/v/helkaroui/spark-master/3.3.0?color=green&label=spark-latest)
![spark-scala-api](https://img.shields.io/badge/spark%20api-scala-yellow)
![spark-pyspark-api](https://img.shields.io/badge/spark%20api-pyspark-yellow)

## TL;DR

```bash
build.sh
docker-compose up
```

## <a name="quick-start"></a>Quick Start

### Cluster overview

| Application     | URL                                      | Description                                                |
| --------------- | ---------------------------------------- | ---------------------------------------------------------- |
| JupyterLab      | [localhost:8888](http://localhost:8888/) | Cluster interface with built-in Jupyter notebooks          |
| Spark Driver    | [localhost:4040](http://localhost:4040/) | Spark Driver web ui                                        |
| Spark Master    | [localhost:8080](http://localhost:8080/) | Spark Master node                                          |
| Spark Worker I  | [localhost:8081](http://localhost:8081/) | Spark Worker node with 1 core and 512m of memory (default) |
| Spark Worker II | [localhost:8082](http://localhost:8082/) | Spark Worker node with 1 core and 512m of memory (default) |

### Prerequisites

 - Install [Docker](https://docs.docker.com/get-docker/) and [Docker Compose](https://docs.docker.com/compose/install/), check **infra** [supported versions](#tech-stack)

### Download from Docker Hub (easier)

1. Download the [docker compose](docker-compose.yml) file;

```bash
curl -LO https://raw.githubusercontent.com/cluster-apps-on-docker/spark-standalone-cluster-on-docker/master/docker-compose.yml
```

2. Edit the [docker compose](docker-compose.yml) file with your favorite tech stack version, check **apps** [supported versions](#tech-stack);
3. Start the cluster;

```bash
docker-compose up
```

1. Run Apache Spark code using the provided Jupyter [notebooks](build/workspace/) with Scala and PySpark examples;
2. Stop the cluster by typing `ctrl+c` on the terminal;
3. Run step 3 to restart the cluster.

### Build from your local machine

> **Note**: Local build is currently only supported on Linux OS distributions.

1. Download the source code or clone the repository;
2. Edit the [build.yml](build/build.yml) file with your favorite tech stack version;
3. Match those version on the [docker compose](build/docker-compose.yml) file;
4. Build up the images;

```bash
chmod +x build.sh ; ./build.sh
```

6. Start the cluster;

```bash
docker-compose up
```

7. Run Apache Spark code using the provided Jupyter [notebooks](build/workspace/) with Scala, PySpark and SparkR examples;
8. Stop the cluster by typing `ctrl+c` on the terminal;

## <a name="tech-stack"></a>Tech Stack

- Infra

| Component      | Version |
| -------------- | ------- |
| Docker Engine  | 1.13.0+ |
| Docker Compose | 1.10.0+ |

- Languages and Kernels

| Spark | Hadoop | Scala   | [Scala Kernel](https://almond.sh/) | Python | [Python Kernel](https://ipython.org/) |
| ----- | ------ | ------- | ---------------------------------- | ------ | ------------------------------------- |
| 3.x   | 3.2    | 2.13.7 | 0.13.0                             | 3.7.3  | 7.19.0 |

- Apps

| Component      | Version                 | Docker Tag                                           |
| -------------- | ----------------------- | ---------------------------------------------------- |
| Apache Spark   | 3.3.0 | **\<spark-version>**                                 |
| JupyterLab     | 3.3.0          | **\<jupyterlab-version>**-spark-**\<spark-version>** |
