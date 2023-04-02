FROM fedora:37

# MAINTAINER deprecated but upstream fedora image still has it
LABEL org.opencontainers.image.authors="pdowler.cadc@gmail.com" \
	maintainer="pdowler.cadc@gmail.com"


# create unpriviledged user:group with known uid:gid
RUN groupadd --gid 8675309 opencadc \
    && useradd --uid 8675309 --home-dir / --shell /sbin/nologin \
        --no-create-home --no-user-group --no-log-init opencadc

# install required software
RUN dnf install -y java-11-openjdk-headless.x86_64 ca-certificates sudo which curl \
    && dnf clean all

# system settings and permissions
COPY src/nofiles.conf /etc/security/limits.d/
COPY src/opencadc-sudo-perms /etc/sudoers.d/

RUN chgrp opencadc /etc/pki/ca-trust/source/anchors \
    && chmod 775 /etc/pki/ca-trust/source/anchors \
    && chmod 440 /etc/sudoers.d/opencadc-sudo-perms

## see https://bugzilla.redhat.com/show_bug.cgi?id=1773148
RUN touch /etc/sudo.conf && echo "Set disable_coredump false" > /etc/sudo.conf

# JVM settings
ENV JAVA_OPTS="-Xms512m -Xmx2048m -XX:+UseParallelGC -XX:+HeapDumpOnOutOfMemoryError -XX:OnError='cat hs_err_pid%p.log'"

RUN mkdir /.ssl && chown opencadc:opencadc /.ssl && chmod 700 /.ssl

COPY src/cadc-java-init /usr/bin/cadc-java-init

ENTRYPOINT ["/usr/bin/cadc-java-init"]
