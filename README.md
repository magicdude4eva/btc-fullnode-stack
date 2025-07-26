# 🟧 Synology Bitcoin Full Node Stack

This project sets up a **self-hosted Bitcoin infrastructure** on a **Synology NAS** using Docker. It is tailored for power users who want to:

- Run a **fully validating Bitcoin full node**
- Enable **solo mining** using their own ASIC hardware
- Analyze mining statistics and mempool data
- Operate with **full control**, **no third-party reliance**, and **local-first** architecture

---

## ⚙️ What's Included?

This stack brings together multiple containers to deliver a comprehensive, modular Bitcoin infrastructure:

| Component             | Description |
|----------------------|-------------|
| **Bitcoin Core**     | The backbone: a full Bitcoin node that validates the entire blockchain and exposes RPC interfaces. |
| **Fulcrum**          | High-performance Electrum server indexing the blockchain for wallet queries. |
| **CKPool (Solo)**    | A modified solo mining pool implementation allowing ASIC miners to mine directly against your local node. |
| **CKStats**          | Parses CKPool logs, stores mining events in PostgreSQL, and provides insights into hash rate, luck, and shares. |
| **Bitcoin Explorer** | Web-based block explorer using RPC access to your Bitcoin Core. |
| **Mempool**          | Powerful mempool visualizer and blockchain explorer (requires InfluxDB + Grafana). |
| **InfluxDB**         | Time-series database used by Mempool and CKStats to store block and mempool metrics. |
| **Grafana**          | Dashboards for visualizing metrics from InfluxDB (e.g., hash rate, block times, mempool size). |

---

## 💡 Why This Project?

Running your own Bitcoin full node is the most secure and private way to use Bitcoin. By adding:

- **CKPool-solo**, you bypass centralized mining pools
- **Fulcrum**, you serve your own wallets like Electrum
- **Mempool + Explorer**, you get full insight into mempool congestion and fee estimation
- **Self-hosted stack on Synology**, you stay in full control of your data and operations

This project automates the setup of a resilient, modular, and observable Bitcoin stack using Docker — optimized for **Synology NAS environments** but portable to any Linux system.

---

## 🔐 Self-Custody, Full Control, Maximum Privacy

This stack is designed around **sovereignty**:

- No API keys  
- No cloud services  
- No third-party wallets  
- No dependence on public electrum or explorer services  

You validate everything.  You own everything.  You mine for yourself.


---

## 🛠️ Installation & Setup

To get started, you only need a Synology NAS with Docker support (or any Linux machine) and around **700 GB of free disk space**. Performance varies depending on storage type.

### 🧠 Storage Recommendations

For best results, especially during initial blockchain sync:

- **Optimal Setup:** Place the full blockchain and indexes on a **fast NVMe volume** (≈700 GB total).
- **Hybrid Setup (Recommended for Synology):**
  - **Slow HDD** (e.g., `/volume1/data`) for blockchain data (`blocks` and `chainstate`)
  - **Fast NVMe** (e.g., `/volume2/docker/appdata`) for:
    - Bitcoin indexes (`indexes` folder, ~100 GB)
    - All Docker configs and containers

💡 On a Synology **DS1019+**, using this hybrid layout, the entire Bitcoin blockchain synced in just **4 days**.

---

### 🚀 Setup Steps

1. **SSH into your Synology NAS** (or Linux host).

2. **Download and execute the setup script**:

   ```bash
   curl -sSL https://raw.githubusercontent.com/magicdude4eva/btc-fullnode-stack/main/setup.sh | bash
   ```

3. **Follow the prompts**:
   - Confirm or adjust the slow-storage path (`/volume1/data`) for blockchain data
   - Confirm or adjust the fast-storage path (`/volume2/docker/appdata`) for configs, indexes, and container volumes

The setup script will:

- ✅ Clone this repository into your fast NVMe volume
- 🔐 Generate secure Bitcoin RPC credentials using `rpcauth.py`
- 🔧 Automatically inject those credentials into:
  - `bitcoin.conf` (for Bitcoin Core)
  - `bitcoin-explorer.conf` (for BTC RPC Explorer)
  - `ckpool.conf` (for the solo mining pool)
- 📁 Prepare the required directory structure with proper ownership:
  - UID/GID mapping for Docker containers
  - Special user mappings for Postgres (CKStats), Grafana, and InfluxDB
- 📊 Ensure fast index storage for optimal Bitcoin node performance

## Starting

To get your full node up and running, follow these steps:

### 1. Start the Bitcoin Node

Begin by launching the Bitcoin Core node. This is the foundation for all other components.

```bash
docker compose --profile bitcoin up -d bitcoind
```

You can follow the logs to monitor its startup and sync status:
```bash
docker logs -f bitcoin-node
```
### 2. Monitor Blockchain Sync Progress

Initial synchronization can take **2–4 days**, depending on your system's NVMe/HDD speed and CPU performance.

You can check the progress using the following command:

```bash
docker exec -it bitcoin-node bitcoin-cli -conf=/bitcoin/bitcoin.conf -datadir=/bitcoin getblockchaininfo
```
Example output: 
```json
{
  "chain": "main",
  "blocks": 907250,
  "headers": 907250,
  "bestblockhash": "000000000000000000017d6a511247219bdc9da8c5150eb3add0b41f99793613",
  "bits": "1702349e",
  "difficulty": 127620086886391.8,
  "verificationprogress": 0.9999998634713957,
  "initialblockdownload": false,
  "size_on_disk": 767801082543,
  "pruned": false
}
```

Watch for `"initialblockdownload": false` which means that the blockchain has fully synced and is ready. This means your node is fully synced and ready to serve RPC requests.

> ⚠️ **Important:** Do not start `cksolo` (the mining pool) or your miner before this status is reached. Mining during the initial download phase will lead to rejected shares and wasted energy.

## CKSolo - Solo Mining Pool

[CKSolo](https://bitbucket.org/ckolivas/ckpool-solo/src/solobtc/) is a lightweight, minimalist solo mining pool originally developed by Con Kolivas. It is ideal for miners who want to mine solo, directly submitting shares to their own Bitcoin Core node without relying on a third-party pool.

In this setup, **CKSolo** connects to your `bitcoind` node and handles incoming mining work submissions via the Stratum protocol. If your miner finds a valid block, it is directly submitted and credited to your Bitcoin address.

> 🛠 CKSolo logs all activity into `/volume2/docker/appdata/cksolo/logs/ckpool.log`, which is read by CKStats for statistics.

### ⛏ Start CKSolo

Once `bitcoind` is fully synced, start CKSolo using:

```bash
docker compose --profile bitcoin up -d ckpool
```

You can monitor the log output with:
```bash
tail -f /volume2/docker/appdata/cksolo/logs/ckpool.log
```

## CKStats - CKSolo Stats Collector

**CKStats** is a companion service for CKSolo. It continuously parses the CKSolo `ckpool.log` file and stores relevant mining metrics in an embedded PostgreSQL database. This enables historical tracking of:

- Accepted and rejected shares
- Miner activity and status
- Found blocks (if you're lucky)
- Hashrate trends

CKStats is designed to be lightweight and runs alongside the solo pool to provide insights without adding unnecessary load or complexity.

### 📊 Start CKStats

Once `ckpool` is running, start CKStats using:

```bash
docker compose --profile bitcoin up -d ckstats
```

This will spin up the `ckstats` service, connect it to the CKSolo-log file, and initialize the database under under `./ckstats/pgdata`

> ℹ️ The `pgdata` directory is owned by user `100` and group `103` to match PostgreSQL's internal user. Do not change these permissions.

### ⚙️ Rebuilding or Reinitializing the Database

CKStats supports two environment variables for maintenance and development purposes, which are set in the `docker-compose.yml`:
```yaml
  REBUILD_APP: "0"              # Set to "1" to rebuild the app and run the migration
  DB_REINITIALISE: "0"          # Set to "1" to delete the entire database and wipe /ckstats/pgdata/*
```

Setting `REBUILD_APP=1` will trigger a fresh rebuild of the application and rerun any required database migrations during container startup.  
This is useful if you made changes to the CKStats codebase or updated dependencies and want to apply schema changes.

Setting `DB_REINITIALISE=1` will **wipe all data** by deleting the entire PostgreSQL data directory (`/ckstats/pgdata/`) and initialize it from scratch.  
Use this **with caution**, as all previously logged stats will be lost.

🛑 **Important:**  
These flags only take effect during container startup. After a successful rebuild or reset, **you must set both values back to `0`** in your `docker-compose.yml` file to prevent unintended data loss on future restarts.

CKStats automatically handles:
- Full application rebuild (if requested)
- Database schema migrations
- Fresh initialization (if reset)

Once the CKStats container is running, you can access the stats dashboard via `http://<your-server-ip>:4000`
### Example Screenshots
<img width="50%" alt="image" src="https://github.com/user-attachments/assets/570f1b54-2cdb-4958-acf5-f546ad249e43" />
<img width="50%" alt="image" src="https://github.com/user-attachments/assets/5fe3c2b4-d78f-4944-ac1d-ab8d00952d01" />

CKStats updates automatically and gives you complete visibility into the performance of your CKPool solo mining setup.


## Donations are always welcome

[paypal]: https://paypal.me/GerdNaschenweng

🍻 **Support my work**  
All my software is free and built in my personal time. If it helps you or your business, please consider a small donation via [PayPal][paypal] — it keeps the coffee ☕ and ideas flowing!

💸 **Crypto Donations**  
You can also send crypto to one of the addresses below:

```
(CRO)   0xBAdB43af444055c4031B79a76F74895469BA0CD7 (Cronos)  
(USDC)  0xBAdB43af444055c4031B79a76F74895469BA0CD7  
(ETH)   0xfc316ba7d8dc325250f1adfafafc320ad75d87c0  
(BNB)   0xfc316ba7d8dc325250f1adfafafc320ad75d87c0  
(BTC)   1Mhq9SY6DzPhs7PNDx7idXFDWsGtyn7GWM  
Crypto.com PayString: magicdude$paystring.crypto.com
```

🧾 **Recommended Platforms**  
- 👉 [Curve.com](https://www.curve.com/join#DWPXKG6E): Add your Crypto.com card to Apple Pay  
- 🔐 [Crypto.com](https://crypto.com/app/ref6ayzqvp): Stake and get your free Crypto Visa card  
- 📈 [Binance](https://accounts.binance.com/register?ref=13896895): Trade altcoins easily
