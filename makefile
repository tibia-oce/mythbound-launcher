# Mythbound Launcher Makefile
# ============================

APP_NAME = mythbound-launcher
BUILD_DIR = dist
SRC_DIR = mythbound-launcher
NODE_MODULES = $(SRC_DIR)/node_modules
PACKAGE_JSON = $(SRC_DIR)/package.json


UNAME_S := $(shell uname -s)
ifeq ($(OS),Windows_NT)
    DETECTED_OS := Windows
else ifeq ($(UNAME_S),Linux)
    DETECTED_OS := Linux
else ifeq ($(UNAME_S),Darwin)
    DETECTED_OS := macOS
else
    DETECTED_OS := Unknown
endif

.PHONY: all install install-dev clean clean-all dev build build-linux build-windows \
        build-appimage build-deb build-nsis build-portable install-system-deps setup \
        test lint package install-app uninstall-app run-appimage run-deb help check-dir

all: build

install:
	@echo "Installing dependencies..."
	cd $(SRC_DIR) && npm install

install-dev:
	@echo "Installing development dependencies..."
	cd $(SRC_DIR) && npm install --include=dev

clean:
	@echo "Cleaning build artifacts..."
	rm -rf $(SRC_DIR)/$(BUILD_DIR)
	rm -rf $(SRC_DIR)/node_modules/.cache
	rm -rf $(BUILD_DIR)

clean-all: clean
	@echo "Removing node_modules..."
	rm -rf $(NODE_MODULES)

dev: $(NODE_MODULES)
	@echo "Starting development server..."
	cd $(SRC_DIR) && npm start

build: $(NODE_MODULES)
	@echo "Building application for production..."
	cd $(SRC_DIR) && npm run build

build-linux: $(NODE_MODULES)
	@echo "Building for Linux..."
	cd $(SRC_DIR) && npx electron-builder --linux

build-windows: $(NODE_MODULES)
	@echo "Building for Windows..."
	cd $(SRC_DIR) && npx electron-builder --win

build-appimage: $(NODE_MODULES)
	@echo "Building AppImage for Linux..."
	cd $(SRC_DIR) && npx electron-builder --linux AppImage

build-deb: $(NODE_MODULES)
	@echo "Building Debian package..."
	cd $(SRC_DIR) && npx electron-builder --linux deb

build-nsis: $(NODE_MODULES)
	@echo "Building Windows NSIS installer..."
	cd $(SRC_DIR) && npx electron-builder --win nsis

build-portable: $(NODE_MODULES)
	@echo "Building Windows portable..."
	cd $(SRC_DIR) && npx electron-builder --win portable

install-system-deps:
ifeq ($(DETECTED_OS),Linux)
	@echo "Installing system dependencies for Linux..."
	sudo apt-get update
	sudo apt-get install -y nodejs npm build-essential fuse libfuse2 libnss3-dev libatk-bridge2.0-dev libdrm2 libxkbcommon-dev libxcomposite-dev libxdamage-dev libxrandr-dev libgbm-dev libxss-dev libasound2-dev
else
	@echo "System dependencies installation not needed on $(DETECTED_OS)"
endif

setup: install-system-deps install-dev
	@echo "Development environment setup complete for $(DETECTED_OS)!"

test: $(NODE_MODULES)
	@echo "Running tests..."
	cd $(SRC_DIR) && npm test

lint: $(NODE_MODULES)
	@echo "Linting code..."
	cd $(SRC_DIR) && npx eslint . || echo "ESLint not configured"

package: build
	@echo "Creating distribution package..."
	mkdir -p $(BUILD_DIR)
	cp -r $(SRC_DIR)/dist/* $(BUILD_DIR)/ 2>/dev/null || echo "No dist directory found"

install-app:
	@echo "Installing application..."
	sudo cp -r $(BUILD_DIR)/* /opt/$(APP_NAME)/ 2>/dev/null || echo "No build files found. Run 'make build' first."
	sudo ln -sf /opt/$(APP_NAME)/$(APP_NAME) /usr/local/bin/$(APP_NAME) 2>/dev/null || echo "Binary not found"

uninstall-app:
	@echo "Uninstalling application..."
	sudo rm -rf /opt/$(APP_NAME)
	sudo rm -f /usr/local/bin/$(APP_NAME)

run-appimage:
	@echo "Running AppImage..."
	chmod +x "$(SRC_DIR)/dist/Mythbound Launcher-1.0.0.AppImage"
	./$(SRC_DIR)/dist/"Mythbound Launcher-1.0.0.AppImage"

run-deb:
	@echo "Installing and running Deb package..."
	sudo dpkg -i $(SRC_DIR)/dist/mythbound-launcher_1.0.0_amd64.deb
	mythbound-launcher

help:
	@echo "Mythbound Launcher Build System"
	@echo "==============================="
	@echo "Detected OS: $(DETECTED_OS)"
	@echo ""
	@echo "Available targets:"
	@echo "  install              - Install Node.js dependencies"
	@echo "  install-dev          - Install development dependencies"
	@echo "  install-system-deps  - Install system dependencies (Ubuntu/Debian)"
	@echo "  setup                - Complete development setup"
	@echo "  dev                  - Start development server"
	@echo "  build                - Build for production"
	@echo "  build-linux          - Build for Linux (AppImage + Deb)"
	@echo "  build-windows        - Build for Windows (NSIS + Portable)"
	@echo "  build-appimage       - Build AppImage for Linux"
	@echo "  build-deb            - Build Debian package"
	@echo "  build-nsis           - Build Windows NSIS installer"
	@echo "  build-portable       - Build Windows portable executable"
	@echo "  test                 - Run tests"
	@echo "  lint                 - Lint code"
	@echo "  package              - Create distribution package"
	@echo "  install-app          - Install built application system-wide"
	@echo "  uninstall-app        - Uninstall application"
	@echo "  run-appimage         - Run the built AppImage"
	@echo "  run-deb              - Install and run Deb package"
	@echo "  clean                - Clean build artifacts"
	@echo "  clean-all            - Clean everything including node_modules"
	@echo "  help                 - Show this help message"

$(NODE_MODULES): $(PACKAGE_JSON)
	cd $(SRC_DIR) && npm install
	touch $(NODE_MODULES)

check-dir:
	@if [ ! -d "$(SRC_DIR)" ]; then \
		echo "Error: $(SRC_DIR) directory not found. Make sure you're in the project root."; \
		exit 1; \
	fi
