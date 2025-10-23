FROM fedora:42

# MAINTAINER deprecated but upstream fedora image still has it
LABEL org.opencontainers.image.authors="pdowler.cadc@gmail.com" maintainer="pdowler.cadc@gmail.com"

# external URLs; allow --build-arg switch
ARG PGDG=https://download.postgresql.org/pub/repos/yum/reporpms/F-42-x86_64/pgdg-fedora-repo-latest.noarch.rpm
ARG PGSERVER="postgresql15-server postgresql15-contrib"
ARG PGSPHERE=https://ws-cadc.canfar.net/vault/files/pdowler/rpms/pgsphere15-1.4.2-1.fc42.x86_64.rpm

# install repositories, server, extensions
# But first create /var/lib/pgsql because ${PGDG} expects it to exist.
RUN mkdir -p /var/lib/pgsql && chown 26:26 /var/lib/pgsql
RUN dnf -y install ${PGDG} \
    && dnf -y install ${PGSERVER} ${PGSPHERE} \
    && dnf -y clean all

RUN mkdir -p /config /logs /var/lib/pgsql/15
COPY src/config/* /var/lib/pgsql/15/
COPY src/init/* /usr/local/bin/

COPY src/cadc-dev-postgresql-start /usr/bin/
CMD ["/usr/bin/cadc-dev-postgresql-start"]

