FROM balenalib/raspberry-pi-alpine:3.10

ENV ETCD_UNSUPPORTED_ARCH=arm

EXPOSE 2379 2380

ENTRYPOINT ["/etcd"]

ADD package /
