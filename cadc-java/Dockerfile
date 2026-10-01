FROM fedora:44

# MAINTAINER deprecated but upstream fedora image still has it
LABEL org.opencontainers.image.authors="pdowler.cadc@gmail.com" maintainer="pdowler.cadc@gmail.com"

# create opencadc user:group with known uid:gid
RUN groupadd --gid 8675309 opencadc \
    && useradd --uid 8675309 --home-dir / --shell /sbin/nologin \
        --no-create-home --no-user-group --no-log-init opencadc

# add adoptium repo for temurin OpenJDK
RUN dnf install -y adoptium-temurin-java-repository \
    && fedora-third-party enable \
    && dnf clean all

# install required software
# install open source astronomy libraries needed by opencadc JNI libs
# install minimal set of diagnostics tools: mainly for network connectivity
RUN dnf install -y temurin-21-jre-headless ca-certificates which acl attr \
    && dnf install -y wcslib erfa curl openssl nmap-ncat \
    && dnf clean all

# system settings and permissions
COPY src/nofiles.conf /etc/security/limits.d/

# allow opencadc to install CA certs and run update-ca-trust at startup
RUN chgrp -R opencadc \
        /etc/pki/ca-trust \
        /etc/pki/tls \
        /etc/pki/java \
        /etc/ssl \
    && chmod -R g+w \
        /etc/pki/ca-trust \
        /etc/pki/tls \
        /etc/pki/java \
        /etc/ssl \
    && chown opencadc /etc/pki/ca-trust/extracted/pem/directory-hash

# cleanup existing files
RUN find /etc/pki/ca-trust/extracted -type f -delete

# JVM settings
ENV JAVA_OPTS="-Xms512m -Xmx2048m -XX:+UseParallelGC -XX:+HeapDumpOnOutOfMemoryError -XX:OnError='cat hs_err_pid%p.log'"

RUN mkdir /.ssl && chown opencadc:opencadc /.ssl && chmod 700 /.ssl

COPY src/cadc-java-init /usr/bin/cadc-java-init

ENTRYPOINT ["/usr/bin/cadc-java-init"]
