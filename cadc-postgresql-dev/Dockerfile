FROM fedora:40

# external URLs; allow --build-arg switch
ARG PGDG=https://download.postgresql.org/pub/repos/yum/reporpms/F-40-x86_64/pgdg-fedora-repo-latest.noarch.rpm

ARG PGSERVER="postgresql15-server-15.8-1PGDG.f40.x86_64 postgresql15-contrib-15.8-1PGDG.f40.x86_64"
ARG PGSPHERE=https://ws-cadc.canfar.net/vault/files/pdowler/rpms/pgsphere15-1.4.2-1.fc40.x86_64.rpm

# install repositories, server, extensions
RUN dnf -y install ${PGDG} \
    && dnf -y install ${PGSERVER} ${PGSPHERE} \
    && dnf -y clean all

RUN mkdir -p /config /logs /var/lib/pgsql/15
COPY src/config/* /var/lib/pgsql/15/
COPY src/init/* /usr/local/bin/

COPY src/cadc-dev-postgresql-start /usr/bin/
CMD ["/usr/bin/cadc-dev-postgresql-start"]

