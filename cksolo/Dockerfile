FROM debian:bookworm-slim

# Environment variables
ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Europe/Vienna \
    TERM=xterm-256color \
    CKPOOL_DIR=/opt/ckpool \
    CKPOOL_CONF=/ckpool-conf/ckpool.conf

# Install dependencies and clean up in the same layer
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    git \
    yasm \
    autoconf \
    automake \
    libtool \
    pkgconf \
    libzmq3-dev \
    ca-certificates && \
    apt-get upgrade -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    update-ca-certificates --fresh

# Set working directory
WORKDIR ${CKPOOL_DIR}

# Clone and build ckpool-solo
RUN git clone https://bitbucket.org/ckolivas/ckpool-solo.git . && \
    git checkout solobtc && \
    ./autogen.sh && \
    ./configure CFLAGS="-O2" && \
    make

# Create log and runtime dirs
RUN mkdir -p /logs /runtime

# Declare volumes
VOLUME ["/logs", "/runtime", "/bitcoin", "/ckpool-conf"]

# Expose stratum port
EXPOSE 3333

# Final execution
CMD bash -c 'if [ ! -f "$CKPOOL_CONF" ]; then echo "❌ Missing config: $CKPOOL_CONF"; exit 1; fi; /opt/ckpool/src/ckpool -k -B -c "$CKPOOL_CONF" >> /logs/ckpool.log 2>&1'
