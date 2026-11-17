FROM almalinux:10

LABEL org.opencontainers.image.authors="pdowler.cadc@gmail.com"

# create tomcat user:group with known uid:gid
RUN groupadd --gid 8675309 tomcat \
    && useradd --uid 8675309 --gid 8675309 \
        --home-dir /usr/share/tomcat \
        --shell /sbin/nologin \
        --no-create-home --no-log-init tomcat

# install repos
#RUN dnf install -y epel-release \
#    && dnf clean all

# install required software
# install open source JDBC driver(s)
# install filesystem utils
# install minimal set of diagnostics tools: mainly for network connectivity
RUN dnf install -y ca-certificates which openssl nmap-ncat acl attr curl gpg tar \
    && dnf install -y java-21-openjdk-headless postgresql-jdbc \
    && dnf clean all

# apache tomcat 9 official binary release
ARG TOMCAT_CDN=https://dlcdn.apache.org
ARG TOMCAT_URL=https://downloads.apache.org
ARG TOMCAT_MAJOR=9
ARG TOMCAT_VERSION=9.0.124

# used by entrypoint and beyond
ENV TOMCAT_INSTALL=apache-tomcat-${TOMCAT_VERSION}.tar.gz
ENV CATALINA_HOME=/opt/tomcat
ENV TOMCAT_CONF=/opt/tomcat/conf

COPY src/apache/KEYS /root/KEYS

RUN mkdir -p /opt \
    && cd /opt \
    && curl -fsSLO "${TOMCAT_CDN}/tomcat/tomcat-${TOMCAT_MAJOR}/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz" \
    && curl -fsSLO "${TOMCAT_URL}/tomcat/tomcat-${TOMCAT_MAJOR}/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz.asc" \
    && curl -fsSLO "${TOMCAT_URL}/tomcat/tomcat-${TOMCAT_MAJOR}/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz.sha512" \
    && sha512sum -c "apache-tomcat-${TOMCAT_VERSION}.tar.gz.sha512" \
    && export GNUPGHOME="$(mktemp -d)" \
    && gpg --batch --import /root/KEYS \
    && gpg --batch --verify "apache-tomcat-${TOMCAT_VERSION}.tar.gz.asc" "apache-tomcat-${TOMCAT_VERSION}.tar.gz" \
    && tar xfz "apache-tomcat-${TOMCAT_VERSION}.tar.gz" \
    && mv apache-tomcat-${TOMCAT_VERSION} tomcat \
    && cd tomcat && rm -rf webapps && ln -s /usr/share/tomcat/webapps . && cd .. \
    && rm -rf "$GNUPGHOME" apache-tomcat-*

# link jdbc driver(s) into tomcat lib
RUN cd /opt/tomcat/lib/ \
    && for jar in $(find /usr/share/java/postgresql-jdbc /usr/share/java/ongres-s* -type f); do ln -s $jar .; done

COPY src/server.xml /opt/tomcat/conf/server.xml
RUN chmod 664 /opt/tomcat/conf/catalina.properties # /opt/tomcat/conf/tomcat.conf
    
# system settings and permissions
COPY src/nofiles.conf /etc/security/limits.d/

# allow tomcat to install and block CA certs on startup
RUN chgrp tomcat /etc/pki/ca-trust/source/anchors /etc/pki/ca-trust/source/blocklist \
    && chmod g+w /etc/pki/ca-trust/source/anchors /etc/pki/ca-trust/source/blocklist

# dest dir for update-ca-trust --output (see startup script)
RUN mkdir -p /opencadc/certs && chown -R tomcat:tomcat /opencadc

# location for JVM heap dump
RUN mkdir /dumps && chown tomcat:tomcat /dumps

# hide tomcat version in error pages
RUN mkdir -p /opt/tomcat/lib/org/apache/catalina/util
COPY src/ServerInfo.properties /opt/tomcat/lib/org/apache/catalina/util

# disable all jar scanning for TLDs
RUN echo "tomcat.util.scan.StandardJarScanFilter.jarsToSkip=*.jar" >> /opt/tomcat/conf/catalina.properties

# backwards compatible place for downstream builds to put war file(s)
RUN mkdir -p /usr/share/tomcat/webapps

# fix ownership
RUN chown -R tomcat:tomcat /opt/tomcat /usr/share/tomcat

COPY src/cadc-tomcat-start /usr/bin/cadc-tomcat-start

USER 8675309:8675309
CMD ["/usr/bin/cadc-tomcat-start"]

