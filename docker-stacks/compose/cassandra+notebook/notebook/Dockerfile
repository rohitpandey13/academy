FROM jupyter/datascience-notebook 

## all in user mode, no need for root here
WORKDIR /home/$NB_USER/work

# add extra packages
RUN pip install cassandra-driver

# set workdir as home, add a directory for notebooks
WORKDIR /home/$NB_USER
RUN mkdir notebooks
