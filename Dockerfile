FROM maven:3.8.3-jdk-8

ARG DEBIAN_FRONTEND=noninteractive
ARG KYUUBI_VERSION 1.2.0
ARG SPARK_MAJOR_VERSION 3.1
ARG SPARK_MINOR_VERSION 3.1.2
ARG HADOOP_MAJOR_VERSION 3.2
ARG HADOOP_MINOR_VERSION 3.2.2

ENV KYUUBI_HOME /opt/kyuubi-${KYUUBI_VERSION}-bin-spark-${SPARK_MAJOR_VERSION}-hadoop${HADOOP_MAJOR_VERSION}
ENV SPARK_HOME ${KYUUBI_HOME}/externals/spark-${SPARK_MINOR_VERSION}-bin-hadoop${HADOOP_MAJOR_VERSION}
ENV HADOOP_HOME /opt/hadoop-${HADOOP_MINOR_VERSION}
ENV PATH $PATH:${HADOOP_HOME}/bin:${HADOOP_HOME}/sbin:${SPARK_HOME}/bin:${SPARK_HOME}/sbin
ENV BUILD_DEPS \
 bc \
 gcc \
 git \
 make

RUN apt-get update && \
  apt-get install -y ${BUILD_DEPS} && \
  cd /opt && \
  git clone https://github.com/jsminet/hive-benchmark.git && \
  wget --progress=bar:force:noscroll -O kyuubi-spark-bin-hadoop.tgz \
    "https://github.com/NetEase/kyuubi/releases/download/v${KYUUBI_VERSION}/kyuubi-${KYUUBI_VERSION}-bin-spark-${SPARK_MAJOR_VERSION}-hadoop${HADOOP_MAJOR_VERSION}.tar.gz" && \ 
  tar -xvf kyuubi-spark-bin-hadoop.tgz && \
  rm kyuubi-spark-bin-hadoop.tgz && \
  wget --progress=bar:force:noscroll -O hadoop-binary.tar.gz \
    "http://apache.mirror.iphh.net/hadoop/common/hadoop-${HADOOP_MINOR_VERSION}/hadoop-${HADOOP_MINOR_VERSION}.tar.gz" && \
  tar -xvf hadoop-binary.tar.gz && \
  rm hadoop-binary.tar.gz && \
  rm -rf /opt/hadoop-${HADOOP_MINOR_VERSION}/share/doc && \
  rm -rf /var/lib/apt/lists/*

WORKDIR /opt/hive-benchmark

ENTRYPOINT ["tpch-build.sh"]

CMD ["bash"]