FROM fedora:40

# MAINTAINER deprecated but upstream fedora image still has it
LABEL org.opencontainers.image.authors="pdowler.cadc@gmail.com" maintainer="pdowler.cadc@gmail.com"

RUN dnf -y install haproxy && dnf clean all

# default config for haproxy
COPY src/haproxy/haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg

RUN mkdir /logs

COPY src/entrypoint /usr/bin/entrypoint
CMD [ "/usr/bin/entrypoint" ]
