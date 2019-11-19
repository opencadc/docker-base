#!/bin/bash

## this scripts runs in the container (as postgres) after the postgres process is started ##

## create accounts
psql --command "CREATE USER caom2   WITH ENCRYPTED PASSWORD 'pw-caom2'"
psql --command "CREATE USER invadm WITH ENCRYPTED PASSWORD 'pw-invadm'"
psql --command "CREATE USER tapuser WITH ENCRYPTED PASSWORD 'pw-tapuser';"
psql --command "CREATE USER tapadm  WITH ENCRYPTED PASSWORD 'pw-tapadm';"

for DBNAME in cadctest content; do
    createdb $DBNAME 

    ## enable extensions: citext pgsphere
    psql -d $DBNAME --command "CREATE EXTENSION IF NOT EXISTS citext;"
    psql -d $DBNAME --command "CREATE EXTENSION IF NOT EXISTS pg_sphere;"

    ## create schema(s)
    psql -d $DBNAME --command "CREATE SCHEMA uws AUTHORIZATION tapadm;"
    psql -d $DBNAME --command "CREATE SCHEMA tap_schema AUTHORIZATION tapadm;"
    psql -d $DBNAME --command "CREATE SCHEMA tap_upload AUTHORIZATION tapuser;"
    psql -d $DBNAME --command "CREATE SCHEMA caom2 AUTHORIZATION caom2;"
    psql -d $DBNAME --command "CREATE SCHEMA inventory AUTHORIZATION invadm;"

done

