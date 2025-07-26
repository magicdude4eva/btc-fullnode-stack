# CKPool Solo (cksolo)
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
