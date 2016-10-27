#!/bin/sh
#docker run -it -p 8888:8888 -m 8g -c 4 --user root -v $(pwd)/cassandra.datadir:/var/lib/cassandra -v $(pwd)/cql:/home/jovyan/cql natbusa/oriole-casspark-notebook:latest
docker run -it -p 8888:8888 -m 8g -c 4 --user root natbusa/oriole-casspark-notebook:latest


