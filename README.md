# Mythbound Launcher

Electron-based game launcher with auto-update functionality and modern UI.

## Requirements

- Node.js 16+
- Linux (Ubuntu 18.04+, Debian 10+, CentOS 7+, Fedora 30+)

## Quick Setup

```bash
git clone https://github.com/tibia-oce/mythbound-launcher/
cd mythbound-launcher

# Ubuntu/Debian
make setup && make build
```

## Manual Installation

### Install System Dependencies

**Ubuntu/Debian:**

```bash
sudo apt-get install -y nodejs npm build-essential libnss3-dev \
    libatk-bridge2.0-dev libdrm2 libxkbcommon-dev libxcomposite-dev \
    libxdamage-dev libxrandr-dev libgbm-dev libxss-dev libasound2-dev
```

### Install Node Dependencies

```bash
cd mythbound-launcher && npm install
```

## Build Commands

```bash
make help
make build-linux
make run-appimage
```
