FROM debian:bookworm-slim

LABEL description="Bitcoin Core Docker image for Synology NAS"

ARG BITCOIN_VERSION
ENV BITCOIN_VERSION=${BITCOIN_VERSION} \
    TZ=Europe/Vienna \
	DEBIAN_FRONTEND=noninteractive \
	TERM=xterm-256color \
	FORCE_COLOR=true \
	NPM_CONFIG_COLOR=always \
	MOCHA_COLORS=true

# Install required packages
RUN apt-get update && \
    apt-get -y install --no-install-recommends wget tar ca-certificates && \
    apt-get -y upgrade && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /opt/bitcoin

# Download and install Bitcoin Core
RUN wget https://bitcoincore.org/bin/bitcoin-core-${BITCOIN_VERSION}/bitcoin-${BITCOIN_VERSION}-x86_64-linux-gnu.tar.gz && \
    tar -xzf bitcoin-${BITCOIN_VERSION}-x86_64-linux-gnu.tar.gz && \
    mv bitcoin-${BITCOIN_VERSION}/bin/* /usr/local/bin/ && \
    rm -rf bitcoin-${BITCOIN_VERSION}*  # cleanup everything

# Create bitcoin data dir
VOLUME ["/bitcoin"]

EXPOSE 8332 8333

ENTRYPOINT ["bitcoind"]
CMD ["-conf=/bitcoin/bitcoin.conf", "-datadir=/bitcoin", "-blocksdir=/blocks"]
