FROM fedora:37

# MAINTAINER deprecated but upstream fedora image still has it
LABEL org.opencontainers.image.authors="pdowler.cadc@gmail.com" \
        maintainer="pdowler.cadc@gmail.com"

# create tomcat user:group with known uid:gid
RUN groupadd --gid 8675309 tomcat \
    && useradd --uid 8675309 --home-dir /usr/share/tomcat --shell /sbin/nologin \
        --no-create-home --no-user-group --no-log-init tomcat


# install required software
# install open source JDBC driver(s)
# install open source astronomy libraries needed by opencadc JNI libs
# install minimal set of diagnostics tools: mainly for network connectivity
RUN dnf install -y java-11-openjdk-headless.x86_64 tomcat.noarch ca-certificates sudo \
    && dnf install -y postgresql-jdbc \
    && dnf install -y wcslib erfa curl openssl nmap-ncat \
    && rpm -e --nodeps java-17-openjdk-headless.x86_64 \
    && dnf clean all

# link jdbc driver(s) into tomcat lib
RUN cd /usr/share/tomcat/lib/ \
    && for jar in $(find /usr/share/java/postgresql-jdbc /usr/share/java/ongres-s* -type f); do ln -s $jar .; done

# system settings and permissions
COPY src/nofiles.conf /etc/security/limits.d/
COPY src/server.xml /etc/tomcat/server.xml
COPY src/tomcat-sudo-perms /etc/sudoers.d/

RUN chgrp tomcat /etc/pki/ca-trust/source/anchors \
    && chmod 775 /etc/pki/ca-trust/source/anchors \
    && chmod 440 /etc/sudoers.d/tomcat-sudo-perms \
    && chmod 664 /etc/tomcat/catalina.properties \
    && chmod 664 /etc/tomcat/tomcat.conf

# hide tomcat version in error pages
RUN mkdir -p /usr/share/tomcat/lib/org/apache/catalina/util
COPY src/ServerInfo.properties /usr/share/tomcat/lib/org/apache/catalina/util

## see https://bugzilla.redhat.com/show_bug.cgi?id=1773148
RUN touch /etc/sudo.conf && echo "Set disable_coredump false" > /etc/sudo.conf

# JVM settings
RUN echo JAVA_OPTS=\"-Xms512m -Xmx2048m -XX:+UseParallelGC \$JAVA_OPTS\" >> /etc/tomcat/tomcat.conf \
    && echo JAVA_OPTS=\"-XX:+HeapDumpOnOutOfMemoryError -XX:OnError=\'cat hs_err_pid%p.log\' \$JAVA_OPTS\" >> /etc/tomcat/tomcat.conf

# disable all jar scanning for TLDs
RUN echo "tomcat.util.scan.StandardJarScanFilter.jarsToSkip=*.jar" >> /etc/tomcat/catalina.properties

# standard welcome page
RUN mkdir -p /usr/share/tomcat/webapps/ROOT
COPY src/index.html /usr/share/tomcat/webapps/ROOT/
RUN chown -R tomcat.tomcat /usr/share/tomcat/webapps/ROOT

COPY src/cadc-tomcat-start /usr/bin/cadc-tomcat-start
CMD ["/usr/bin/cadc-tomcat-start"]

