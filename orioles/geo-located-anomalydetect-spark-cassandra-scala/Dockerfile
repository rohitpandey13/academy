FROM natbusa/casspark-notebook 

# launchbot-specific labels
LABEL name.launchbot.io="Anomaly Detection"
LABEL workdir.launchbot.io="/home/jovyan/notebooks"
LABEL description.launchbot.io="Anomaly Detection"
LABEL 8888.port.launchbot.io="Start Tutorial"

USER root

#download spark packages
ADD http://dl.bintray.com/spark-packages/maven/graphframes/graphframes/0.1.0-spark1.6/graphframes-0.1.0-spark1.6.jar /home/$NB_USER/spark-packages/
ADD https://github.com/natalinobusa/nak/raw/master/nak_2.10-1.3.jar /home/$NB_USER/spark-packages/

RUN chown $NB_USER:users /home/$NB_USER/spark-packages/*

# preload demo data
RUN mkdir /var/lib/cassandra/data 
ADD cassandra.datadir.tar.gz /var/lib/cassandra/
RUN chown -R cassandra:cassandra /var/lib/cassandra/data

# notebook!
ADD oriole-dbscan-spark-cassandra-scala.ipynb /home/$NB_USER/notebooks/
RUN chown $NB_USER:users /home/$NB_USER/notebooks/oriole-dbscan-spark-cassandra-scala.ipynb

# Switch back to jovyan 
USER $NB_USER

# update SPARK_OPTS and reinstall toree
ENV SPARK_JARS ${SPARK_JARS},local:///home/$NB_USER/spark-packages/graphframes-0.1.0-spark1.6.jar,local:///home/$NB_USER/spark-packages/nak_2.10-1.3.jar
ENV SPARK_OPTS ${SPARK_OPTS_BASE} --jars ${SPARK_JARS}

# Apache Toree install the kernel 
# (must be done again if you add packages or change SPARK_OPTS)
RUN jupyter toree install --user --spark_home=${SPARK_HOME} --spark_opts="'${SPARK_OPTS}'"

# Switch back to jovyan to avoid accidental container runs as root
USER $NB_USER

# HOWEVER: to run the implicit CMD start the container with --user root
# the script will start the cassandra service as 'cassandra' user and the notebook as $NB_USER
# otherwise start the cassandra service separately, using docker exec