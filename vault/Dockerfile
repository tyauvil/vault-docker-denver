FROM alpine:3.2

MAINTAINER Ty Auvil <ty.auvil@gmail.com>

ADD repositories /etc/apk/repositories

ADD nsswitch.conf /etc/nsswitch.conf

RUN apk update && apk add vault@testing && rm -f /var/cache/apk/*
