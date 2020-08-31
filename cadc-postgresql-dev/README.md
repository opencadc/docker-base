# base cadc-dev-postgresql image

## Expected deployment
This postgresql instance is designed for development support and has a very low level of
security.

## databases
On startup, the following databases are created:
```
cadctest : intended for database library integration tests
content  : intended for web service back end
```

## users
The following user accounts are created (name : password):
```
cadmin : pw-cadmin
tapadm : pw-tapadm
tapuser : pw-tapuser
```
These users are available in all databases.

## schemas
The following schemas are created (name : acccount with full permissions):
```
tap_schema : tapadm
tap_upload : tapuser
uws : tapadm
```
These schemas are available in all databases. Addtional schemas can be configured by including the file
/config/init-content-schemas.sh with
```
SCHEMAS="schema1 schema2 ..."
```
The `cadmin` account will have full authorization in these "content" schema(s).

# PostgreSQL 12.x

## building it 
```
docker build -t cadc-postgresql-dev -f Dockerfile.pg12 .
```

## checking it
```
docker run -it cadc-postgresql-dev:latest /bin/bash
```

## running it
```
docker run -d --volume=/path/to/config:/config:ro --volume=/path/to/logs:/logs:rw --name pg12db cadc-postgresql-dev:latest
```

One can expose the postgres server port (-p {external http port}:5432) or access it from an application 
on the same host via the private IP address.

