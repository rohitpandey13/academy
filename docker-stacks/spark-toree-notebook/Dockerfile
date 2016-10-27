FROM jupyter/pyspark-notebook 

# A Toree dockerfile for scala spark only


USER root

#### JAVA openjdk8-jre-headless ####

# get the jessie-backports main repository added 
RUN rm -rf /var/lib/apt/lists/*
RUN echo 'deb http://httpredir.debian.org/debian jessie-backports main' > /etc/apt/sources.list.d/jessie-backports.list

# disable interactive functions
ENV DEBIAN_FRONTEND noninteractive

# set default java environment variable
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64

RUN apt-get update && \
    apt-get install -y --no-install-recommends openjdk-8-jre-headless && \
    rm -rf /var/lib/apt/lists/* 

# workaround for bug on ubuntu 14.04 with openjdk-8-jre-headless
RUN /var/lib/dpkg/info/ca-certificates-java.postinst configure

USER $NB_USER

# create spark-packages and notebooks dir
RUN mkdir /home/$NB_USER/notebooks 
RUN mkdir /home/$NB_USER/spark-packages 

#set the working dir to notebooks
WORKDIR /home/$NB_USER/notebooks

# Apache Toree kernel
RUN pip --no-cache-dir install --pre toree==0.1.0.dev8

# assume four cores, for a total of 5g memory
ENV SPARK_OPTS_BASE --conf spark.executor.memory=1g  --conf spark.driver.memory=1g --driver-java-options=-Xmx1024M --driver-java-options=-Dlog4j.logLevel=info

ENV SPARK_OPTS ${SPARK_OPTS_BASE}

# Apache Toree install the kernel 
# (must be done again if you add packages or change SPARK_OPTS)
RUN jupyter toree install --user --spark_home=${SPARK_HOME} --spark_opts="'${SPARK_OPTS}'"


