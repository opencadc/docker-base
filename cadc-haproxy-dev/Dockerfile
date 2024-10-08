FROM fedora:40

RUN dnf -y install haproxy && dnf clean all

# default config for haproxy
COPY src/haproxy/haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg

RUN mkdir /logs

COPY src/entrypoint /usr/bin/entrypoint
CMD [ "/usr/bin/entrypoint" ]
