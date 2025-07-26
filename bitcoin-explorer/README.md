# Bitcoin RPC Explorer
This Docker image runs the excellent [BTC RPC Explorer](https://github.com/janoside/btc-rpc-explorer), a simple, self-hosted explorer for the Bitcoin blockchain — ideal for Synology NAS setups.

## Features
- Clean, minimal block explorer UI  
- Connects directly to your Bitcoin Core full node  
- No external APIs or services required  
- Displays blocks, mempool, transactions, wallet stats and more  
- Optimized for Docker and low-resource systems  

## Usage (via Docker Compose)
Make sure your Bitcoin Core node is fully synced and RPC is properly configured. Then start the explorer with:

```bash
docker compose --profile bitcoin up -d bitcoin-explorer
```

Monitor logs with:
```bash
docker logs -f bitcoin-explorer
```

## Environment
Configure the explorer using `.env` or Docker environment variables. Typical values:

- `BTCEXP_HOST=0.0.0.0`  
- `BTCEXP_BITCOIND_HOST=bitcoind`  
- `BTCEXP_BITCOIND_PORT=8332`  
- `BTCEXP_BITCOIND_USER=user`  
- `BTCEXP_BITCOIND_PASS=pass`  

## Volumes (optional)
If you want persistent config/logs:
- `/app/.config/btc-rpc-explorer.env` – explorer env overrides  
- `/app/db` – optional database path  
- `/app/public` – for custom themes or branding

## Port
- `3002` – Web UI interface  

## Example
Open your browser at: `http://<your-server-ip>:3002`. If running on Synology, adjust ports and env vars via the DSM UI or `docker-compose.yml`.

## Notes
- This image builds directly from the official GitHub repo  
- You can customize themes, links, and footer via `.env`  
- Full configuration docs at: https://github.com/janoside/btc-rpc-explorer

## 📦 Image Details

- Based on `node:20-slim`
- Clones from `https://github.com/janoside/btc-rpc-explorer`
- Runs on port `3002`

More: [Overview README](https://github.com/magicdude4eva/btc-fullnode-stack)


## Donations are always welcome
