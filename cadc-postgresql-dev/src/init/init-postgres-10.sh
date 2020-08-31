#!/bin/bash

## this script runs on the container (as postgres) before the postgres server starts ##

PGBASE=/var/lib/pgsql/10

/usr/pgsql-10/bin/initdb -D $PGBASE/data

## modified config files are provided by the container in the $PGBASE dir
for cf in $PGBASE/*.conf; do
    FNAME=$(basename $cf)
    \rm -f $PGBASE/data/$FNAME
    ln -s $cf $PGBASE/data/$FNAME
done

