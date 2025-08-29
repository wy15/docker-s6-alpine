FROM alpine:latest
ARG TARGETARCH
ENV S6_KEEP_ENV=1
ARG S6_OVERLAY_VERSION=1.22.1.0

RUN set -x && apk add --no-cache curl coreutils tzdata shadow \
  && if [ "$TARGETARCH" = "amd64" ]; then \
      S6_ARCH="x86_64"; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
      S6_ARCH="aarch64"; \
    fi \
  && curl -L -s https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-${S6_ARCH}.tar.gz | tar xvzf - -C / \
  && groupmod -g 911 users && \
  useradd -u 911 -U -d /config -s /bin/false abc && \
  usermod -G users abc && \
  mkdir -p /app /config /defaults && \
  apk del --no-cache curl \
  apk del --purge \
  rm -rf /tmp/*

ENTRYPOINT [ "/init" ]
