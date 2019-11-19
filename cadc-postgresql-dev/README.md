# base cadc-dev-postgresql image

## Expected deployment
This postgresql instance is designed for development support and has a very low level of
security.

## databases
On startup, the following databases are created:

cadctest : intended for database library integration tests
content  : intended for web service back end integration tests

## users
The following user accounts are created (name : password):

caom2 : pw-caom2
invadm : pw-invadm

tapadm : pw-tapadm
tapuser : pw-tapuser

These users are available in all databases.

## schemas
The following schemas are created (name : acccount with full permissions):

caom2 : caom2
inventory : invadm

tap_schema : tapadm
uws : tapadm

These schemas are available in all databases. The first two (caom2 and inventory) are 
for specific content; it would be feasible to have a single "content" schema and run 
separate servers instead... TBD.

## building it
docker build -t cadc-postgresql-dev -f Dockerfile .

## checking it
docker run -it cadc-postgresql-dev:latest /bin/bash

## running it
docker run -d --volume=/path/to/external/logs:/logs:rw cadc-postgresql-dev:latest

One can expose the postgres server port (-p {external http port}:5432) or access it from an application 
on the same host via the private IP address.

