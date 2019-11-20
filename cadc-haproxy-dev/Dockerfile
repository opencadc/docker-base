FROM centos:7

RUN yum -y update && yum install -y haproxy && yum install -y rsyslog && yum clean all
ENV OPENSSL_ALLOW_PROXY_CERTS=1

# set up the configuration for rsyslog. haproxy requires it for logging
COPY src/rsyslog/rsyslog.conf /etc/rsyslog.conf
COPY src/rsyslog/rsyslog_haproxy.conf /etc/rsyslog.d/haproxy.conf
RUN rm /etc/rsyslog.d/listen.conf

# set config for haproxy
COPY src/haproxy/haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg
# copy extra CA certs to go into the CA bundle
COPY src/haproxy/cacerts/* /etc/pki/ca-trust/source/anchors/

RUN mkdir /logs
RUN mkdir /conf

COPY src/entrypoint /usr/bin/entrypoint
CMD [ "/usr/bin/entrypoint", "-f", "/usr/local/etc/haproxy/haproxy.cfg" ]
