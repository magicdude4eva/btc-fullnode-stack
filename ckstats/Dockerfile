FROM node:20-slim

# Environment
ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Europe/Vienna \
    TERM=xterm-256color

# Install system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    postgresql postgresql-contrib \
    git \
    curl \
    ca-certificates \
    supervisor \
    cron && \
    apt-get upgrade -y && \
    apt-get clean && \
    curl -fsSL https://get.pnpm.io/install.sh | bash - && \
    ln -s ~/.local/share/pnpm/pnpm /usr/local/bin/pnpm && \
    rm -rf /var/lib/apt/lists/* && \
    update-ca-certificates --fresh

# Declare Postgres data dir for mounting
VOLUME ["/var/lib/postgresql/data"]

# Fix trust authentication (non-fatal in case path doesn't exist yet)
RUN sed -i 's/^\(local\s\+all\s\+all\s\+\)peer/\1trust/' /etc/postgresql/*/main/pg_hba.conf || true

# Set working directory
WORKDIR /app

# Copy env template and generate final .env (required before build)
ARG LOG_PATH
COPY .env.template /tmp/.env.template
RUN sed "s|LOG_PATH|${LOG_PATH}|" /tmp/.env.template > /tmp/.env

# Clone repo and build before copying startup configs
RUN git clone https://github.com/mrv777/ckstats.git . && \
    mv /tmp/.env . && \
    pnpm install
    
# Copy startup scripts and config (frequently changed, avoid invalidating cache early)
COPY startup.sh supervisord.conf ckstats-cron /app/
RUN mv /app/supervisord.conf /etc/supervisor/conf.d/supervisord.conf && \
    mv /app/ckstats-cron /etc/cron.d/ && \
    chmod +x /app/startup.sh && \
    chmod 0644 /etc/cron.d/ckstats-cron && \
    crontab /etc/cron.d/ckstats-cron

EXPOSE 3000

# Start all services via startup script
CMD ["/app/startup.sh"]
