# Bitcoin RPC Explorer
![GitHub stars](https://img.shields.io/github/stars/magicdude4eva/btc-fullnode-stack?style=social)
![GitHub forks](https://img.shields.io/github/forks/magicdude4eva/btc-fullnode-stack?style=social)
[![Docker Pulls](https://img.shields.io/docker/pulls/magicdude4eva/btc-bitcoin-explorer)](https://hub.docker.com/r/magicdude4eva/btc-bitcoin-explorer)
[![Docker Stars](https://img.shields.io/docker/stars/magicdude4eva/btc-bitcoin-explorer)](https://hub.docker.com/r/magicdude4eva/btc-bitcoin-explorer)
![GitHub issues](https://img.shields.io/github/issues/magicdude4eva/btc-fullnode-stack)
![GitHub last commit](https://img.shields.io/github/last-commit/magicdude4eva/btc-fullnode-stack)
![GitHub repo size](https://img.shields.io/github/repo-size/magicdude4eva/btc-fullnode-stack)
![Maintenance](https://img.shields.io/maintenance/yes/2025)
[![Contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg)](https://github.com/magicdude4eva/btc-fullnode-stack/issues)

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