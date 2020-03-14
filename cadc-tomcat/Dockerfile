FROM fedora:30 

# install required software
RUN dnf makecache -y
RUN dnf update -y
RUN dnf install -y java-1.8.0-openjdk-headless.x86_64 tomcat.noarch ca-certificates sudo

# install and link open source JDBC driver(s) into tomcat
RUN dnf install -y postgresql-jdbc && ln -s /usr/share/java/postgresql-jdbc/postgresql.jar /usr/share/tomcat/lib/

RUN dnf clean all

# system settings and permissions
COPY src/nofiles.conf /etc/security/limits.d/
COPY src/server.xml /etc/tomcat/server.xml
COPY src/tomcat-sudo-perms /etc/sudoers.d/

RUN chgrp tomcat /etc/pki/ca-trust/source/anchors \
    && chmod 775 /etc/pki/ca-trust/source/anchors \
    && chmod 440 /etc/sudoers.d/tomcat-sudo-perms \
    && chmod 664 /etc/tomcat/catalina.properties \
    && chmod 664 /etc/tomcat/tomcat.conf

## see https://bugzilla.redhat.com/show_bug.cgi?id=1773148
RUN touch /etc/sudo.conf && echo "Set disable_coredump false" > /etc/sudo.conf

# JVM settings
RUN echo JAVA_OPTS=\"-Xms512m -Xmx2048m -XX:+UseParallelGC \$JAVA_OPTS\" >> /etc/tomcat/tomcat.conf
RUN echo JAVA_OPTS=\"-XX:+HeapDumpOnOutOfMemoryError -XX:OnError='cat hs_err_pid%p.log' \$JAVA_OPTS\" >> /etc/tomcat/tomcat.conf

# disable all jar scanning for TLDs
RUN echo "tomcat.util.scan.StandardJarScanFilter.jarsToSkip=*.jar" >> /etc/tomcat/catalina.properties

# standard welcome page
RUN mkdir -p /usr/share/tomcat/webapps/ROOT
COPY src/index.html /usr/share/tomcat/webapps/ROOT/
RUN chown -R tomcat.tomcat /usr/share/tomcat/webapps/ROOT

COPY src/cadc-tomcat-start /usr/bin/cadc-tomcat-start
CMD ["/usr/bin/cadc-tomcat-start"]

