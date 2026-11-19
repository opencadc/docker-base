# base cadc-java image

published image: `images.opencadc.org/library/cadc-java:{version}`

Base image with Java (21) intended for Java applications. The goal is for child 
images to simply add the application code and leave the rest to runtime deployment.

Optional: if the child image or build sets an ENV variable named `IMAGE_VERSION` in the image the 
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

## Changes
- 1.8 : almalinux 10, java-21-openjdk-headless, amd64 + arm64
- 1.7 : fedora 44, temurin-21-jre-headless, amd64 + arm64
- 1.6 : fedora 42, java-21-openjdk-headless, amd64 + arm64
- 1.5 : fedora 42, java-21-openjdk-headless

## Usage
Developers use this image by adding one java command line application and setting the CMD to run it,
so the application Dockerfile should be simple. Standard OpenCADC usage (application tar file built 
with gradle application plugin) looks like this:
```
FROM images.opencadc.org/library/cadc-java:1

ADD build/distributions/example.tar /

CMD ["/example/bin/example"]
```
Do not set/override the ENTRYPOINT; the builtin entrypoint script will exec the application after
init is complete.

## Resource Requirements
The JVM is currently configured with `-Xms512m -Xmx2048m` and uses the ParallelGC (java garbage collector).
We expect that 2.5 to 3.0GiB of memory in total is sufficient for a container near peak resource use. The
environment variable JAVA_HEAP_SIZE can be set to override the default `-Xmx2048m`; the value should be a
number followed by a unit, for example `JAVA_HEAP_SIZE=4096m`. This could be set in a Dockerfile for
applications known to need more memory or it could be set at deployment time.

The JVM is configured to do a heap dump and then exit if it runs out of memory (OutOfMemoryError) so that
the container orchestration system can restart and scale appropriately. The heap dump is sent to a file 
in `/dumps` which could be retrieved from the crashed container or a shared filesystem/volume could be 
mounted there to preserve them. The dump file name includes the host or pod name and a timestamp so should
never overwrite a previous dump.

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
* filesystem tools: acl attr
* network diagnostic tools: curl, openssl, nmap-cat

## building it
```
DOCKER_CONTENT_TRUST=1 docker buildx build --platform linux/amd64,linux/arm64 -t cadc-java -f Dockerfile .

DOCKER_CONTENT_TRUST=1 docker buildx build --pull --no-cache --platform linux/amd64,linux/arm64 -t cadc-java -f Dockerfile .
```

## checking it
```
docker run -it --rm --user opencadc:opencadc cadc-java:latest /bin/bash
docker run -it --rm --user root:root cadc-java:latest /bin/bash

```

## child container test
```
docker build -t cadc-java-test -f Dockerfile.test .
docker run -it --rm --user opencadc:opencadc cadc-java-test:latest
```

