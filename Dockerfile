# Use Node 22 on Debian bookworm (good balance: small + glibc)
FROM node:22-bookworm-slim

# System deps often needed by node-gyp / report libs
RUN apt-get update && apt-get install -y \
    git ca-certificates curl unzip python3 build-essential \
    && rm -rf /var/lib/apt/lists/*

# Workdir and dependency install
WORKDIR /app
COPY package*.json ./
RUN npm ci --omit=dev=false

# Copy your test source
COPY . .

# Environment for CI-style runs
ENV CI=1

# Default command (can be overridden by docker compose)
CMD ["npx", "wdio", "run", "./wdio.conf.js"]
