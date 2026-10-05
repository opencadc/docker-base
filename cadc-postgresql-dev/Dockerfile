FROM fedora:43

# MAINTAINER deprecated but upstream fedora image still has it
LABEL org.opencontainers.image.authors="pdowler.cadc@gmail.com" maintainer="pdowler.cadc@gmail.com"

# external URLs; allow --build-arg switch
ARG PGDG=https://download.postgresql.org/pub/repos/yum/reporpms/F-43-x86_64/pgdg-fedora-repo-latest.noarch.rpm
ARG PGSERVER="postgresql17-server postgresql17-contrib"
ARG PGSPHERE=https://cadc-west-01.canfar.net/vault/files/pdowler/rpms/pgsphere17-1.5.2-1.fc43.x86_64.rpm

# install repositories, server, extensions
RUN dnf -y install ${PGDG} \
    && dnf -y install ${PGSERVER} ${PGSPHERE} \
    && dnf -y clean all

RUN mkdir -p /config /logs
COPY src/config/* /var/lib/pgsql/
COPY src/init/* /usr/local/bin/

RUN chown postgres:postgres /logs /var/lib/pgsql/*.conf

RUN ln -s /usr/pgsql-17/bin/pg_isready /usr/local/bin/pg_isready

COPY src/cadc-dev-postgresql-start /usr/bin/
CMD ["/usr/bin/cadc-dev-postgresql-start"]
