# base cadc-java image

published image: `images.opencadc.org/library/cadc-java:{version}`

Base image with Java (currently 8) intended for Java applications. The goal is for child 
images to simply add the application code and leave the rest to runtime deployment.

Child images should use the  Dockerfile `CMD` option to specify the startup command. This allows
the ENTRYPOINT script specified here to run and initialise the environment before starting the
application.

Optional: if the child image sets and ENV variable named `IMAGE_VERSION` in the image the 
container will log this version during startup. The default startup logs some information 
about the runtime and will include this between the START and DONE lines, e.g.:
```
{timestamp} cadc-java-init START
user: opencadc
...
image version: 1.2.3
...
{timestamp} cadc-java-init DONE
```

The recommended approach is to add this to an application's Dockerfile:
```
ARG IMAGE_VERSION=unknown
ENV IMAGE_VERSION=$IMAGE_VERSION
```
and then use `docker build --buildarg IMAGE_VERSION=$VER ...` to override the default value 
with the current version number.

## logging

Log output from the application is dumped to standard output and the deployment is responsible 
for capturing this output. 

## configuration

Runtime configuration is found in /config and includes the following:

### client proxy certificates (pem)

All `pem` files found in the /config directory are made available to applications in $HOME/.ssl/.
Application code that uses client certificate(s) should load client certificates from $HOME/.ssl/;
this is the case for all OpenCADC java applications.

### cacerts

This optional directory includes CA certificates (pem format) that are added to the system trust store.

## unprivileged execution

The container includes an unprivileged user and group (opencadc) and the uid:gid in the container are an
arbitrary high number (8675309); this allows one to grant permissions if an external volume/filesystem 
is attached at runtime.

## additional linux packages

This image is based on Fedora Linux, so additional linux packages should be installed using the `dnf` command.
Several fedora packages are installed in addition to OpenJDK; this reduces the need for downstream 
image builds to install common packages.

Current extra packages: 
* network diagnostic tools: curl, openssl, nmap-cat
* astronomy libs: erfa, wcslib

## building it
```
DOCKER_CONTENT_TRUST=1 docker build -t cadc-java -f Dockerfile .
```

## checking it
```
docker run -it --rm --user opencadc:opencadc cadc-java:latest /bin/bash
```

## running it
```
docker run --rm --user opencadc:opencadc --volume=/path/to/config:/config:ro cadc-java:latest
```

## child container test
```
docker build -t cadc-java-test -f Dockerfile.test .
docker run -it --rm --user opencadc:opencadc --volume=/path/to/config:/config:ro cadc-java-test:latest
```

