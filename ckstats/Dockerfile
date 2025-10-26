# ckstats/Dockerfile

FROM node:20-slim

LABEL maintainer="magicdude4eva" \
      org.opencontainers.image.authors="magicdude4eva" \
      org.opencontainers.image.documentation="https://github.com/magicdude4eva/btc-fullnode-stack" \
      org.opencontainers.image.description="CKStats - A stats dashboard for CKPool-Solo, with PostgreSQL"

ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Europe/Vienna \
    TERM=xterm-256color \
    PNPM_HOME=/root/.local/share/pnpm

# NEW: pin upstream to a specific commit
ARG CKSTATS_REF=""
ENV CKSTATS_REF=${CKSTATS_REF}

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      git curl cron supervisor ca-certificates postgresql postgresql-contrib && \
    corepack enable && \
    corepack prepare pnpm@latest --activate && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && update-ca-certificates --fresh

VOLUME ["/var/lib/postgresql/data"]

RUN sed -i 's/^\(local\s\+all\s\+all\s\+\)peer/\1trust/' /etc/postgresql/*/main/pg_hba.conf || true

WORKDIR /app

ARG LOG_PATH
COPY .env.template /tmp/.env.template
RUN sed "s|LOG_PATH|${LOG_PATH}|" /tmp/.env.template > /tmp/.env

# Clone & build CKStats at the exact commit if provided
RUN git clone --filter=blob:none --depth 1 https://github.com/mrv777/ckstats.git /app && \
    if [ -n "$CKSTATS_REF" ]; then \
      git -C /app fetch origin "$CKSTATS_REF" --depth 1 && \
      git -C /app checkout --detach "$CKSTATS_REF"; \
    fi && \
    mv /tmp/.env . && \
    pnpm install --frozen-lockfile || pnpm install

COPY startup.sh supervisord.conf ckstats-cron /app/

RUN mv supervisord.conf /etc/supervisor/conf.d/supervisord.conf && \
    mv ckstats-cron /etc/cron.d/ && \
    chmod +x startup.sh && \
    chmod 0644 /etc/cron.d/ckstats-cron && \
    crontab /etc/cron.d/ckstats-cron

EXPOSE 3000
CMD ["/app/startup.sh"]
