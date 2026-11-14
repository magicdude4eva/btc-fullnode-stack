# Fulcrum
![GitHub stars](https://img.shields.io/github/stars/magicdude4eva/btc-fullnode-stack?style=social)
![GitHub forks](https://img.shields.io/github/forks/magicdude4eva/btc-fullnode-stack?style=social)
[![Docker Pulls](https://img.shields.io/docker/pulls/magicdude4eva/btc-fulcrum)](https://hub.docker.com/r/magicdude4eva/btc-fulcrum)
[![Docker Stars](https://img.shields.io/docker/stars/magicdude4eva/btc-fulcrum)](https://hub.docker.com/r/magicdude4eva/btc-fulcrum)
![GitHub issues](https://img.shields.io/github/issues/magicdude4eva/btc-fullnode-stack)
![GitHub last commit](https://img.shields.io/github/last-commit/magicdude4eva/btc-fullnode-stack)
![GitHub repo size](https://img.shields.io/github/repo-size/magicdude4eva/btc-fullnode-stack)
![Maintenance](https://img.shields.io/maintenance/yes/2025)
[![Contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg)](https://github.com/magicdude4eva/btc-fullnode-stack/issues)

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

[paypal]: https://paypal.me/GerdNaschenweng

🍻 **Support my work**  
All my software is free and built in my personal time. If it helps you or your business, please consider a small donation via [PayPal][paypal] — it keeps the coffee ☕ and ideas flowing!

💸 **Crypto Donations**  
You can also send crypto to one of the addresses below:

```
(BTC)   bc1qdgdkk7l98pje8ny9u4xavsvrea8dw6yu8jpnyf
(ETH)   0x5986f713A538D6bCaC0865564dCD45E2600A3469  
(POL)   0x5986f713A538D6bCaC0865564dCD45E2600A3469
(CRO)   0xb83c3Fe378F5224fAdD7a0f8a7dD33a6C96C422C (Cronos or Crypto.com Paystring magicdude$paystring.crypto.com)
(BNB)   0x5986f713A538D6bCaC0865564dCD45E2600A3469
(LTC)   ltc1qexst2exxksfyg7erfzlfrm23twkjgf7e5fn64t
(DOGE)  DMQsxc9XGF6526drBJDZeX7AjFDJsEz4mN
(SOL)   t4bYQCUuoCUrp7kJ4Mz314npcTuKoUSXj28UgdMrfTb
```

🧾 **Recommended Platforms**  
- 👉 [Curve.com](https://www.curve.com/join#DWPXKG6E): Add your Crypto.com card to Apple Pay  
- 🔐 [Crypto.com](https://crypto.com/app/ref6ayzqvp): Stake and get your free Crypto Visa card  
- 📈 [Binance](https://accounts.binance.com/register?ref=13896895): Trade altcoins easily  
- 🇦🇹 [Bitpanda](https://www.bitpanda.com/?ref=803565861482697995): Buy crypto, stocks and precious metals with a European broker
