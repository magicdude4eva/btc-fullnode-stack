#!/bin/bash

set -e

echo " Starting CKPool in solo mode..."

cd /opt/ckpool

# Default to ckpool.conf unless overridden
CONF_FILE="/ckpool-conf/ckpool.conf"
if [ ! -f "$CONF_FILE" ]; then
  echo "❌ Missing ckpool.conf at $CONF_FILE"
  exit 1
fi

# Start ckpool in solo mode with config
./src/ckpool -k -B -c "$CONF_FILE"
