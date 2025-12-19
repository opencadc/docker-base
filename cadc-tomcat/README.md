# base cadc-tomcat image

published image: `images.opencadc.org/library/cadc-tomcat:{version}`

Base image with Java (currently 21) and Tomcat (9) intended for deploying web services. The goal is for child 
images to simply add a war file to /usr/share/tomcat/webapps and leave the rest to runtime deployment. This 
image can be run as the user "tomcat" (see below).

Optional: if the child image or build sets an ENV variable named `IMAGE_VERSION` in the image the 
container will log this version during startup. The default startup logs some information 
about the runtime and will include this between the START and DONE lines, e.g.:
```
{timestamp} cadc-tomcat-start START
user: tomcat
...
image version: 1.2.3
...
{timestamp} cadc-tomcat-start DONE
```

## Expected deployment
This tomcat instance is expected to have a proxy (HAproxy, apache, nginx) in front that performs
SSL termination and forwards calls via HTTP on port 8080. Optional client certificates are passed through 
via the X-Client-Certificate HTTP header (http-request set-header X-Client-Certificate %[ssl_c_der,base64]
in haproxcy.cfg).

Output from the tomcat startup and the tomcat server itself are written to stdout (including JVM OnError
logs).

## configuration
All runtime configuration is located in /config. Application specific configuration files can also be placed 
here; applications can find them using ${user.home}/config (the user.home java system property). 

Standard tomcat configuration includes the following files:

### catalina.properties
This required file contains java system properties required by the tomcat configuration:

```
tomcat.connector.connectionTimeout={integer milliseconds}
tomcat.connector.keepAliveTimeout={integer milliseconds}
tomcat.connector.secure={true|false}
tomcat.connector.scheme={http|https}
tomcat.connector.proxyName={SSL terminator host}
tomcat.connector.proxyPort={SSL terminator port}
```
Example for external proxy that handles SSL:
```
tomcat.connector.connectionTimeout=20000
tomcat.connector.keepAliveTimeout=120000
tomcat.connector.secure=true
tomcat.connector.scheme=https
tomcat.connector.proxyName=www.example.net
tomcat.connector.proxyPort=443
```

The _tomcat.connector properties_ are a subset of the 
<a href="https://tomcat.apache.org/tomcat-9.0-doc/config/http.html">complete set of 
configuration options</a> for Tomcat Connector. Other configuration settings are either 
hard coded or left at the default value. The _secure_, _scheme_, _proxyName_, and 
_proxyPort_ are the values of the SSL_terminating proxy server that sits in front of 
the container. They are used so applications see these values in the request URI 
(instead of the values for the container) and enable applications to generate correct 
externally usable URLs to othe resources in the applicaiton. This generally removes 
the need for the proxy to examine and rewrite out-going content (headers and body).

Additional system properties to configure the application can also be added here.

### war-rename.conf
This optional file contains directives to rename a war file in the webapps directory before
tomcat is started. 
```
mv foo.war bar.war
```
Note: applications have to be carefully written to never hard code path information and always
discover it from the request for this to work. Some applications may not be _movable_.

Renaming the war file can take advantage of some tomcat war file naming conventions
(https://tomcat.apache.org/tomcat-9.0-doc/config/context.html), for example: to rename 
the context or introduce additional path elements:
```
mv foo.war api#foo.war
```
to deploy as `/api/foo`.

To deploy a service on the root of the server, take advantage of this special tomcat name:
```
mv foo.war ROOT.war
```

### tomcat.conf
This optional file contains configuration used by the tomcat startup, e.g.:

```
JAVA_OPTS=" {options added during tomcat startup} $JAVA_OPTS"
```
Note: the default JAVA_OPTS include setting max stack space and max heap size to 
sensible limits (currently 512MiB and 2GiB respectively).

### client certificates 
Zero or more client certificate(s) may be included in the config directory and are 
made available as `{user.home}/.ssl/{cert filename}` for use by the application (typically: 
server-to-server calls for A&A support). Client certificate files must have a `.pem` extension.

TBD: this is questionable since this is a credential and not configuration per se and it 
probably expires during the lifetime of the container.

### cacerts
This optional directory includes CA certificates (pem format) that are added to the 
system trust store.

## additional linux packages

This image is based on Fedora Linux, so additional linux packages should be installed using the `dnf` command.
Several fedora packages are installed in addition to OpenJDK and tomcat; this reduces the need for downstream 
image builds to install common packages.

Current extra packages: 
* network diagnostic tools: curl, openssl, nmap-cat
* astronomy libs: erfa, wcslib

## building it
```
DOCKER_CONTENT_TRUST=1 docker buildx build --platform linux/amd64,linux/arm64 -t cadc-tomcat -f Dockerfile .
```

## checking it
```
docker run --rm -it --user tomcat:tomcat cadc-tomcat:latest /bin/bash

docker run --rm -it cadc-tomcat:latest /bin/bash
```

## running it
```
docker run -rm --user tomcat:tomcat --volume=/path/to/config:/config:ro cadc-tomcat:latest
```

The tomcat uid:gid in the container are an arbitrary high number (8675309); this allows one 
to grant permissions in external volume/filesystem(s) if attached at runtime.

One can expose the tomcat port (-p {external http port}:8080) or use a proxy on the same host to access it via 
the private IP address. 

