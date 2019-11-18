# base cadc-tomcat image

## Expected deployment
This tomcat instance is expected to have a proxy (HAproxy, apache, nginx) in front that performs
SSL termination and forwards calls via HTTP on port 8080. Optional client certificates are passed through 
via the X-Client-Certificate HTTP header (http-request set-header X-Client-Certificate %[ssl_c_der,base64]
in haproxcy.cfg).

The container expects that a directory is attached to /conf and containing the following:

## catalina.properties
System properties required by tomcat:

tomcat.connector.scheme=https

tomcat.connector.proxyName={SSL terminator host name}

tomcat.connector.proxyPort=443

Additional system properties to configure the application are also added here.

## cadcproxy.pem 
This optional certificate is used to use to make some priviledged server-to-server calls (A&A support).

## building it
docker build -t cadc-tomcat -f Dockerfile .

## checking it
docker run -it --volume=/path/to/conf:/conf:ro cadc-tomcat:latest /bin/bash

## running it
docker run -d -p {external http port}:8080 --volume=/path/to/external/conf:/conf:ro --volume=/path/to/external/logs:/logs:rw cadc-tomcat:latest

