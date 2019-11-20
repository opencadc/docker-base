# base cadc-haproxy-dev image

## Expected deployment
This is a basic haproxy image that can be used as a front end to a container. It mimics the one used in the CADC systems,
hence the choices of components and configuration. The image configures the haproxy service to recognize a number of CA
additional certificates (in src/haproxy/cacerts directory). This can be customized.

The haproxy container is linked with the backend container at startup and uses the Docker internal networking. Therefore,
no ports need to be exposed on the backend container.

The haproxy container also expects a server certificate under the server-cert.pem name. The location of the file is
to be mounted as /conf on the container.

The log messages go into the haproxy.log file in /logs directory on the container or a location on the host that is
mounted as /logs in the container.

Note: This container cannot handle multiple backend containers/services.

## building it
docker build -t cadc-haproxy-dev -f Dockerfile .

## checking it
docker run --rm -it cadc-haproxy-dev:latest /bin/bash

## running it with another container as back end: "backend-container-name"
docker run --rm -v <path-to-external-logs>:/logs:rw <path-to-server-cert>:/conf:ro -p 443:443 --link <backend-container-name>:cadc-service cadc-haproxy-dev:latest

