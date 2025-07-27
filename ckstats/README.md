# CKStats
![GitHub stars](https://img.shields.io/github/stars/magicdude4eva/btc-fullnode-stack?style=social)
![GitHub forks](https://img.shields.io/github/forks/magicdude4eva/btc-fullnode-stack?style=social)
[![Docker Pulls](https://img.shields.io/docker/pulls/magicdude4eva/btc-ckstats)](https://hub.docker.com/r/magicdude4eva/btc-ckstats)
[![Docker Stars](https://img.shields.io/docker/stars/magicdude4eva/btc-ckstats)](https://hub.docker.com/r/magicdude4eva/btc-ckstats)
![GitHub issues](https://img.shields.io/github/issues/magicdude4eva/btc-fullnode-stack)
![GitHub last commit](https://img.shields.io/github/last-commit/magicdude4eva/btc-fullnode-stack)
![GitHub repo size](https://img.shields.io/github/repo-size/magicdude4eva/btc-fullnode-stack)
![Maintenance](https://img.shields.io/maintenance/yes/2025)
[![Contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg)](https://github.com/magicdude4eva/btc-fullnode-stack/issues)

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

[paypal]: https://paypal.me/GerdNaschenweng

🍻 **Support my work**  
All my software is free and built in my personal time. If it helps you or your business, please consider a small donation via [PayPal][paypal] — it keeps the coffee ☕ and ideas flowing!

💸 **Crypto Donations**  
You can also send crypto to one of the addresses below:

```
(CRO)   0xb83c3Fe378F5224fAdD7a0f8a7dD33a6C96C422C (Cronos)  
(USDC)  0xb83c3Fe378F5224fAdD7a0f8a7dD33a6C96C422C (ERC20)  
(ETH)   0xfc316ba7d8dc325250f1adfafafc320ad75d87c0  
(BNB)   0xfc316ba7d8dc325250f1adfafafc320ad75d87c0
(BTC)   bc1q24fuw84l6whm20umlr56nvqjn908sec8pavk3z  
Crypto.com PayString: magicdude$paystring.crypto.com
```

🧾 **Recommended Platforms**  
- 👉 [Curve.com](https://www.curve.com/join#DWPXKG6E): Add your Crypto.com card to Apple Pay  
- 🔐 [Crypto.com](https://crypto.com/app/ref6ayzqvp): Stake and get your free Crypto Visa card  
- 📈 [Binance](https://accounts.binance.com/register?ref=13896895): Trade altcoins easily