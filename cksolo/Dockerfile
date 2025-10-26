# cksolo/Dockerfile

FROM debian:bookworm-slim

LABEL maintainer="magicdude4eva" \
      org.opencontainers.image.authors="magicdude4eva" \
      org.opencontainers.image.documentation="https://github.com/magicdude4eva/btc-fullnode-stack" \
      org.opencontainers.image.description="CKPool Solo - Lightweight stratum server for Bitcoin solo mining"

ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Europe/Vienna \
    TERM=xterm-256color \
    CKPOOL_DIR=/opt/ckpool \
    CKPOOL_CONF=/ckpool-conf/ckpool.conf

# NEW: allow pinning to an exact commit (full SHA)
ARG CKPOOL_REF=""
ENV CKPOOL_REF=${CKPOOL_REF}

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      build-essential git yasm autoconf automake libtool pkgconf libzmq3-dev ca-certificates && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && update-ca-certificates --fresh

WORKDIR ${CKPOOL_DIR}

# Clone & build (checkout commit if provided, else branch)
RUN git clone --depth 1 -b solobtc https://bitbucket.org/ckolivas/ckpool-solo.git . && \
    if [ -n "$CKPOOL_REF" ]; then \
      git fetch origin "$CKPOOL_REF" --depth 1 && git checkout --detach "$CKPOOL_REF"; \
    fi && \
    ./autogen.sh && \
    ./configure CFLAGS="-O2" && \
    make -j"$(nproc)"

RUN mkdir -p /logs /runtime
VOLUME ["/logs", "/runtime", "/bitcoin", "/ckpool-conf"]
EXPOSE 3333

CMD bash -c 'if [ ! -f "$CKPOOL_CONF" ]; then echo "Missing config: $CKPOOL_CONF"; exit 1; fi; /opt/ckpool/src/ckpool -k -B -c "$CKPOOL_CONF" >> /logs/ckpool.log 2>&1'
