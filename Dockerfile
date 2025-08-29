FROM alpine:latest
ARG TARGETARCH
ARG S6_OVERLAY_VERSION=3.2.1.0

RUN set -x && apk add --no-cache curl coreutils tzdata shadow \
  && if [ "$TARGETARCH" = "amd64" ]; then \
      S6_ARCH="x86_64"; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
      S6_ARCH="aarch64"; \
    fi \
  && curl -L -s https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz | tar xvpJf - -C / \
  && curl -L -s https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-${S6_ARCH}.tar.xz | tar xvpJf - -C / \
  && mkdir -p /app /config /defaults && \
  apk del --no-cache curl \
  apk del --purge \
  rm -rf /tmp/*

ENTRYPOINT [ "/init" ]
