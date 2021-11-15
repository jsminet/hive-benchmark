FROM maven:3.8.3-jdk-8

ARG DEBIAN_FRONTEND=noninteractive

ENV KYUUBI_VERSION 1.2.0
ENV SPARK_MAJOR_VERSION 3.1
ENV SPARK_MINOR_VERSION 3.1.2
ENV HADOOP_MAJOR_VERSION 3.2
ENV HADOOP_MINOR_VERSION 3.2.2

ENV KYUUBI_HOME /opt/kyuubi-${KYUUBI_VERSION}-bin-spark-${SPARK_MAJOR_VERSION}-hadoop${HADOOP_MAJOR_VERSION}
ENV SPARK_HOME ${KYUUBI_HOME}/externals/spark-${SPARK_MINOR_VERSION}-bin-hadoop${HADOOP_MAJOR_VERSION}
ENV HADOOP_HOME /opt/hadoop-${HADOOP_MINOR_VERSION}

ENV PATH $PATH:${HADOOP_HOME}/bin:${HADOOP_HOME}/sbin:${SPARK_HOME}/bin:${SPARK_HOME}/sbin

ENV BUILD_DEPS \
 bc \
 gcc \
 make

WORKDIR /opt/hive-benchmark
ADD . /opt/hive-benchmark

RUN apt-get update && \
  apt-get install -y ${BUILD_DEPS} && \
  rm -rf /var/lib/apt/lists/*

CMD ["bash"]