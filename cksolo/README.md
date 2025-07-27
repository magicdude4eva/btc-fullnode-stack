# CKPool Solo (cksolo)
![GitHub stars](https://img.shields.io/github/stars/magicdude4eva/btc-fullnode-stack?style=social)
![GitHub forks](https://img.shields.io/github/forks/magicdude4eva/btc-fullnode-stack?style=social)
[![Docker Pulls](https://img.shields.io/docker/pulls/magicdude4eva/btc-cksolo)](https://hub.docker.com/r/magicdude4eva/btc-cksolo)
[![Docker Stars](https://img.shields.io/docker/stars/magicdude4eva/btc-cksolo)](https://hub.docker.com/r/magicdude4eva/btc-cksolo)
![GitHub issues](https://img.shields.io/github/issues/magicdude4eva/btc-fullnode-stack)
![GitHub last commit](https://img.shields.io/github/last-commit/magicdude4eva/btc-fullnode-stack)
![GitHub repo size](https://img.shields.io/github/repo-size/magicdude4eva/btc-fullnode-stack)
![Maintenance](https://img.shields.io/maintenance/yes/2025)
[![Contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg)](https://github.com/magicdude4eva/btc-fullnode-stack/issues)

This container runs [CKPool Solo](https://bitbucket.org/ckolivas/ckpool-solo/src/solobtc/) — a minimalistic, direct-to-node mining pool. It allows your ASIC miner (e.g. NerdQAxe) to submit work to your local `bitcoind` node without any third-party dependency.

## Features
- Lightweight C-based stratum server  
- Solo mining compatible with Bitcoin Core  
- Logs output to bind-mounted volume  
- Supports runtime and configuration directory mounts  
- Based on `debian:bookworm-slim`  

## Usage (via Docker Compose)
Before starting, ensure:
- Bitcoin Core is fully synced  
- A proper `ckpool.conf` exists in your mounted config path

Start cksolo with:
```bash
docker compose --profile bitcoin up -d ckpool
```

Monitor logs with:
```bash
tail -f ./cksolo/logs/ckpool.log
```

## ⚠️ Do Not Start Before Sync

Ensure your Bitcoin node reports:
```bash
"initialblockdownload": false
```

Otherwise, shares will be rejected and energy wasted.

## Volumes
The container expects the following volumes:
- `/cksolo/logs/ckpool.log` — mining log (parsed by CKStats)
- `/cksolo/config/ckpool.conf` — stratum config with address, payout, and pool name

## Ports
- `3333` – Default stratum port

## Configuration
You must provide a valid `ckpool.conf` in the `/ckpool-conf` volume mount.  The container will exit if the file is missing.

## Example config snippet

---
"btcd": "/bitcoin/.bitcoin/bitcoin.conf",
"rpcurl": "http://user:pass@bitcoind:8332",
"coin": "bitcoin",
"logfile": "/logs/ckpool.log",
"port": 3333
---

## Notes
- This image compiles `ckpool-solo` from source (solobtc branch)  
- The stratum server writes all output to `/logs/ckpool.log`  
- Does **not** include a web UI — pair with `ckstats` if desired

## 📦 Image Details

- Based on upstream `ckpool-solo` branch
- Exposes:
  - Port `3333` for Stratum mining connections

More: [Overview README](https://github.com/magicdude4eva/btc-fullnode-stack)


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