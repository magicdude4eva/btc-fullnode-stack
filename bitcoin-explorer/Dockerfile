# bitcoin-explorer/Dockerfile

FROM node:20-slim

LABEL maintainer="magicdude4eva" \
      org.opencontainers.image.authors="magicdude4eva" \
      org.opencontainers.image.documentation="https://github.com/magicdude4eva/btc-fullnode-stack" \
      org.opencontainers.image.description="Bitcoin RPC Explorer - Web interface to interact with Bitcoin Core, optimized for Synology NAS"

ARG EXPLORER_REF=""   # e.g. v3.4.0
ENV EXPLORER_REF=${EXPLORER_REF}

RUN apt-get update && \
    apt-get install -y --no-install-recommends git ca-certificates && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /app && \
    git clone https://github.com/janoside/btc-rpc-explorer.git /app && \
    git -C /app config --global --add safe.directory /app && \
    if [ -n "$EXPLORER_REF" ]; then git -C /app checkout "$EXPLORER_REF"; fi && \
    cd /app && npm ci --omit=dev

WORKDIR /app
EXPOSE 3002
CMD ["npm", "start"]
