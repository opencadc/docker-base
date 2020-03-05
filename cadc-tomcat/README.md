# base cadc-tomcat image

Base image with Java (currently 8) and Tomcat (9) intended for deploying web services. The goal is for child 
images to simply add a war file to /usr/share/tomcat/webapps and leave the rest to runtime deployment. This 
image can be run as the user "tomcat" (see below).

## Expected deployment
This tomcat instance is expected to have a proxy (HAproxy, apache, nginx) in front that performs
SSL termination and forwards calls via HTTP on port 8080. Optional client certificates are passed through 
via the X-Client-Certificate HTTP header (http-request set-header X-Client-Certificate %[ssl_c_der,base64]
in haproxcy.cfg).

Output from the tomcat startup and the tomcat server itself are written to stdout (including JVM OnError
logs).

Runtime configuration is found in /config and includes the following:

## catalina.properties
This required file contains java system properties required by the tomcat configuration:

```
tomcat.connector.secure={true|false}
tomcat.connector.scheme={http|https}
tomcat.connector.proxyName={SSL terminator host}
tomcat.connector.proxyPort={SSL terminator port}
```
Example for external proxy that handles SSL:
```
tomcat.connector.secure=true
tomcat.connector.scheme=https
tomcat.connector.proxyName=www.example.net
tomcat.connector.proxyPort=443
```

Additional system properties to configure the application can also be added here.

Application specific configuration files can also be placed in /config; applications can find them 
using ${user.home}/config (the user.home java system property).

## tomcat.conf
This optional file contains java system properties used by the tomcat configuration:

```
JAVA_OPTS=" {options added during tomcat startup} $JAVA_OPTS"
```

## cadcproxy.pem 
This optional certificate is used to use to make some priviledged server-to-server calls (A&A support).

TBD: this is questionable since this is a credential and not configuration per se and it probably expires 
during the lifetime of the container.

## cacerts
This optional directory includes CA certificates (pem format) that are added to the system trust store.

## lib
This optional directory includes java libraries (jar files) that are added to the tomcat system classpath. This can be used
to include java libraries that are only known at config/deployment time but needed by tomcat (e.g. a JDBC driver for a connection pool declared in the context.xml file).

TBD: the postgresql-jdbc driver is already included in the image and it may be feasible to add other open source drivers as needed.

TBD: this approach is questionable since this is software and not configuration per se.

## building it
```
docker build -t cadc-tomcat -f Dockerfile .
```

## checking it
```
docker run -it --rm --volume=/path/to/config:/config:ro cadc-tomcat:latest /bin/bash
```

## running it
```
docker run -d --user tomcat:tomcat --volume=/path/to/config:/config:ro cadc-tomcat:latest
```

One can expose the tomcat port (-p {external http port}:8080) or use a proxy on the same host to access it via 
the private IP address. 

