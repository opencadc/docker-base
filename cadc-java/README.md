# base cadc-java image

Base image with Java (currently 8) intended for Java applications. The goal is for child 
images to simply add the application code and leave the rest to runtime deployment.

Child images should use the  Dockerfile `CMD` option to specify the startup command. This allows
the ENTRYPOINT script specified here to run and initialise the environment before starting the
application.

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
Packages that are included: ca-certificates sudo (for CA cert setup), which (gradle appplication support),
and curl (for manual diagnostics).

Packages that are known to be added by some downstream OpenCADC image builds: wcslib.x86_64, erfa.x86_64. 
TBD: include this small set of libs in the base image? Reason: avoid downstream install causing untested 
upgrades in other packages.

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

