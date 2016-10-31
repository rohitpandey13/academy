FROM natbusa/spark-toree-notebook 

USER root

# Default to UTF-8 file.encoding
ENV LANG C.UTF-8

#### Install gosu util (rather than using exec su <user> -c command)

# grab gosu for easy step-down from root
ENV GOSU_VERSION 1.7

# RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates wget && rm -rf /var/lib/apt/lists/*

RUN set -x \
	&& wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)" \
	&& wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc" \
	&& export GNUPGHOME="$(mktemp -d)" \
	&& gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
	&& gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
	&& rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
	&& chmod +x /usr/local/bin/gosu \
	&& gosu nobody true 

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

ENV CASSANDRA_CONFIG /etc/cassandra

RUN mkdir -p /var/lib/cassandra /var/log/cassandra ${CASSANDRA_CONFIG} \
	&& chown -R cassandra:cassandra /var/lib/cassandra /var/log/cassandra ${CASSANDRA_CONFIG} 

#### adding spark-cassandra-connector and reinstalling toree with the new opts

ADD http://dl.bintray.com/spark-packages/maven/datastax/spark-cassandra-connector/1.6.1-s_2.10/spark-cassandra-connector-1.6.1-s_2.10.jar /home/$NB_USER/spark-packages/

RUN chown $NB_USER:users /home/$NB_USER/spark-packages/*

#### putting it all together

COPY start-all.sh /usr/local/bin/
CMD ["start-all.sh"]

# Switch back to jovyan to avoid accidental container runs as root
USER $NB_USER

ENV SPARK_JARS local:///home/$NB_USER/spark-packages/spark-cassandra-connector-1.6.1-s_2.10.jar

# set the spark options with extra packages for cassandra running locally
ENV CASSANDRA_HOST localhost
ENV SPARK_OPTS_BASE ${SPARK_OPTS_BASE} --conf spark.cassandra.connection.host=${CASSANDRA_HOST}

ENV SPARK_OPTS ${SPARK_OPTS_BASE} --jars ${SPARK_JARS}

# Apache Toree install the kernel 
# (must be done again if you add packages or change SPARK_OPTS)
RUN jupyter toree install --user --spark_home=${SPARK_HOME} --spark_opts="'${SPARK_OPTS} --jars ${SPARK_JARS}'"

# HOWEVER: to run the implicit CMD start the container with --user root
# the script will start the cassandra service as 'cassandra' user and the notebook as $NB_USER
# otherwise start the cassandra service separately, using docker exec