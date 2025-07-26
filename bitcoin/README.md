# Bitcoin Core (bitcoind)
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
