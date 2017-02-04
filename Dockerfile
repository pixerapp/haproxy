FROM haproxy:1.7.2
MAINTAINER Esen Sagynov <kadishmal@gmail.com>

ENV HAPROXY_USER haproxy

# Create a system group and user to be used by HAProxy.
# Also need to create a directory for HAProxy to be able to `chroot`.
# This is a security measurement.
# Refer to http://cbonte.github.io/haproxy-dconv/configuration-1.5.html#chroot.
RUN groupadd --system ${HAPROXY_USER} && \
  useradd --system --gid ${HAPROXY_USER} ${HAPROXY_USER} && \
  mkdir --parents /var/lib/${HAPROXY_USER} && \
  chown -R ${HAPROXY_USER}:${HAPROXY_USER} /var/lib/${HAPROXY_USER}

COPY config/haproxy.cfg /usr/local/etc/haproxy/

# Now copy the configuration files for `rsyslog` logging service.
COPY config/rsyslog.conf /etc/rsyslog.conf
COPY config/haproxy-rsyslog.conf /etc/rsyslog.d/haproxy.conf

# Create a directory for admin socket used for stats.
RUN mkdir /run/haproxy/

EXPOSE 80
