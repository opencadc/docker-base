#!/bin/bash

## this script runs in the container (as postgres) before the postgres server starts ##

/usr/pgsql-${VER}/bin/initdb -D $PGBASE/$VER/data --encoding=UTF8 --lc-collate=C --lc-ctype=C

## modified config files are provided by the container in the $PGBASE dir
for cf in $PGBASE/*.conf; do
    FNAME=$(basename $cf)
    \rm -f $PGBASE/$VER/data/$FNAME
    \cp $cf $PGBASE/$VER/data/$FNAME
done

