#!/bin/bash

## this scripts runs in the container (as postgres) after the postgres process is started ##

## create accounts
psql --command "CREATE USER cadmin   WITH ENCRYPTED PASSWORD 'pw-cadmin'"
psql --command "CREATE USER tapuser WITH ENCRYPTED PASSWORD 'pw-tapuser';"
psql --command "CREATE USER tapadm  WITH ENCRYPTED PASSWORD 'pw-tapadm';"

DATABASES=""
SCHEMAS=""
. /config/init-content-schemas.sh

for DBNAME in $DATABASES; do
    createdb $DBNAME

    ## enable extensions: citext pgsphere
    psql -d $DBNAME --command "CREATE EXTENSION IF NOT EXISTS citext;"
    psql -d $DBNAME --command "CREATE EXTENSION IF NOT EXISTS pg_sphere;"

    ## create TAP schema(s)
    psql -d $DBNAME --command "CREATE SCHEMA uws AUTHORIZATION tapadm;"
    psql -d $DBNAME --command "CREATE SCHEMA tap_schema AUTHORIZATION tapadm;"
    psql -d $DBNAME --command "CREATE SCHEMA tap_upload AUTHORIZATION tapuser;"
    
    ## create content schema(s)
    echo "content schemas: $SCHEMAS"
    for SN in $SCHEMAS; do
        echo "create schema: $SN"
        psql -d $DBNAME --command "CREATE SCHEMA $SN AUTHORIZATION cadmin;"
    done

done

