# base cadc-haproxy-dev image

## Expected deployment
This is a basic haproxy image that can be used as a front end to a container. It mimics the one used in the CADC systems,
hence the choices of components and configuration. Mounting the container /conf directory to the local host is
required for configuring the server certificate but it also allows a
number of features to be customized:
    1. /config/server-cert.pem is the server certificate (required)
    2. /config/cacerts is a directory containing CA certificates that should be added to the CA bundle if not part of
    the default bundle (optional)
    3. /config/haproxy.cfg overrides the default haproxy configuration (optional)

The default haproxy container is linked with the backend container at startup and uses the Docker internal networking.
Therefore, no ports need to be exposed on the backend container.

The log messages go to /logs/haproxy.log on the container and can be directed to the host by mounting the
container /logs directory.

Note: This container cannot handle multiple backend containers/services.

## building it
```
docker build -t cadc-haproxy-dev -f Dockerfile .
```

## checking it
```
docker run --rm -it cadc-haproxy-dev:latest /bin/bash
```

## running it with another container as back end: "backend-container-name"
```
docker run --rm --volume=<path-to-external-logs>:/logs:rw --volume=<path-to-server-cert>:/config:ro -p 443:443 --name haproxy cadc-haproxy-dev:latest
```
Other options like `--link <backend-container-name>:cadc-service` could be used with the default haproxy.cfg to
have haproxy forward requests to a single back end container (e.g. for testing).

## test some functionality with the configuration in /test that uses httpbin.org as a backend
curl -E <user-cert> https://<host>/headers

## attach to an existing running container
docker exec -it haproxy /bin/bash

## kill a running container
docker kill haproxy

