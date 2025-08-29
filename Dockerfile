FROM alpine:latest
ARG TARGETARCH
ENV S6_KEEP_ENV=1
ARG S6_OVERLAY_VERSION=3.2.1.0
if [ "$TARGETARCH" = "amd64" ]; then
      S6_ARCH="x86_64";
    elif [ "$TARGETARCH" = "arm64" ]; then
      S6_ARCH="aarch64";
fi 
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-${S6_ARCH}.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-${S6_ARCH}.tar.xz

RUN set -x && apk add --no-cache curl coreutils tzdata shadow \
  && groupmod -g 911 users && \
  useradd -u 911 -U -d /config -s /bin/false abc && \
  usermod -G users abc && \
  mkdir -p /app /config /defaults && \
  apk del --no-cache curl \
  apk del --purge \
  rm -rf /tmp/*

ENTRYPOINT [ "/init" ]
