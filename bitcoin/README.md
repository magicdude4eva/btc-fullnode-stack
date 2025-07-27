# Bitcoin Core (bitcoind)
![GitHub stars](https://img.shields.io/github/stars/magicdude4eva/btc-fullnode-stack?style=social)
![GitHub forks](https://img.shields.io/github/forks/magicdude4eva/btc-fullnode-stack?style=social)
[![Docker Pulls](https://img.shields.io/docker/pulls/magicdude4eva/btc-bitcoin)](https://hub.docker.com/r/magicdude4eva/btc-bitcoin)
[![Docker Stars](https://img.shields.io/docker/stars/magicdude4eva/btc-bitcoin)](https://hub.docker.com/r/magicdude4eva/btc-bitcoin)
![GitHub issues](https://img.shields.io/github/issues/magicdude4eva/btc-fullnode-stack)
![GitHub last commit](https://img.shields.io/github/last-commit/magicdude4eva/btc-fullnode-stack)
![GitHub repo size](https://img.shields.io/github/repo-size/magicdude4eva/btc-fullnode-stack)
![Maintenance](https://img.shields.io/maintenance/yes/2025)
[![Contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg)](https://github.com/magicdude4eva/btc-fullnode-stack/issues)

This image runs a fully validating Bitcoin Core node (bitcoind), built for use in a local solo-mining stack on a Synology NAS or similar system.

## Features
- Based on official Bitcoin Core binaries  
- Lightweight and optimized for Docker  
- Exposes RPC and P2P ports  
- Persistent volume for blockchain data  
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
