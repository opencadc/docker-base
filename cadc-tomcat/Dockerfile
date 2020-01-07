FROM fedora:30 

# install required software
RUN dnf update -y
RUN dnf install -y java-1.8.0-openjdk-headless.x86_64 tomcat.noarch ca-certificates postgresql-jdbc
RUN dnf clean all

# link JDBC driver(s) into tomcat
RUN ln -s  /usr/share/java/postgresql-jdbc/postgresql.jar /usr/share/tomcat/lib/postgresql-jdbc.jar

# JVM settings
RUN echo JAVA_OPTS=\"-Xms512m -Xmx2048m -XX:+UseParallelGC -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/logs/tomcat-dump.%p.hprof \$JAVA_OPTS\" >> /etc/tomcat/tomcat.conf

COPY src/nofiles.conf /etc/security/limits.d/
COPY src/server.xml /etc/tomcat/server.xml

# disable all jar scanning for TLDs
RUN echo "tomcat.util.scan.StandardJarScanFilter.jarsToSkip=*.jar" >> /etc/tomcat/catalina.properties

# mountable dir; config also appears to be in $HOME/config to tomcat
RUN mkdir -p /config /logs && ln -s /config /root/config

# other directories
RUN mkdir -p /root/.ssl /usr/share/tomcat/webapps/ROOT && chmod 700 /root/.ssl
COPY src/index.html /usr/share/tomcat/webapps/ROOT/

COPY src/cadc-tomcat-start /usr/bin/cadc-tomcat-start
CMD ["/usr/bin/cadc-tomcat-start"]

