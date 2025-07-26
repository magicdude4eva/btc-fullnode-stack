FROM debian:bookworm-slim

LABEL maintainer="magicdude4eva" \
      org.opencontainers.image.authors="magicdude4eva" \
      org.opencontainers.image.documentation="https://github.com/magicdude4eva/btc-fullnode-stack" \
      org.opencontainers.image.description="Fulcrum 1.12.0 - Bitcoin/BCH Electrum-style server for Synology NAS"

# ---- build-time args ---------------------------------------------------------
ARG FULCRUM_VERSION=1.12.0
ENV FULCRUM_VERSION=${FULCRUM_VERSION}  \
    DEBIAN_FRONTEND=noninteractive      \
	TERM=xterm-256color \
	FORCE_COLOR=true \
	NPM_CONFIG_COLOR=always \
	MOCHA_COLORS=true

# ---- install required packages -----------------------------------------------
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        wget \
        ca-certificates \
        libssl3 \
        libstdc++6 && \
    rm -rf /var/lib/apt/lists/*

# ---- install Fulcrum ---------------------------------------------------------
WORKDIR /opt/fulcrum

RUN wget -q https://github.com/cculianu/Fulcrum/releases/download/v${FULCRUM_VERSION}/Fulcrum-${FULCRUM_VERSION}-x86_64-linux.tar.gz && \
    tar -xzf Fulcrum-${FULCRUM_VERSION}-x86_64-linux.tar.gz && \
    mv Fulcrum-${FULCRUM_VERSION}-x86_64-linux/Fulcrum /usr/local/bin/ && \
    mv Fulcrum-${FULCRUM_VERSION}-x86_64-linux/FulcrumAdmin /usr/local/bin/ && \
    rm -rf Fulcrum-${FULCRUM_VERSION}-x86_64-linux*

# ---- volumes ------------------------------------------------------------------
# Fulcrum DB
VOLUME ["/fulcrum"]
# TLS (optional)
VOLUME ["/ssl"]

# ---- exposed ports -----------------------------------------------------------
# tcp / ssl / ws / wss
EXPOSE 50001 50002 50003 50004
# admin
EXPOSE 8000
# stats
EXPOSE 8080

# ---- start Fulcrum -----------------------------------------------------------
ENTRYPOINT ["Fulcrum"]
CMD ["/config/fulcrum.conf"]
