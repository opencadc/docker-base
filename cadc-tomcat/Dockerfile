FROM almalinux:9

LABEL org.opencontainers.image.authors="pdowler.cadc@gmail.com"

# create tomcat user:group with known uid:gid
RUN groupadd --gid 8675309 tomcat \
    && useradd --uid 8675309 --home-dir /usr/share/tomcat --shell /sbin/nologin \
        --no-create-home --no-user-group --no-log-init tomcat

# install required software
# install open source JDBC driver(s)
# install filesystem utils
# install minimal set of diagnostics tools: mainly for network connectivity
RUN dnf install -y --allowerasing ca-certificates which gawk openssl nmap-ncat acl attr curl \
    && dnf install -y java-21-openjdk-headless \
    && dnf install -y --setopt=strict=0 --allowerasing  tomcat postgresql-jdbc \
    && rpm -e --nodeps java-11-openjdk-headless \
    && dnf clean all

# link jdbc driver(s) into tomcat lib
RUN cd /usr/share/tomcat/lib/ \
    && for jar in $(find /usr/share/java/postgresql-jdbc /usr/share/java/ongres-s* -type f); do ln -s $jar .; done

# system settings and permissions
COPY src/nofiles.conf /etc/security/limits.d/
COPY src/server.xml /etc/tomcat/server.xml

RUN chmod 664 /etc/tomcat/catalina.properties /etc/tomcat/tomcat.conf

# allow tomcat to install and block CA certs on startup
RUN chgrp tomcat /etc/pki/ca-trust/source/anchors /etc/pki/ca-trust/source/blocklist \
    && chmod g+w /etc/pki/ca-trust/source/anchors /etc/pki/ca-trust/source/blocklist

# dest dir for update-ca-trust --output (see startup script)
RUN mkdir -p /opencadc/certs && chown -R tomcat:tomcat /opencadc

# location for JVM heap dump
RUN mkdir /dumps && chown tomcat:tomcat /dumps

# hide tomcat version in error pages
RUN mkdir -p /usr/share/tomcat/lib/org/apache/catalina/util
COPY src/ServerInfo.properties /usr/share/tomcat/lib/org/apache/catalina/util

# disable all jar scanning for TLDs
RUN echo "tomcat.util.scan.StandardJarScanFilter.jarsToSkip=*.jar" >> /etc/tomcat/catalina.properties

COPY src/cadc-tomcat-start /usr/bin/cadc-tomcat-start
CMD ["/usr/bin/cadc-tomcat-start"]

