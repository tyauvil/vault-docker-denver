FROM alpine:3.2

MAINTAINER Ty Auvil <ty.auvil@gmail.com>

ADD repositories /etc/apk/repositories
ADD https://dl.bintray.com/mitchellh/consul/0.5.2_web_ui.zip /tmp/consul_web_ui.zip

RUN apk update && apk add consul@testing unzip && \
    rm -f /var/cache/apk/* && \
    mkdir /data && \
    chown consul:consul /data && \
    mkdir -p /opt/consul/ui && \
    chown -R consul:consul /opt/consul/ui && \
    cd /tmp && \
    unzip consul_web_ui.zip && \
    mv dist/* /opt/consul/ui && \
    rm consul_web_ui.zip
