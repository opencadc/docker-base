# base cadc-tomcat image

Base image with Java (currently 8) intended for Java applications. The goal is for child 
images to simply add the application code and leave the rest to runtime deployment. This 
image can be run as the user "nobody" (see below).

TBD: the postgresql-jdbc driver is already included in the image and it may be feasible 
to add other open source drivers as needed.

## Expected deployment
Child images are responsible for setting the command to execute. 
Output from the application is written to stdout (including JVM OnError logs).

Runtime configuration is found in /config and includes the following:

## cadcproxy.pem 
This optional certificate is used to use to make some priviledged server-to-server calls (A&A support).

TBD: this is questionable since this is a credential and not configuration per se and it probably expires 
during the lifetime of the container.

## cacerts
This optional directory includes CA certificates (pem format) that are added to the system trust store.

## building it
```
docker build -t cadc-java -f Dockerfile .
```

## checking it
```
docker run -it --rm --user nobody:nobody --volume=/path/to/config:/config:ro cadc-java-test:latest /bin/bash
```

## running it
```
docker run -d --user nobody:nobody --volume=/path/to/config:/config:ro cadc-java:latest
```

## child container test
```
docker build -t cadc-java-test -f Dockerfile.test .
docker run -it --rm --user nobody:nobody --volume=/path/to/config:/config:ro cadc-java-test:latest
```
