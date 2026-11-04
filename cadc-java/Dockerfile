FROM almalinux:9

LABEL org.opencontainers.image.authors="pdowler.cadc@gmail.com"

# create opencadc user:group with known uid:gid
RUN groupadd --gid 8675309 opencadc \
    && useradd --uid 8675309 --home-dir / --shell /sbin/nologin \
        --no-create-home --no-user-group --no-log-init opencadc

RUN mkdir /.ssl && chown opencadc:opencadc /.ssl && chmod 700 /.ssl

# install repos
RUN dnf install -y epel-release \
    && dnf clean all

#    dnf install -y adoptium-temurin-java-repository \
  
# install required software
RUN dnf install -y java-21-openjdk-headless ca-certificates which nmap-ncat wcslib erfa \
    && dnf clean all

# system settings and permissions
COPY src/nofiles.conf /etc/security/limits.d/

# allow opencadc to install and block CA certs on startup
RUN chgrp opencadc /etc/pki/ca-trust/source/anchors /etc/pki/ca-trust/source/blocklist \
    && chmod g+w /etc/pki/ca-trust/source/anchors /etc/pki/ca-trust/source/blocklist

# dest dir for update-ca-trust --output (see startup script)
RUN mkdir -p /opencadc/certs && chown -R opencadc:opencadc /opencadc

# location for JVM heap dump
RUN mkdir /dumps && chown opencadc:opencadc /dumps

COPY src/cadc-java-init /usr/bin/cadc-java-init

ENTRYPOINT ["/usr/bin/cadc-java-init"]



