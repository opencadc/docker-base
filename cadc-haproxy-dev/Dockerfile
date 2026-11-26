FROM almalinux:10

ARG BASE_IMAGE_VERSION="1.3"
LABEL org.opencadc.image.base.version="${BASE_IMAGE_VERSION}" \
    org.opencontainers.image.version="${BASE_IMAGE_VERSION}" \
    org.opencontainers.image.authors="https://github.com/opencadc"

# upgrade base for security fixes
RUN dnf upgrade -y && dnf clean all

RUN dnf -y install haproxy && dnf clean all

# default config for haproxy
COPY src/haproxy/haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg

RUN mkdir /logs

COPY src/entrypoint /usr/bin/entrypoint
CMD [ "/usr/bin/entrypoint" ]
