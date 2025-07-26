#!/bin/bash

set -e

echo "🚀 Starting environment setup for your Synology Bitcoin Full Node stack"

# === 1. Define default paths ===
DEFAULT_SLOW="/volume1/data/bitcoin"
DEFAULT_FAST="/volume2/docker/appdata"
REPO_URL="https://github.com/magicdude4eva/btc-fullnode-stack.git"

# === 2. Prompt user for mount locations ===
read -p "📁 Enter slow-storage path (blockchain data) [${DEFAULT_SLOW}]: " DOCKERDATADIR
DOCKERDATADIR=${DOCKERDATADIR:-$DEFAULT_SLOW}

read -p "🚀 Enter fast-storage path (docker config) [${DEFAULT_FAST}]: " DOCKERCONFDIR
DOCKERCONFDIR=${DOCKERCONFDIR:-$DEFAULT_FAST}

# === 3. Get docker user UID/GID ===
DOCKER_USER="docker"
PUID=$(id -u "$DOCKER_USER")
PGID=$(id -g "$DOCKER_USER")
echo "🔐 Using PUID=$PUID and PGID=$PGID (user: $DOCKER_USER)"

# === 4. Prepare slow-storage for blockchain data ===
echo "📂 Setting up slow-storage at $DOCKERDATADIR"
mkdir -p "${DOCKERDATADIR}/blocks"
chown -R "$PUID:$PGID" "${DOCKERDATADIR}"
chmod 775 "${DOCKERDATADIR}" "${DOCKERDATADIR}/blocks"
find "${DOCKERDATADIR}/blocks" -type f -name "blk*.dat" -exec chmod 664 {} \;

# === 5. Prepare fast-storage structure ===
echo "📂 Setting up fast-storage at $DOCKERCONFDIR"
if [ ! -d "${DOCKERCONFDIR}/.git" ]; then
  echo "📥 Cloning project repo into $DOCKERCONFDIR..."
  git clone "$REPO_URL" "$DOCKERCONFDIR"
else
  echo "✅ Git repo already exists in $DOCKERCONFDIR – skipping clone"
fi

# === 6. Ownership and permissions ===
echo "🛠️ Setting ownership and permissions..."

# Bitcoin
chown -R "$PUID:$PGID" "${DOCKERCONFDIR}/bitcoin"
chmod 777 "${DOCKERCONFDIR}/bitcoin"
chmod 664 "${DOCKERCONFDIR}/bitcoin/"*.{conf,Dockerfile,.dockerignore}
chmod 700 "${DOCKERCONFDIR}/bitcoin/bitcoin-data"

# Bitcoin Explorer
chown -R "$PUID:$PGID" "${DOCKERCONFDIR}/bitcoin-explorer"
chmod 777 "${DOCKERCONFDIR}/bitcoin-explorer"
chmod 664 "${DOCKERCONFDIR}/bitcoin-explorer/"*.{conf,Dockerfile}

# CKPool (cksolo)
chown -R "$PUID:$PGID" "${DOCKERCONFDIR}/cksolo"
chmod 777 "${DOCKERCONFDIR}/cksolo"
chmod 777 "${DOCKERCONFDIR}/cksolo/"{start.sh,Dockerfile,ckpool.conf}
chmod 555 "${DOCKERCONFDIR}/cksolo/.dockerignore"
chmod 775 "${DOCKERCONFDIR}/cksolo/logs"

# CKStats
chown -R "$PUID:$PGID" "${DOCKERCONFDIR}/ckstats"
chmod 777 "${DOCKERCONFDIR}/ckstats"
chmod 664 "${DOCKERCONFDIR}/ckstats/"{Dockerfile,supervisord.conf,ckstats-cron,.env.template}
chmod 755 "${DOCKERCONFDIR}/ckstats/startup.sh"
chown -R 100:103 "${DOCKERCONFDIR}/ckstats/pgdata"
chmod 700 "${DOCKERCONFDIR}/ckstats/pgdata"

# Fulcrum
chown -R "$PUID:$PGID" "${DOCKERCONFDIR}/fulcrum"
chmod 777 "${DOCKERCONFDIR}/fulcrum"
chmod 664 "${DOCKERCONFDIR}/fulcrum/"{Dockerfile,fulcrum.conf}
chmod 777 "${DOCKERCONFDIR}/fulcrum/data"
chmod 755 "${DOCKERCONFDIR}/fulcrum/.dockerignore"

# Grafana
chown -R 472:472 "${DOCKERCONFDIR}/grafana"
chmod 777 "${DOCKERCONFDIR}/grafana"

# InfluxDB
chown -R 1000:users "${DOCKERCONFDIR}/influxdb"
chmod 777 "${DOCKERCONFDIR}/influxdb"

# Mempool
chown -R 1000:users "${DOCKERCONFDIR}/mempool"
chmod 777 "${DOCKERCONFDIR}/mempool"

# Root files
chown "$PUID:$PGID" "${DOCKERCONFDIR}/.env" "${DOCKERCONFDIR}/docker-compose.yml"
chmod 664 "${DOCKERCONFDIR}/.env" "${DOCKERCONFDIR}/docker-compose.yml"

# === 7. Generate RPC credentials ===
echo "🔐 Generating Bitcoin RPC authentication..."
RPC_USER="ckpool"
RPC_OUTPUT=$(curl -sSL https://raw.githubusercontent.com/bitcoin/bitcoin/master/share/rpcauth/rpcauth.py | python3 - "$RPC_USER")
RPC_AUTH=$(echo "$RPC_OUTPUT" | grep '^rpcauth=' | cut -d'=' -f2)
RPC_PASS=$(echo "$RPC_OUTPUT" | awk '/^Your password:/{getline; print}')

echo "   ✔️ RPC user:     $RPC_USER"
echo "   ✔️ RPC password: $RPC_PASS"
echo "   ✔️ RPC auth:     $RPC_AUTH"

# === 8. Update .env values in-place ===
echo "🔄 Updating .env file..."
sed -i "s|^CORE_RPC_USERNAME=.*|CORE_RPC_USERNAME=$RPC_USER|" "${DOCKERCONFDIR}/.env"
sed -i "s|^CORE_RPC_PASSWORD=.*|CORE_RPC_PASSWORD=$RPC_PASS|" "${DOCKERCONFDIR}/.env"
sed -i "s|^BITCOIN_RPCAUTH=.*|BITCOIN_RPCAUTH=$RPC_AUTH|" "${DOCKERCONFDIR}/.env"

# === 9. Replace values in bitcoin.conf ===
echo "🔧 Replacing RPC credentials in bitcoin.conf..."
sed -i "s|^rpcauth=.*|rpcauth=$RPC_AUTH|" "${DOCKERCONFDIR}/bitcoin/bitcoin.conf"

# === 10. Replace values in bitcoin-explorer.conf ===
echo "🔧 Replacing RPC credentials in bitcoin-explorer.conf..."
sed -i "s|^BTCEXP_BITCOIND_USER=.*|BTCEXP_BITCOIND_USER=$RPC_USER|" "${DOCKERCONFDIR}/bitcoin-explorer/bitcoin-explorer.conf"
sed -i "s|^BTCEXP_BITCOIND_PASS=.*|BTCEXP_BITCOIND_PASS=$RPC_PASS|" "${DOCKERCONFDIR}/bitcoin-explorer/bitcoin-explorer.conf"

# === 11. Replace values in ckpool.conf (cksolo) ===
echo "🔧 Replacing RPC credentials in ckpool.conf..."
sed -i 's|"auth": *"[^"]*"|"auth": "'"$RPC_USER"'"|' "${DOCKERCONFDIR}/cksolo/ckpool.conf"
sed -i 's|"pass": *"[^"]*"|"pass": "'"$RPC_PASS"'"|' "${DOCKERCONFDIR}/cksolo/ckpool.conf"

# === 12. Final message ===
echo -e "\n✅ Environment setup complete!"
echo "📌 Review your docker-compose.yml at $DOCKERCONFDIR"
echo "▶️  Run: cd $DOCKERCONFDIR && docker compose up -d"
