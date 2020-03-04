FROM fedora:30 

# install required software
RUN dnf makecache -y
RUN dnf update -y
RUN dnf install -y java-1.8.0-openjdk-headless.x86_64 java-1.8.0-openjdk-devel.x86_64 ca-certificates sudo

RUN dnf clean all

# system settings and permissions
COPY src/nofiles.conf /etc/security/limits.d/
COPY src/nobody-sudo-perms /etc/sudoers.d/

RUN chgrp nobody /etc/pki/ca-trust/source/anchors \
    && chmod 775 /etc/pki/ca-trust/source/anchors \
    && chmod 440 /etc/sudoers.d/nobody-sudo-perms

## see https://bugzilla.redhat.com/show_bug.cgi?id=1773148
RUN touch /etc/sudo.conf && echo "Set disable_coredump false" > /etc/sudo.conf

# JVM settings
ENV JAVA_OPTS="-Xms512m -Xmx2048m -XX:+UseParallelGC -XX:+HeapDumpOnOutOfMemoryError -XX:OnError='cat\ hs_err_pid%p.log'"
ENV JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.242.b08-0.fc30.x86_64

RUN mkdir /.ssl && chown nobody.nobody /.ssl && chmod 700 /.ssl

COPY src/cadc-java-init /usr/bin/cadc-java-init

ENTRYPOINT ["/usr/bin/cadc-java-init"]
