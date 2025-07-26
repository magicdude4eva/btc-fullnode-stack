# CKStats
CKStats is a lightweight stats collector that parses the `ckpool.log` from your [CKPool Solo](../ckpool) instance. It stores mining metrics in a PostgreSQL database and provides a dashboard to monitor miner performance over time.

## Features
- Web UI for tracking blocks, shares, and worker stats  
- Includes PostgreSQL database backend  
- Supervisor and cron-based scheduling for block sync  
- Easy deployment via Docker Compose  

CKStats gives solo miners a real-time and historical view into their mining performance — perfect for setups using NerdQAxe, Whatsminer, or Antminer hardware.


## Usage (via Docker Compose)
CKStats depends on a working CKPool-Solo instance and reads its logs.  Start it as part of a `docker-compose` setup:
```bash
docker compose --profile bitcoin up -d ckstats
```

View the dashboard at: `http://<your-nas-ip>:4000`

Logs will show when the service is connected and processing:
```bash
[info] Watching log: /cksolo/logs/ckpool.log
[info] Inserted share: bc1... | 60.1 TH/s | valid
```

## 🔐 Environment Variables
You can control rebuild/reset behavior with:
```bash
REBUILD_APP: "1"          # Rebuild app and apply DB migrations
DB_REINITIALISE: "1"      # Wipe DB and re-init schema
```

Set both back to `"0"` after use to avoid data loss.

## 🧠 Architecture
- Parses: `/cksolo/logs/ckpool.log`
- Stores: PostgreSQL under `/ckstats/pgdata`
- Runs lightweight backend web interface on port `4000`

> ⚠️ PostgreSQL runs as user `100:103`. Do not change ownership of `pgdata`, or the DB may break.


## Volumes
- `/ckstats/pgdata` — persistent database volume (PostgreSQL)
- `/ckstats/config` — app config (optional overrides)

## Ports
- `4000` – Web UI

## 🧪 Rebuild Instructions
To rebuild the app (e.g., after code changes or updates):

1. Stop the container.
2. Set `REBUILD_APP=1` in `docker-compose.yml`
3. Start again:  
   ```bash
   docker compose --profile bitcoin up -d ckstats
   ```bash
4. Once done, set `REBUILD_APP=0` to prevent future unnecessary rebuilds.


## Important Notes
- The image uses `supervisord` to manage PostgreSQL, CKStats, and cron jobs  
- Make sure the CKPool log path is accessible inside the container  
- Check the cron job (`ckstats-cron`) for log sync timing

## 📦 Image Details
- Based on Node.js 20 Alpine
- Uses TypeORM for DB access
- No frontend framework - just server-rendered HTML (fast + lean)

More: [Main Stack Overview](https://github.com/magicdude4eva/btc-fullnode-stack)

## Donations are always welcome
