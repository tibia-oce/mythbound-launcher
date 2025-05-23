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

## Configuration

**Update URLs in `main.js`:**

```javascript
const baseUrl = `https://your-server.com/${resource}/`;
```

**Update `package.json`:**

```json
"publish": [{"provider": "generic", "url": "https://your-server.com/"}]
```

**Add icon:** Place `open_games_logo.ico` in `mythbound-launcher/` directory.

## Build Commands

```bash
make dev                 # Development mode
make build               # Production build
make build-appimage      # Build AppImage
make build-deb           # Build Debian package
make build-rpm           # Build RPM package
make clean               # Clean build files
make help                # Show all commands
```

## Server Structure

```
your-server.com/
├── latest.yml                    # Launcher updates
├── YourLauncher-1.0.0.AppImage  # Launcher binary
└── resource1/                   # Game files
    ├── latest.yml               # Game manifest
    └── game-files.zip          # Game archive
```

**Manifest format (latest.yml):**

```yaml
version: "1.0.0"
zipFileName: "game-files.zip"
```

## Project Structure

```
mythbound-launcher/
├── main.js              # Main process
├── index.html          # UI
├── package.json        # Dependencies
└── resources/data/     # Assets (css, js, images)
```
