FROM fedora:42

# MAINTAINER deprecated but upstream fedora image still has it
LABEL org.opencontainers.image.authors="pdowler.cadc@gmail.com" maintainer="pdowler.cadc@gmail.com"

# create tomcat user:group with known uid:gid
RUN groupadd --gid 8675309 tomcat \
    && useradd --uid 8675309 --home-dir /usr/share/tomcat --shell /sbin/nologin \
        --no-create-home --no-user-group --no-log-init tomcat

# install required software
# install open source JDBC driver(s)
# install open source astronomy libraries needed by opencadc JNI libs
# install filesystem utils
# install minimal set of diagnostics tools: mainly for network connectivity
RUN dnf install -y tomcat.noarch ca-certificates which gawk \
    && dnf install -y postgresql-jdbc \
    && dnf install -y wcslib erfa curl openssl nmap-ncat acl attr \
    && dnf clean all

# link jdbc driver(s) into tomcat lib
RUN cd /usr/share/tomcat/lib/ \
    && for jar in $(find /usr/share/java/postgresql-jdbc /usr/share/java/ongres-s* -type f); do ln -s $jar .; done

# system settings and permissions
COPY src/nofiles.conf /etc/security/limits.d/
COPY src/server.xml /etc/tomcat/server.xml

RUN chmod 664 /etc/tomcat/catalina.properties /etc/tomcat/tomcat.conf

# allow tomcat to install CA certs and run update-ca-trust at startup
RUN chgrp -R tomcat \
        /etc/pki/ca-trust \
        /etc/pki/tls \
        /etc/pki/java \
        /etc/ssl \
    && chmod -R g+w \
        /etc/pki/ca-trust \
        /etc/pki/tls \
        /etc/pki/java \
        /etc/ssl \
    && chown tomcat /etc/pki/ca-trust/extracted/pem/directory-hash

# cleanup existing files
RUN find /etc/pki/ca-trust/extracted -type f -delete

# hide tomcat version in error pages
RUN mkdir -p /usr/share/tomcat/lib/org/apache/catalina/util
COPY src/ServerInfo.properties /usr/share/tomcat/lib/org/apache/catalina/util

# JVM settings
RUN echo JAVA_OPTS=\"-Xms512m -Xmx2048m -XX:+UseG1GC -XX:MaxGCPauseMillis=200 \$JAVA_OPTS\" >> /etc/tomcat/tomcat.conf \
    && echo JAVA_OPTS=\"-XX:+HeapDumpOnOutOfMemoryError -XX:OnError=\'cat hs_err_pid%p.log\' \$JAVA_OPTS\" >> /etc/tomcat/tomcat.conf

# disable all jar scanning for TLDs
RUN echo "tomcat.util.scan.StandardJarScanFilter.jarsToSkip=*.jar" >> /etc/tomcat/catalina.properties

COPY src/cadc-tomcat-start /usr/bin/cadc-tomcat-start
CMD ["/usr/bin/cadc-tomcat-start"]

