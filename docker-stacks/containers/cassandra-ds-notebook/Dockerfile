FROM jupyter/datascience-notebook 

USER root

# Default to UTF-8 file.encoding
ENV LANG C.UTF-8

#### zip utils
RUN apt-get update && apt-get install -y --no-install-recommends \
		bzip2 \
		unzip \
		xz-utils \
	&& rm -rf /var/lib/apt/lists/*

#### Install gosu util (rather than using exec su <user> -c command)

# grab gosu for easy step-down from root
ENV GOSU_VERSION 1.7
RUN set -x \
	&& apt-get update && apt-get install -y --no-install-recommends ca-certificates wget && rm -rf /var/lib/apt/lists/* \
	&& wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)" \
	&& wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc" \
	&& export GNUPGHOME="$(mktemp -d)" \
	&& gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
	&& gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
	&& rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
	&& chmod +x /usr/local/bin/gosu \
	&& gosu nobody true 

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

#### Cassandra 3.9

RUN groupadd -r cassandra --gid=999 && useradd -r -g cassandra --uid=999 cassandra

# https://wiki.apache.org/cassandra/DebianPackaging#Adding_Repository_Keys
ENV GPG_KEYS \
# gpg: key 0353B12C: public key "T Jake Luciani <jake@apache.org>" imported
	514A2AD631A57A16DD0047EC749D6EEC0353B12C \
# gpg: key FE4B2BDA: public key "Michael Shuler <michael@pbandjelly.org>" imported
	A26E528B271F19B9E5D8E19EA278B781FE4B2BDA
RUN set -ex \
	&& for key in $GPG_KEYS; do \
		apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
	done

RUN echo 'deb http://www.apache.org/dist/cassandra/debian 39x main' >> /etc/apt/sources.list.d/cassandra.list

ENV CASSANDRA_VERSION 3.9

RUN apt-get update \
	&& apt-get install -y cassandra="$CASSANDRA_VERSION" \
	&& rm -rf /var/lib/apt/lists/*

# https://issues.apache.org/jira/browse/CASSANDRA-11661
RUN sed -ri 's/^(JVM_PATCH_VERSION)=.*/\1=25/' /etc/cassandra/cassandra-env.sh

#### putting it all together

CMD ["start-all.sh"]

#### Switch back to jovyan, setup the course material

USER $NB_USER
RUN mkdir /home/$NB_USER/notebooks 

# Set the working directory
WORKDIR /home/$NB_USER 

# late copy of files, keep the docker cache clean
ADD start-all.sh /usr/local/bin/

# To run the implicit CMD start the container with --user root
# the script will start the cassandra service as 'cassandra' user and the notebook as $NB_USER
# otherwise start the cassandra service separately, using docker exec
