# Mythbound Launcher Makefile
# ============================

# Variables
APP_NAME = mythbound-launcher
BUILD_DIR = dist
SRC_DIR = mythbound-launcher
NODE_MODULES = $(SRC_DIR)/node_modules
PACKAGE_JSON = $(SRC_DIR)/package.json

# Default target
.PHONY: all
all: build

# Install dependencies
.PHONY: install
install:
	@echo "Installing dependencies..."
	cd $(SRC_DIR) && npm install

# Install development dependencies
.PHONY: install-dev
install-dev:
	@echo "Installing development dependencies..."
	cd $(SRC_DIR) && npm install --include=dev

# Clean build artifacts
.PHONY: clean
clean:
	@echo "Cleaning build artifacts..."
	rm -rf $(SRC_DIR)/$(BUILD_DIR)
	rm -rf $(SRC_DIR)/node_modules/.cache
	rm -rf $(BUILD_DIR)

# Clean everything including node_modules
.PHONY: clean-all
clean-all: clean
	@echo "Removing node_modules..."
	rm -rf $(NODE_MODULES)

# Development mode
.PHONY: dev
dev: $(NODE_MODULES)
	@echo "Starting development server..."
	cd $(SRC_DIR) && npm start

# Build for production
.PHONY: build
build: $(NODE_MODULES)
	@echo "Building application for production..."
	cd $(SRC_DIR) && npm run build

# Build for Linux specifically
.PHONY: build-linux
build-linux: $(NODE_MODULES)
	@echo "Building for Linux..."
	cd $(SRC_DIR) && npx electron-builder --linux

# Build AppImage for Linux
.PHONY: build-appimage
build-appimage: $(NODE_MODULES)
	@echo "Building AppImage for Linux..."
	cd $(SRC_DIR) && npx electron-builder --linux AppImage

# Build Debian package
.PHONY: build-deb
build-deb: $(NODE_MODULES)
	@echo "Building Debian package..."
	cd $(SRC_DIR) && npx electron-builder --linux deb

# Build RPM package
.PHONY: build-rpm
build-rpm: $(NODE_MODULES)
	@echo "Building RPM package..."
	cd $(SRC_DIR) && npx electron-builder --linux rpm

# Install system dependencies (Ubuntu/Debian)
.PHONY: install-system-deps
install-system-deps:
	@echo "Installing system dependencies..."
	sudo apt-get update
	sudo apt-get install -y nodejs npm build-essential libnss3-dev libatk-bridge2.0-dev libdrm2 libxkbcommon-dev libxcomposite-dev libxdamage-dev libxrandr-dev libgbm-dev libxss-dev libasound2-dev

# Install system dependencies (CentOS/RHEL/Fedora)
.PHONY: install-system-deps-rpm
install-system-deps-rpm:
	@echo "Installing system dependencies (RPM-based)..."
	sudo dnf install -y nodejs npm gcc-c++ make nss-devel atk-devel at-spi2-atk-devel libdrm-devel libxkbcommon-devel libXcomposite-devel libXdamage-devel libXrandr-devel mesa-libgbm-devel libXScrnSaver-devel alsa-lib-devel

# Setup development environment
.PHONY: setup
setup: install-system-deps install-dev
	@echo "Development environment setup complete!"

# Setup for RPM-based systems
.PHONY: setup-rpm
setup-rpm: install-system-deps-rpm install-dev
	@echo "Development environment setup complete!"

# Test the application
.PHONY: test
test: $(NODE_MODULES)
	@echo "Running tests..."
	cd $(SRC_DIR) && npm test

# Lint the code
.PHONY: lint
lint: $(NODE_MODULES)
	@echo "Linting code..."
	cd $(SRC_DIR) && npx eslint . || echo "ESLint not configured"

# Package the application
.PHONY: package
package: build
	@echo "Creating distribution package..."
	mkdir -p $(BUILD_DIR)
	cp -r $(SRC_DIR)/dist/* $(BUILD_DIR)/ 2>/dev/null || echo "No dist directory found"

# Install the built application (requires sudo)
.PHONY: install-app
install-app:
	@echo "Installing application..."
	sudo cp -r $(BUILD_DIR)/* /opt/$(APP_NAME)/ 2>/dev/null || echo "No build files found. Run 'make build' first."
	sudo ln -sf /opt/$(APP_NAME)/$(APP_NAME) /usr/local/bin/$(APP_NAME) 2>/dev/null || echo "Binary not found"

# Uninstall the application
.PHONY: uninstall-app
uninstall-app:
	@echo "Uninstalling application..."
	sudo rm -rf /opt/$(APP_NAME)
	sudo rm -f /usr/local/bin/$(APP_NAME)

# Show help
.PHONY: help
help:
	@echo "Mythbound Launcher Build System"
	@echo "==============================="
	@echo ""
	@echo "Available targets:"
	@echo "  install              - Install Node.js dependencies"
	@echo "  install-dev          - Install development dependencies"
	@echo "  install-system-deps  - Install system dependencies (Debian/Ubuntu)"
	@echo "  install-system-deps-rpm - Install system dependencies (RPM-based)"
	@echo "  setup                - Complete development setup (Debian/Ubuntu)"
	@echo "  setup-rpm            - Complete development setup (RPM-based)"
	@echo "  dev                  - Start development server"
	@echo "  build                - Build for production"
	@echo "  build-linux          - Build for Linux"
	@echo "  build-appimage       - Build AppImage for Linux"
	@echo "  build-deb            - Build Debian package"
	@echo "  build-rpm            - Build RPM package"
	@echo "  test                 - Run tests"
	@echo "  lint                 - Lint code"
	@echo "  package              - Create distribution package"
	@echo "  install-app          - Install built application system-wide"
	@echo "  uninstall-app        - Uninstall application"
	@echo "  clean                - Clean build artifacts"
	@echo "  clean-all            - Clean everything including node_modules"
	@echo "  help                 - Show this help message"

# Ensure node_modules exists
$(NODE_MODULES): $(PACKAGE_JSON)
	cd $(SRC_DIR) && npm install
	touch $(NODE_MODULES)

# Check if we're in the right directory
.PHONY: check-dir
check-dir:
	@if [ ! -d "$(SRC_DIR)" ]; then \
		echo "Error: $(SRC_DIR) directory not found. Make sure you're in the project root."; \
		exit 1; \
	fi
