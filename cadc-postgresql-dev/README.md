# base cadc-dev-postgresql image
 
published image: `images.opencadc.org/dev-only/cadc-postgresql-dev:{version}`

# current version
The current version: **postgresql17-server postgresql17-contrib pgsphere-1.5.2**. The minor version depends on
what is currently available from `postgresql.org` at build time.

Builds for older versions of postgresql-server and pgsphere are no longer kept because they
require maintenance and it is not worth the effort or complexity.

## expected deployment
This postgresql instance is designed for development support and has a very low level of
security. 

## accounts 
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
CATALOGS="db1 db2 ..."
SCHEMAS="schema1 schema2 ..."
```

Like the TAP-related schemas, all content schemas are created in each database. At least one 
database and one schema is needed to start a useful postgresql server. The `cadmin` account will 
have full authorization in these "content" schema(s).

See example below for how to provide the `init-content-schemas.sh` at startup.

The postgresql server is confgured to log startup information to file(s) in `/logs` inside the container. 
That's normally fine for a disposable db container.

The standard `pg_isready` command is available in the PATH (symlink in /usr/local/bin).

The data for the live server is located in `/var/lib/pgsql/17/data`. If you want the content to
be persisted outside the container you can mount a volume here; the internal postgres user (uid=gid=26)
must **own** the mounted directory.

## building it 
```
DOCKER_CONTENT_TRUST=1 docker build -t cadc-postgresql-dev -f Dockerfile .
```

## checking it
```
docker run --rm -it cadc-postgresql-dev:latest /bin/bash
```

## running it
To mount the config directory containing `init-content-schemas.sh`:
```
docker run -d --user postgres:postgres \
    --volume=$(pwd)/config:/config:ro \
    --name pg17test cadc-postgresql-dev:latest
```
or to mount the single config file:
```
docker run -d --user postgres:postgres \
    --mount type=bind,source=$(pwd)/config/init-content-schemas.sh,target=/config/init-content-schemas.sh,readonly \
    --name pg17test cadc-postgresql-dev:latest
```

To also mount a persistent volume for the database content:
```
docker run -d --user postgres:postgres \
    --volume=$(pwd)/config:/config:ro \
    --volume=$(pwd)/persistent-volume/data:/var/lib/pgsql/17/data:rw \
    --name pg17test cadc-postgresql-dev:latest
```


