FROM node:20-slim

LABEL maintainer="magicdude4eva" \
      org.opencontainers.image.authors="magicdude4eva" \
      org.opencontainers.image.documentation="https://github.com/magicdude4eva/btc-fullnode-stack" \
      org.opencontainers.image.description="CKStats - A stats dashboard for CKPool-Solo, with PostgreSQL"

# Set environment
ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Europe/Vienna \
    TERM=xterm-256color \
    PNPM_HOME=/root/.local/share/pnpm

# Install system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    git \
    curl \
    cron \
    supervisor \
    ca-certificates \
    postgresql postgresql-contrib && \
    apt-get upgrade -y && \
    curl -fsSL https://get.pnpm.io/install.sh | bash - && \
    ln -s ${PNPM_HOME}/pnpm /usr/local/bin/pnpm && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    update-ca-certificates --fresh

# Postgres data volume
VOLUME ["/var/lib/postgresql/data"]

# Fix Postgres trust authentication (non-fatal fallback)
RUN sed -i 's/^\(local\s\+all\s\+all\s\+\)peer/\1trust/' /etc/postgresql/*/main/pg_hba.conf || true

# Set working directory
WORKDIR /app

# Build-time ARG for dynamic .env content (e.g., log path)
ARG LOG_PATH
COPY .env.template /tmp/.env.template
RUN sed "s|LOG_PATH|${LOG_PATH}|" /tmp/.env.template > /tmp/.env

# Clone & build CKStats
RUN git clone https://github.com/mrv777/ckstats.git . && \
    mv /tmp/.env . && \
    pnpm install

# Copy runtime configs
COPY startup.sh supervisord.conf ckstats-cron /app/

RUN mv supervisord.conf /etc/supervisor/conf.d/supervisord.conf && \
    mv ckstats-cron /etc/cron.d/ && \
    chmod +x startup.sh && \
    chmod 0644 /etc/cron.d/ckstats-cron && \
    crontab /etc/cron.d/ckstats-cron

# Web UI
EXPOSE 3000

# Start all services via startup script
CMD ["/app/startup.sh"]
