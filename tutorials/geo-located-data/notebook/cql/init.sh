#!/bin/sh

TZ=UTC ${CASSANDRA_HOME}/bin/cqlsh --debug -f create_keyspace.cql
TZ=UTC ${CASSANDRA_HOME}/bin/cqlsh --debug -f load_tables.cql

