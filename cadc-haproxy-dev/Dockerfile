FROM fedora:40

RUN dnf -y install haproxy rsyslog && dnf clean all

# set up the configuration for rsyslog. haproxy requires it for logging
#COPY src/rsyslog/rsyslog.conf /etc/rsyslog.conf
COPY src/rsyslog/rsyslog_haproxy.conf /etc/rsyslog.d/haproxy.conf

# set config for haproxy
COPY src/haproxy/haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg

RUN mkdir /logs

COPY src/entrypoint /usr/bin/entrypoint
CMD [ "/usr/bin/entrypoint", "-f", "/usr/local/etc/haproxy/haproxy.cfg" ]
