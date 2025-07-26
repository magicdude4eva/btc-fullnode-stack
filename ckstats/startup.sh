#!/bin/bash
set -e

# Load .env if it exists
if [ -f /app/.env ]; then
    export $(grep -v '^#' /app/.env | xargs)
fi

DB_USER="${DB_USER:-ckstats-mainnet}"
DB_NAME="${DB_NAME:-ckstats-mainnet}"

# Optional rebuild of app
if [ "$REBUILD_APP" = "1" ]; then
    echo "🔁 [startup] REBUILD_APP=1 detected - removing build marker..."
    rm -f /app/.build.complete
fi

# Optional DB reinitialisation
if [ "$DB_REINITIALISE" = "1" ]; then
    echo "🧨 [startup] DB_REINITIALISE=1 detected - clearing PostgreSQL data directory..."
    rm -rf /var/lib/postgresql/data/*
fi

# Function to check if PostgreSQL is running
is_postgres_running() {
    su - postgres -c "psql -U postgres -c 'SELECT 1'" > /dev/null 2>&1
}

# Function to start PostgreSQL if not running
ensure_postgres_running() {
    if ! is_postgres_running; then
        echo "🚀 [startup] Starting PostgreSQL..."
        su - postgres -c "/usr/lib/postgresql/15/bin/pg_ctl -D /var/lib/postgresql/data -w start"
    else
        echo "✅ [startup] PostgreSQL already running or in the process of starting."
    fi

    echo "⏳ [startup] Waiting for PostgreSQL to accept connections..."
    for i in {1..10}; do
        if is_postgres_running; then
            echo "✅ [startup] PostgreSQL is ready."
            return
        fi
        sleep 1
    done

    echo "❌ [startup] PostgreSQL did not become ready in time."
    exit 1
}

# Function to stop PostgreSQL if running
ensure_postgres_stopped() {
    if is_postgres_running; then
        echo "🛑 [startup] Stopping PostgreSQL..."
        su - postgres -c "/usr/lib/postgresql/15/bin/pg_ctl -D /var/lib/postgresql/data -w stop"
    fi
}

# Function to build and run migrations/seed
build_and_migrate() {
    cd /app

    echo "🧪 [startup] Running migrations and seed..."
    pnpm migration:run
    pnpm seed

    if [ ! -f /app/.build.complete ]; then
        echo "🔨 [startup] Running pnpm build..."
        pnpm build && touch /app/.build.complete
    else
        echo "✅ [startup] Build already complete (skipping)."
    fi
}

echo "🔁 [startup] Checking PostgreSQL data directory..."
if [ ! -s "/var/lib/postgresql/data/PG_VERSION" ]; then
    echo "📦 [startup] Initializing PostgreSQL cluster..."
    chown -R postgres:postgres /var/lib/postgresql/data
    su - postgres -c "/usr/lib/postgresql/15/bin/initdb -D /var/lib/postgresql/data"

    ensure_postgres_running

    echo "👤 [startup] Creating user if needed..."
    su - postgres -c "psql -tc \"SELECT 1 FROM pg_roles WHERE rolname = '${DB_USER}'\"" | grep -q 1 || \
        su - postgres -c "psql -c \"CREATE ROLE \\\"${DB_USER}\\\" WITH LOGIN SUPERUSER;\""

    echo "🛠️ [startup] Creating database if needed..."
    su - postgres -c "psql -tc \"SELECT 1 FROM pg_database WHERE datname = '${DB_NAME}'\" | grep -q 1 || createdb -O '${DB_USER}' '${DB_NAME}'"

    build_and_migrate
else
    echo "✅ [startup] PostgreSQL data already initialized."
    ensure_postgres_running
    build_and_migrate
fi

ensure_postgres_stopped

echo "🚦 [startup] Starting supervisord..."
exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
