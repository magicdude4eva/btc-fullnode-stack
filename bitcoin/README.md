# Bitcoin Core (bitcoind) – Dockerized Full Node
![GitHub stars](https://img.shields.io/github/stars/magicdude4eva/btc-fullnode-stack?style=social)
![GitHub forks](https://img.shields.io/github/forks/magicdude4eva/btc-fullnode-stack?style=social)
[![Docker Pulls](https://img.shields.io/docker/pulls/magicdude4eva/btc-bitcoin)](https://hub.docker.com/r/magicdude4eva/btc-bitcoin)
[![Docker Stars](https://img.shields.io/docker/stars/magicdude4eva/btc-bitcoin)](https://hub.docker.com/r/magicdude4eva/btc-bitcoin)
![GitHub issues](https://img.shields.io/github/issues/magicdude4eva/btc-fullnode-stack)
![GitHub last commit](https://img.shields.io/github/last-commit/magicdude4eva/btc-fullnode-stack)
![GitHub repo size](https://img.shields.io/github/repo-size/magicdude4eva/btc-fullnode-stack)
![Maintenance](https://img.shields.io/maintenance/yes/2025)
[![Contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg)](https://github.com/magicdude4eva/btc-fullnode-stack/issues)

This Docker image runs a fully validating Bitcoin Core (bitcoind) node, tailored for deployment on Synology NAS devices like the DS1019+ (tested with 16GB RAM and 2TB NVMe) or similar setups. It’s designed for solo-mining stacks but works just as well for full node operators, Electrum server backends, or anyone who wants a stable, secure, and efficient Bitcoin node.

## Features
- Based on official Bitcoin Core binaries  
- Lightweight and optimized for Docker  
- Optimized for SSD/NVMe use – perfect for fast validation and indexing
- RPC authentication using rpcuser/rpcpassword or rpcauth
- ZMQ support for raw block/tx notifications (e.g., for CKPool or Fulcrum)
- Fast sync ready – ideal for reindexing or txindex-heavy workloads
- UID/GID support for Synology or non-root environments
- P2P-ready – fully participates in the Bitcoin network
- Integrates cleanly with CKPool, Fulcrum, mempool.space, and more
- Tested on Synology DSM with Docker – stable and production-ready
- Low power footprint when idle, ideal for always-on nodes
- Supports solo mining with CKPool or similar  

## Version
Default: `29.0`  
Override with build ARG `BITCOIN_VERSION`.

## Usage (via Docker Compose)
You can launch this container standalone or as part of the full stack. Start the Bitcoin node:

```bash
docker compose --profile bitcoin up -d bitcoind
```

Follow logs:
```bash
docker logs -f bitcoin-node
```

## Volumes
This image expects data to be stored in the following volumes:
- `/bitcoin` – contains `bitcoin.conf`, `wallet`, and chainstate  
- `/blocks` – optional, separate mount for block data  

## Ports
- `8332` – RPC  
- `8333` – P2P  

## Example bitcoin.conf
Place this in `/bitcoin/bitcoin.conf`:

```bash
server=1
txindex=1
rpcuser=bitcoin
rpcpassword=your_secure_password
rpcallowip=0.0.0.0/0
rpcbind=0.0.0.0
zmqpubrawblock=tcp://0.0.0.0:28332
zmqpubrawtx=tcp://0.0.0.0:28333
```

### Using rpcauth for remote authentication
Before setting up remote authentication, you will need to generate the `rpcauth` line that will hold the credentials for the Bitcoind Core daemon. You can use the official `rpcauth.py`⁠ script to generate this line for you, including a random password that is printed to the console:

```bash
❯ curl -sSL https://raw.githubusercontent.com/bitcoin/bitcoin/master/share/rpcauth/rpcauth.py | python - <username>

String to be appended to bitcoin.conf:
rpcauth=foo:7d9ba5ae63c3d4dc30583ff4fe65a67e$9e3634e81c11659e3de036d0bf88f89cd169c1039e6e09607562d54765c649cc
Your password:
qDDZdeQ5vw9XXFeVnXT4PZ--tGN2xNjjR4nrtyszZx0=
```

Adjust credentials and ZMQ ports based on your setup.

## Notes
- Based on `debian:bookworm-slim`
- Installs official Bitcoin Core binaries
- Exposes ports `8332` (RPC) and `8333` (P2P)
- Fully compatible with Fulcrum, CKPool, and Mempool
- Use NVMe for indexes; HDD is OK for block data
- Setup script handles UID/GID, directory layout, and credentials
- Always use a secure RPC password  
- Ensure firewall rules match exposed ports  
- For solo mining, use with [cksolo](https://github.com/magicdude4eva/btc-fullnode-stack)  
- Official Bitcoin Core: https://bitcoincore.org

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