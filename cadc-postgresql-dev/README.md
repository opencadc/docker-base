# base cadc-dev-postgresql image

# current version
The current version: **postgresql15-server postgresql15-contrib pgsphere-1.4.2**. The minor version depends on
what is currently available from `postgresql.org` at build time.

Builds for older versions of postgresql-server and pgsphere are no longer kept because they
require maintenance and it isn noit worth the effort or complexity.

## expected deployment
This postgresql instance is designed for development support and has a very low level of
security. 

## databases
On startup, the following user accounts are created (name : password):
```
cadmin  : pw-cadmin
tapadm  : pw-tapadm
tapuser : pw-tapuser
```
These users are available in all databases.

## databases and schemas
The following schemas are created in all databases (name : acccount with full authorization):
```
tap_upload : tapuser
tap_schema : tapadm
uws        : tapadm
```

Databases to be created, and additional schemas for content, are configured by including the 
file /config/init-content-schemas.sh:
```
DATABASES="db1 db2 ..."
SCHEMAS="schema1 schema2 ..."
```

Like the TAP-related schemas, all content schemas are created in each database. At least one 
database and one schema is needed to start a useful postgresql server. The `cadmin` account will 
have full authorization in these "content" schema(s).

## building it 
```
docker build -t cadc-postgresql-dev -f Dockerfile .
```

## checking it
```
docker run -rm -it cadc-postgresql-dev:latest /bin/bash
```

## running it
```
docker run -d --volume=/path/to/config:/config:ro --volume=/path/to/logs:/logs:rw --name pg15test cadc-postgresql-dev:latest
```

One can expose the postgres server port (-p {external http port}:5432) or access it from an application 
on the same host via the private IP address.

