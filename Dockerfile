ARG TARGETARCH
FROM alpine:latest

ENV S6_KEEP_ENV=1

RUN set -x && apk add --no-cache curl coreutils tzdata shadow \
  && if [ "$TARGETARCH" = "x86_64" ]; then \
      S6_ARCH="amd64"; \
    elif [ "$TARGETARCH" = "aarch64" ]; then \
      S6_ARCH="aarch64"; \
    else \
      echo "unsupported architecture"; \
      exit 1; \
    fi \
  && curl -L -s https://github.com/just-containers/s6-overlay/releases/download/v3.2.1.0/s6-overlay-${S6_ARCH}.tar.gz | tar xvzf - -C / \
  && groupmod -g 911 users && \
  useradd -u 911 -U -d /config -s /bin/false abc && \
  usermod -G users abc && \
  mkdir -p /app /config /defaults && \
  apk del --no-cache curl \
  apk del --purge \
  rm -rf /tmp/*

ENTRYPOINT [ "/init" ]
