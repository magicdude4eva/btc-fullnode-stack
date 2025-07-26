FROM debian:bookworm-slim

LABEL maintainer="magicdude4eva" \
      description="Bitcoin Core Docker image for Synology NAS (solo mining stack)"

# Set default Bitcoin Core version (can be overridden at build time)
ARG BITCOIN_VERSION=29.0
ENV BITCOIN_VERSION=${BITCOIN_VERSION} \
    TZ=Europe/Vienna \
	DEBIAN_FRONTEND=noninteractive \
	TERM=xterm-256color \
	FORCE_COLOR=true \
	NPM_CONFIG_COLOR=always \
	MOCHA_COLORS=true

# Install only essential packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends wget tar ca-certificates && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /opt/bitcoin

# Download and install Bitcoin Core
RUN wget https://bitcoincore.org/bin/bitcoin-core-${BITCOIN_VERSION}/bitcoin-${BITCOIN_VERSION}-x86_64-linux-gnu.tar.gz && \
    tar -xzf bitcoin-${BITCOIN_VERSION}-x86_64-linux-gnu.tar.gz && \
    mv bitcoin-${BITCOIN_VERSION}/bin/* /usr/local/bin/ && \
    rm -rf bitcoin-${BITCOIN_VERSION}*

# Declare data directory as volume
VOLUME ["/bitcoin"]

EXPOSE 8332 8333

ENTRYPOINT ["bitcoind"]
CMD ["-conf=/bitcoin/bitcoin.conf", "-datadir=/bitcoin", "-blocksdir=/blocks"]
