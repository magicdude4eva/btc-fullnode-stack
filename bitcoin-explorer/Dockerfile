FROM node:20-slim

# Install dependencies, clone repo, configure Git, install npm deps
RUN apt-get update && \
    apt-get install -y git && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /app && \
    cd /app && \
    git clone https://github.com/janoside/btc-rpc-explorer.git . && \
    git config --global --add safe.directory /app && \
    npm install

WORKDIR /app

EXPOSE 3002

CMD [ "npm", "start" ]
