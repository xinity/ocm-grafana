FROM alpine

MAINTAINER Rachid Zarouali <xinity77@gmail.com>

#install dependencies
RUN apk add --update curl
ENV \
    ALPINE_GLIBC_URL="https://circle-artifacts.com/gh/andyshinn/alpine-pkg-glibc/6/artifacts/0/home/ubuntu/alpine-pkg-glibc/packages/x86_64/" \
    GLIBC_PKG="glibc-2.21-r2.apk" \
    GLIBC_BIN_PKG="glibc-bin-2.21-r2.apk"

RUN \
    apk add --update -t deps wget ca-certificates openssl \
    && apk add --update -t openssl \
    && cd /tmp \
    && wget --no-check-certificate ${ALPINE_GLIBC_URL}${GLIBC_PKG} ${ALPINE_GLIBC_URL}${GLIBC_BIN_PKG} \
    && apk add --allow-untrusted ${GLIBC_PKG} ${GLIBC_BIN_PKG} \
    && /usr/glibc/usr/bin/ldconfig /lib /usr/glibc/usr/lib \
    && echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf \
    && apk del --purge deps \
    && rm /tmp/* /var/cache/apk/*

# grafana
ENV GRAFANA_VERS=3.0.0-beta51460725904
WORKDIR /tmp
RUN mkdir /opt
RUN curl -O https://grafanarel.s3.amazonaws.com/builds/grafana-${GRAFANA_VERS}.linux-x64.tar.gz
RUN tar -zxf grafana-${GRAFANA_VERS}.linux-x64.tar.gz -C /opt
RUN mv /opt/grafana-${GRAFANA_VERS} /opt/grafana

# config file
RUN touch /opt/grafana/conf/grafana.ini

# Data and log directories
RUN mkdir -p /var/lib/grafana /var/log/grafana-web

#expose grafana tcp port
EXPOSE 3000

WORKDIR /opt/grafana
#expose docker image volume
VOLUME ["/var/lib/grafana"]

ENTRYPOINT ["/opt/grafana/bin/grafana-server","-config", "/opt/grafana/conf/grafana.ini","web"]

