# Fulcrum
This Docker image runs Fulcrum, a high-performance Electrum-style server supporting Bitcoin.  It is part of the btc-fullnode-stack and is designed for self-hosting (e.g. on Synology NAS).

## Features
- Binary-based, no compilation required  
- Small image, minimal dependencies  
- Optimized for use with `bitcoind` and Mempool  
- Includes ports for SSL, TCP, WS, Admin and Stats interfaces  

## Usage (via Docker Compose)
Make sure your Bitcoin Core node is fully synced first. Then you can start Fulcrum with:
```bash
docker compose --profile bitcoin --profile mempool up -d fulcrum
```

Monitor logs with:
```bash
docker logs -f mempool-fulcrum
```

## ⚠️ Initial Index Warning

Initial sync takes time:

- On NVMe: can still take **7+ days**
- ⚠️ Do not stop Fulcrum during indexing
- DSM reboots or interruptions can **corrupt** the index

✅ You'll know Fulcrum is ready when logs say:
```bash
Now listening on 0.0.0.0:50001 (TCP) and 0.0.0.0:50002 (SSL)
Indexing complete. Ready to serve clients.
```


## Volumes
The container expects the following volumes:
- `/fulcrum` – Fulcrum database and index  
- `/ssl` – Optional TLS cert/key (for SSL/WSS)

## Ports
- `50001` – TCP  
- `50002` – SSL  
- `50003` – WebSocket (WS)  
- `50004` – Secure WebSocket (WSS)  
- `8000` – Admin interface  
- `8080` – Stats page  

## Important Notes
- Initial indexing can take several days depending on disk speed  
- On a Synology DS1019+ with NVMe, the first sync took over a week  
- Avoid stopping Fulcrum or the NAS during initial sync to prevent corruption

## 📦 Image Details

- Based on upstream Fulcrum GitHub build
- Exposes ports:
  - `50001` (Electrum TCP)
  - `50002` (Electrum SSL)

More: [Overview README](https://github.com/magicdude4eva/btc-fullnode-stack)



## Donations are always welcome
