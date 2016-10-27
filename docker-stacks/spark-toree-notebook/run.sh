#!/bin/sh
docker run -it -p 8888:8888 -p 9042 -m 8g -c 4 natbusa/spark-toree-notebook:latest

