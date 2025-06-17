# base cadc-haproxy-dev image

published image: `images.opencadc.org/dev-only/cadc-haproxy-dev:{version}`

## Expected deployment
This is a basic haproxy image that can be used as a front end to a container. It mimics the one used in the CADC systems,
hence the choices of components and configuration. Mounting the container /config directory to the local host is
required for configuring the server certificate but it also allows a
number of features to be customized:
    1. /config/server-cert.pem is the server certificate (required)
    2. /config/cacerts is a directory containing CA certificates that should be added to the CA bundle if not part of
    the default bundle (optional)
    3. /config/haproxy.cfg overrides the default haproxy configuration (recommended)

The log messages go to /logs/haproxy.log on the container and can be directed to the host by mounting the
container /logs directory.

The default haproxy.cfg specifies a single back end at `cadc-service:8080` (see below).

## building it
```
DOCKER_CONTENT_TRUST=1 docker build -t cadc-haproxy-dev -f Dockerfile .
```

## checking it
```
docker run --rm -it cadc-haproxy-dev:latest /bin/bash
```

## running it
```
docker run --rm --volume=<path-to-external-logs>:/logs:rw --volume=<path-to-server-cert>:/config:ro --name haproxy cadc-haproxy-dev:latest
```
Optional: expose the https port (443) on the host: `-p 443:443`

Optional: use the default haproxy.cfg and a single back end container: `--link <backend-container-name>:cadc-service` 

## attach to an existing running container
docker exec -it haproxy /bin/bash

## kill a running container
docker kill haproxy

