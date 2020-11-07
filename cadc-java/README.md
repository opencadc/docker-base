# base cadc-java image

Base image with Java (currently 8) intended for Java applications. The goal is for child 
images to simply add the application code and leave the rest to runtime deployment.

Child images should use the  Dockerfile CMD option to specify the startup command. This allows
the ENTRYPOINT script specified here to run and initialise the environment before starting the
application.

## configuration

Runtime configuration is found in /config and includes the following:

### cadcproxy.pem

This optional certificate is used to use to make remote calls that requrie a client certificate.

TBD: this is questionable since this is a credential and not configuration per se and it probably expires 
during the lifetime of the container.

### cacerts

This optional directory includes CA certificates (pem format) that are added to the system trust store.

## unprivileged execution

The container includes an unprivileged user and group (opencadc) and the uid:gid in the container are an
arbitrary high number (8675309); this allows one to grant permissions if an external volume/filesystem 
is attached at runtime.

## building it
```
docker build -t cadc-java -f Dockerfile .
```

## checking it
```
docker run -it --rm --user opencadc:opencadc cadc-java:latest /bin/bash
```

## running it
```
docker run --user opencadc:opencadc --volume=/path/to/config:/config:ro cadc-java:latest
```

## child container test
```
docker build -t cadc-java-test -f Dockerfile.test .
docker run -it --rm --user opencadc:opencadc --volume=/path/to/config:/config:ro cadc-java-test:latest
```

## apply version tags
```bash
. VERSION && echo "tags: $TAGS" 
for t in $TAGS; do
   docker image tag cadc-java:latest cadc-java:$t
done
unset TAGS
```
