FROM alpine:latest
ARG TARGETARCH
ENV S6_KEEP_ENV=1

RUN set -x && apk add --no-cache curl coreutils tzdata shadow \
  && if [ "$TARGETARCH" = "amd64" ]; then \
      S6_ARCH="x86_64"; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
      S6_ARCH="aarch64"; \
    fi \
  && curl -L -s https://github.com/just-containers/s6-overlay/releases/download/v3.2.1.0/s6-overlay-${S6_ARCH}.tar.xz | tar xvJf - -C / \
  && groupmod -g 911 users && \
  useradd -u 911 -U -d /config -s /bin/false abc && \
  usermod -G users abc && \
  mkdir -p /app /config /defaults && \
  apk del --no-cache curl \
  apk del --purge \
  rm -rf /tmp/*

ENTRYPOINT [ "/init" ]
