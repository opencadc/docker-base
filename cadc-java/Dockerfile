FROM almalinux:10

ARG BASE_IMAGE_VERSION="1.8"
LABEL org.opencadc.image.base.version="${BASE_IMAGE_VERSION}" \
    org.opencontainers.image.version="${BASE_IMAGE_VERSION}" \
    org.opencontainers.image.authors="https://github.com/opencadc"

# create opencadc user:group with known uid:gid
RUN groupadd --gid 8675309 opencadc \
    && useradd --uid 8675309 --gid 8675309 --home-dir / --shell /sbin/nologin \
        --no-create-home --no-log-init opencadc

# install repos
#RUN dnf install -y epel-release \
#    && dnf clean all

# install required software
RUN dnf install -y ca-certificates which openssl nmap-ncat acl attr curl \
    && dnf install -y java-21-openjdk-headless \
    && dnf clean all

# system settings and permissions
COPY src/nofiles.conf /etc/security/limits.d/

RUN mkdir /.ssl && chown opencadc:opencadc /.ssl && chmod 700 /.ssl

# allow opencadc to install and block CA certs on startup
RUN chgrp opencadc /etc/pki/ca-trust/source/anchors /etc/pki/ca-trust/source/blocklist \
    && chmod g+w /etc/pki/ca-trust/source/anchors /etc/pki/ca-trust/source/blocklist

# dest dir for update-ca-trust --output (see startup script)
RUN mkdir -p /opencadc/certs && chown -R opencadc:opencadc /opencadc

# location for JVM heap dump
RUN mkdir /dumps && chown opencadc:opencadc /dumps

COPY src/cadc-java-init /usr/bin/cadc-java-init

USER 8675309:8675309
ENTRYPOINT ["/usr/bin/cadc-java-init"]



