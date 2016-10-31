#!/bin/bash

set -e

#start the services if we're root
if [ $UID == 0 ] ; then
	gosu cassandra cassandra &
fi;

#start the foreground service 
# the start-notebook takes care of demoting the notebook server to $NB_USER, if starting with --user root
start-notebook.sh
