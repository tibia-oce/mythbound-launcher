```
launcher
├─ export_files.sh
├─ makefile
├─ mythbound-launcher
│  ├─ app.js
│  ├─ index.html
│  ├─ main.js
│  ├─ mythbound_logo.ico
│  ├─ package-lock.json
│  ├─ package.json
│  └─ resources
│     └─ data
│        ├─ css
│        │  ├─ aos.css
│        │  └─ style.css
│        ├─ images
│        │  ├─ background_vid.mp4
│        │  ├─ background_vid_2.mp4
│        │  ├─ background_vid_3.mp4
│        │  ├─ background_vid_4.mp4
│        │  ├─ effect.gif
│        │  ├─ frozen.png
│        │  ├─ homeMainCharacter.png
│        │  ├─ icon_home.png
│        │  ├─ icon_news.png
│        │  ├─ icon_shop.png
│        │  └─ icon_wiki.png
│        └─ js
│           ├─ aos.js
│           └─ script.js
├─ package-lock.json
├─ package.json
├─ project_export.txt
└─ readme.md

```

---

================================================================================
PROJECT FILE EXPORT
================================================================================
Generated on: Sat May 24 08:01:09 AM AWST 2025
Working directory: /home/jordan/repositories/launcher

This file contains all project files and their contents.
Each file is separated by a header showing the relative path.

================================================================================

================================================================================
FILE: makefile
SIZE: 5.3K
MODIFIED: Sat May 24 07:52:16 AM AWST 2025
================================================================================

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
cp -r $(SRC_DIR)/dist/\* $(BUILD_DIR)/ 2>/dev/null || echo "No dist directory found"

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
@echo " install - Install Node.js dependencies"
@echo " install-dev - Install development dependencies"
@echo " install-system-deps - Install system dependencies (Ubuntu/Debian)"
@echo " setup - Complete development setup"
@echo " dev - Start development server"
@echo " build - Build for production"
@echo " build-linux - Build for Linux (AppImage + Deb)"
@echo " build-windows - Build for Windows (NSIS + Portable)"
@echo " build-appimage - Build AppImage for Linux"
@echo " build-deb - Build Debian package"
@echo " build-nsis - Build Windows NSIS installer"
@echo " build-portable - Build Windows portable executable"
@echo " test - Run tests"
@echo " lint - Lint code"
@echo " package - Create distribution package"
@echo " install-app - Install built application system-wide"
@echo " uninstall-app - Uninstall application"
@echo " run-appimage - Run the built AppImage"
@echo " run-deb - Install and run Deb package"
@echo " clean - Clean build artifacts"
@echo " clean-all - Clean everything including node_modules"
@echo " help - Show this help message"

$(NODE_MODULES): $(PACKAGE_JSON)
cd $(SRC_DIR) && npm install
touch $(NODE_MODULES)

check-dir:
@if [ ! -d "$(SRC_DIR)" ]; then \
 echo "Error: $(SRC_DIR) directory not found. Make sure you're in the project root."; \
 exit 1; \
 fi

================================================================================
FILE: mythbound-launcher/app.js
SIZE: 4.3K
MODIFIED: Sat May 24 12:17:10 AM AWST 2025
================================================================================

/\*\*

- @author Luuxis
- @license CC-BY-NC 4.0 - https://creativecommons.org/licenses/by-nc/4.0
  \*/

const { app, ipcMain, nativeTheme } = require("electron");
const { Microsoft } = require("minecraft-java-core");
const { autoUpdater } = require("electron-updater");

const path = require("path");
const fs = require("fs");

const UpdateWindow = require("./assets/js/windows/updateWindow.js");
const MainWindow = require("./assets/js/windows/mainWindow.js");

let dev = process.env.NODE_ENV === "dev";

if (dev) {
let appPath = path.resolve("./data/Launcher").replace(/\\/g, "/");
let appdata = path.resolve("./data").replace(/\\/g, "/");
if (!fs.existsSync(appPath)) fs.mkdirSync(appPath, { recursive: true });
if (!fs.existsSync(appdata)) fs.mkdirSync(appdata, { recursive: true });
app.setPath("userData", appPath);
app.setPath("appData", appdata);
}

if (!app.requestSingleInstanceLock()) app.quit();
else
app.whenReady().then(() => {
if (dev) return MainWindow.createWindow();
UpdateWindow.createWindow();
});

ipcMain.on("main-window-open", () => MainWindow.createWindow());
ipcMain.on("main-window-dev-tools", () =>
MainWindow.getWindow().webContents.openDevTools({ mode: "detach" })
);
ipcMain.on("main-window-dev-tools-close", () =>
MainWindow.getWindow().webContents.closeDevTools()
);
ipcMain.on("main-window-close", () => MainWindow.destroyWindow());
ipcMain.on("main-window-reload", () => MainWindow.getWindow().reload());
ipcMain.on("main-window-progress", (event, options) =>
MainWindow.getWindow().setProgressBar(options.progress / options.size)
);
ipcMain.on("main-window-progress-reset", () =>
MainWindow.getWindow().setProgressBar(-1)
);
ipcMain.on("main-window-progress-load", () =>
MainWindow.getWindow().setProgressBar(2)
);
ipcMain.on("main-window-minimize", () => MainWindow.getWindow().minimize());

ipcMain.on("update-window-close", () => UpdateWindow.destroyWindow());
ipcMain.on("update-window-dev-tools", () =>
UpdateWindow.getWindow().webContents.openDevTools({ mode: "detach" })
);
ipcMain.on("update-window-progress", (event, options) =>
UpdateWindow.getWindow().setProgressBar(options.progress / options.size)
);
ipcMain.on("update-window-progress-reset", () =>
UpdateWindow.getWindow().setProgressBar(-1)
);
ipcMain.on("update-window-progress-load", () =>
UpdateWindow.getWindow().setProgressBar(2)
);

ipcMain.handle("path-user-data", () => app.getPath("userData"));
ipcMain.handle("appData", (e) => app.getPath("appData"));

ipcMain.on("main-window-maximize", () => {
if (MainWindow.getWindow().isMaximized()) {
MainWindow.getWindow().unmaximize();
} else {
MainWindow.getWindow().maximize();
}
});

ipcMain.on("main-window-hide", () => MainWindow.getWindow().hide());
ipcMain.on("main-window-show", () => MainWindow.getWindow().show());

ipcMain.handle("Microsoft-window", async (\_, client_id) => {
return await new Microsoft(client_id).getAuth();
});

ipcMain.handle("is-dark-theme", (\_, theme) => {
if (theme === "dark") return true;
if (theme === "light") return false;
return nativeTheme.shouldUseDarkColors;
});

app.on("window-all-closed", () => app.quit());

autoUpdater.autoDownload = false;

ipcMain.handle("update-app", async () => {
return await new Promise(async (resolve, reject) => {
autoUpdater
.checkForUpdates()
.then((res) => {
resolve(res);
})
.catch((error) => {
reject({
error: true,
message: error,
});
});
});
});

autoUpdater.on("update-available", () => {
const updateWindow = UpdateWindow.getWindow();
if (updateWindow) updateWindow.webContents.send("updateAvailable");
});

ipcMain.on("start-update", () => {
autoUpdater.downloadUpdate();
});

autoUpdater.on("update-not-available", () => {
const updateWindow = UpdateWindow.getWindow();
if (updateWindow) updateWindow.webContents.send("update-not-available");
});

autoUpdater.on("update-downloaded", () => {
autoUpdater.quitAndInstall();
});

autoUpdater.on("download-progress", (progress) => {
const updateWindow = UpdateWindow.getWindow();
if (updateWindow)
updateWindow.webContents.send("download-progress", progress);
});

autoUpdater.on("error", (err) => {
const updateWindow = UpdateWindow.getWindow();
if (updateWindow) updateWindow.webContents.send("error", err);
});

================================================================================
FILE: mythbound-launcher/index.html
SIZE: 26K
MODIFIED: Sat May 24 08:00:45 AM AWST 2025
================================================================================

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <title>Game Launcher</title>
    <link rel="stylesheet" href="resources/data/css/style.css" />
    <link rel="stylesheet" href="resources/data/css/aos.css" />
	<style>
	body, html {
  -webkit-user-select: none; /* Chrome, Safari, Opera */
  -moz-user-select: none;    /* Firefox */
  -ms-user-select: none;     /* Internet Explorer/Edge */
  user-select: none;         /* Standard syntax */
}

.draggable-top, .draggable-left, .draggable-right, .draggable-bottom {
position: absolute;
-webkit-app-region: drag; /_ Make it draggable _/
z-index: 10;
}

.draggable-top {
top: 0;
left: 0;
width: 100%;
height: 20px; /_ Top draggable area _/
}

.draggable-left {
top: 0;
left: 0;
width: 15px; /_ Left draggable area _/
height: 100%;
}

.draggable-right {
top: 0;
right: 0;
width: 15px; /_ Right draggable area _/
height: 100%;
}

.draggable-bottom {
bottom: 0;
left: 0;
width: 100%;
height: 15px; /_ Bottom draggable area _/
}

html::-webkit-scrollbar, body::-webkit-scrollbar {
display: none; /_ Chrome, Safari, Edge _/
}
.resource-update {
margin-bottom: 20;
}
button.update-btn {
background: #1e90ff;
border: none;
border-radius: 5px;
color: #fff;
padding: 8px 16px;
cursor: pointer;
transition: background 0.3s;
}
button.update-btn:hover { background: #187bcd; }
button.optionButton {
border: none;
border-radius: 50%;
color: #fff;
font-size: 16px;
cursor: pointer;
padding: 8px;
transition: background 0.3s;
}
.progress-container {
display: none;
width: 150px;
height: 20px;
background: #444;
border-radius: 5px;
overflow: hidden;
margin-bottom: 10px;
align-items: center;
padding: 0;
color: #fff;
font-size: 14px;
}

    .progress-bar {
    	height: 100%;
    	background: #1e90ff;
    	width: 0%;
    	transition: width 0.2s ease;
    	display: flex;
    	align-items: center;
    	justify-content: center;
    }

    .update-banner {
      background: #66c0f4;
      color: #1b1b1b;
      padding: 15px;
      border-radius: 5px;
      margin-bottom: 20px;
      display: flex;
      justify-content: space-between;
      align-items: center;
    }
    .update-text {
      font-weight: bold;
    }
    .update-button {
      background: #1e90ff;
      border: none;
      border-radius: 5px;
      color: #fff;
      padding: 8px 16px;
      cursor: pointer;
      transition: background 0.3s;
    }
    button.upToDate {
      background: #28a745 !important;
    }
    #launchButton:disabled {
      background: #666;
      cursor: not-allowed;
    }
    .launch-buttons {

position: absolute;
bottom: 20px; /_ adjust spacing from the bottom as needed _/
left: 50%;
transform: translateX(-50%);
display: flex;
flex-direction: column;
gap: 10px; /_ spacing between buttons _/
width: 100%; /_ optional: stretch buttons or center them _/
align-items: center; /_ centers the buttons horizontally _/
}

.window-controls {
position: fixed;
display: flex;
z-index: 9999;
-webkit-app-region: no-drag; /_ Ensure the buttons remain clickable _/
}
.window-controls button {
background: none;
border: none;
color: white;
font-size: 20px;
width: 40px;
height: 40px;
display: flex;
align-items: center;
justify-content: center;
cursor: pointer;
transition: background 0.3s ease;
-webkit-app-region: no-drag;
}
.left-panel {
position: relative; /_ establishes a positioning context _/
/_ Other existing styles... _/
}
</style>
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
<script>
// Make sure nodeIntegration is enabled in your BrowserWindow.
const { shell } = require('electron');

function openExternalLink(url) {
shell.openExternal(url);
}
</script>

  </head>
  <body>
  <div class="draggable-top"></div>
<div class="draggable-left"></div>
<div class="draggable-right"></div>
<div class="draggable-bottom"></div>
    <div id="preloader">
      <div class="spinner-multi">
        <div class="circle"></div>
        <div class="circle"></div>
        <div class="circle"></div>
        <div class="circle"></div>
        <div class="circle"></div>
        <div class="circle"></div>
        <div class="circle"></div>
        <div class="circle"></div>
      </div>
    </div>
    <div id="launcher">
      <header class="top-bar">
        <div class="top-left">
          <button class="menu-btn" style="outside:none"><i class="fas fa-bars"></i></button>
          <div class="menu-panel" id="menuPanel">
            <ul>
              <li><a href="#">Website</a></li>
              <li><a href="#">My account</a></li>
              <li><a href="#">Highscores</a></li>
			  <li><a href="#">Shop</a></li>
			  <li><a href="#">Contact</a></li>
            </ul>
          </div>
        </div>
		<div class="top-right">
          <button class="window-btn" id="minimizeBtn" style="outline: none"><i class="fas fa-minus"></i></button>
          <button class="window-btn" id="closeBtn" style="outline:none"><i class="fas fa-times"></i></button>
        </div>
      </header>
      <div class="content-wrapper">
        <nav class="left-panel">
		<ul>
			<li class="tab-button active" data-tab="tab1">
			<img src="resources/data/images/icon_home.png" class="tab-icon" alt="Home Icon">
			<span class="tab-text">Home</span>
			</li>
			<li class="tab-button" data-tab="tab2">
			<img src="resources/data/images/icon_news.png" class="tab-icon" alt="News Icon">
			<span class="tab-text">News</span>
			</li>
			<li class="tab-button" data-tab="tab3">
			<img src="resources/data/images/icon_changelogs.png" class="tab-icon" alt="Changelogs Icon">
			<span class="tab-text">Changelogs</span>
			</li>
			<li class="tab-button" data-tab="tab4">
			<img src="resources/data/images/icon_wiki.png" class="tab-icon" alt="Wikipedia Icon">
			<span class="tab-text">Wikipedia</span>
			</li>
		</ul>
		<div class="launch-buttons">
				<div class="resource-update" id="resourceUpdate_resource1">
				  <div class="progress-container" id="progressContainer_resource1">
					<div class="progress-bar" id="progressBar_resource1"></div>
				</div>
				<p id="versionDisplay" style="margin-top: 20px; text-align: center; color: #fff;"></p>
		</div>
		<button class="action-btn" id="launchButton" style="width:150px">Play</button>
		<button class="action-btn" id="updateButton_resource1" style="width:150px" onclick="handleUpdate('resource1')">Update</button>
		<button class="action-btn" id="optionsBtn" style="width:150px" onclick="openResourceFolder('resource1')">⚙ Options</button>
		</div>
		</nav>
        <div class="tab-views">
          <!-- TAB 1 (HOME) -->
          <div class="tab-view active" id="tab1">
            <div class="tab-background">
              <video autoplay muted loop>
                <source src="resources/data/images/background_vid.mp4" type="video/mp4" />
              </video>
            </div>
            <div class="tab-content scrollable">
				<div class="home-character" data-aos="fade" data-aos-duration="500" data-aos-delay="1000">
				<img src="resources/data/images/effect.gif" class="home-character__animation" />
				<img src="resources/data/images/homeMainCharacter.png" class="home-character__image" alt="wolf character" />
				<p class="home-description">
                  Welcome to the ultimate gaming experience! Dive into an adventure where challenges meet innovation.
                </p>
			</div>
              <div class="home-header">
                <img src="resources/data/images/frozen.png" class="home-logo" />
              </div>
			  <div class="scroll-indicator">
                  <span class="arrow">↓</span>
                </div>
              <div class="grid-container">
                <div class="grid-item">
                  <img src="https://opengamescommunity.com/index.php?attachments/sanguine_items-gif.4610/"/>
                  <p>Bakgragore & Soul Added!</p>
                </div>
                <div class="grid-item">
                  <img src="https://opengamescommunity.com/index.php?attachments/mercurial-gif.4812/" />
                  <p>New Custom Items added in game, custom quests!</p>
                </div>
                <div class="grid-item">
                  <img src="https://opengamescommunity.com/index.php?attachments/tp_island-png.4815/"/>
                  <p>New Teleport Island</p>
                </div>
                <div class="grid-item">
                  <img src="https://opengamescommunity.com/index.php?attachments/aquatic_overlord_thalassa-png.4705/"/>
                  <p>Take down the World Bosses around the isles</p>
                </div>
                <div class="grid-item">
                  <img src="https://opengamescommunity.com/index.php?attachments/1710696833170-png.4704/"/>
                  <p>More than 50 Custom monsters</p>
                </div>
                <div class="grid-item">
                  <img src="https://opengamescommunity.com/index.php?attachments/azazel_infernal_seraph-png.4706/"/>
                  <p>Azazel is coming out</p>
                </div>
                <div class="grid-item">
                  <img src="https://opengamescommunity.com/index.php?attachments/8-png.5020/"/>
                  <p>Crafting System Enhanced</p>
                </div>
                <div class="grid-item">
                  <img src="https://opengamescommunity.com/index.php?attachments/1-png.5013/"/>
                  <p>Candia Isle</p>
                </div>
              </div>
            </div>
          </div>

          <!-- TAB 2 (NEWS) -->
          <div class="tab-view" id="tab2">
            <div class="tab-background">
              <video autoplay muted loop>
                <source src="resources/data/images/background_vid_2.mp4" type="video/mp4" />
              </video>
            </div>
            <div class="tab-content scrollable">
              <h2>News</h2>
              <p>Below are 3 stacked panels with an image + some text:</p>
              <div class="news-panel">
                <img src="https://opengamescommunity.com/index.php?attachments/aquatic_overlord_thalassa-png.4705/" />
                <p>
                 Take a boat and navigate around the continent to enter on the 9 new isles availables, but also on other cities! Find the World Bosses and get an incredible loot!<br>
    			 Possible to loot Eldritch items, badges, rare boats and much more!
                </p>
              </div>
              <div class="news-panel">
                <img src="https://opengamescommunity.com/index.php?attachments/sanguine_items-gif.4610/"/>
                <p>
                  While Bakgragore and Goshnar bosses have been implemented on Kilmaresh after a breach appears on the continent, they are prepared to face the immortals who try enter on their realm!
                </p>
              </div>
              <div class="news-panel">
                <img src="https://opengamescommunity.com/index.php?attachments/1710696833170-png.4704/" alt="News Panel 3" />
                <p>
                  Each monster is unique, you can find them on the isles!
                </p>
              </div>
            </div>
          </div>

          <!-- TAB 3 (CHANGELOGS) -->
          <div class="tab-view" id="tab3">
            <div class="tab-background">
              <video autoplay muted loop>
                <source src="resources/data/images/background_vid_3.mp4" type="video/mp4" />
              </video>
            </div>
            <div class="tab-content scrollable">
              <h2>Changelogs</h2>
    		  <div class="changelog-panel">
                <h3>Update v3.0</h3>
                <p>
                  - Key changes:
                  <br />
                  &nbsp;&nbsp;* Improved UI performance.
                  <br />
                  &nbsp;&nbsp;* Fixed multiple crashes on older systems.
                  <br />
                  &nbsp;&nbsp;* Added new quest lines.
                </p>
                <p>
                  - Additional fixes:
                  <br />
                  &nbsp;&nbsp;* Updated translations for multiple languages.
                  <br />
                  &nbsp;&nbsp;* Removed deprecated API calls.
                  <br />
                  &nbsp;&nbsp;* Optimized memory usage.
                </p>
                <p>
                  Thank you for your continued support. More updates to come soon!
                </p>
              </div>
    		  <br>
              <div class="changelog-panel">
                <h3>Update v2.0</h3>
                <p>
                  - Key changes:
                  <br />
                  &nbsp;&nbsp;* Improved UI performance.
                  <br />
                  &nbsp;&nbsp;* Fixed multiple crashes on older systems.
                  <br />
                  &nbsp;&nbsp;* Added new quest lines.
                </p>
                <p>
                  - Additional fixes:
                  <br />
                  &nbsp;&nbsp;* Updated translations for multiple languages.
                  <br />
                  &nbsp;&nbsp;* Removed deprecated API calls.
                  <br />
                  &nbsp;&nbsp;* Optimized memory usage.
                </p>
                <p>
                  Thank you for your continued support. More updates to come soon!
                </p>
              </div>
    		   <br>
    		  <div class="changelog-panel">
                <h3>Update v1.0</h3>
                <p>
                  - Key changes:
                  <br />
                  &nbsp;&nbsp;* Improved UI performance.
                  <br />
                  &nbsp;&nbsp;* Fixed multiple crashes on older systems.
                  <br />
                  &nbsp;&nbsp;* Added new quest lines.
                </p>
                <p>
                  - Additional fixes:
                  <br />
                  &nbsp;&nbsp;* Updated translations for multiple languages.
                  <br />
                  &nbsp;&nbsp;* Removed deprecated API calls.
                  <br />
                  &nbsp;&nbsp;* Optimized memory usage.
                </p>
                <p>
                  Thank you for your continued support. More updates to come soon!
                </p>
              </div>
            </div>
          </div>

          <!-- TAB 4 (WIKIPEDIA) -->
          <div class="tab-view" id="tab4">
            <div class="tab-background">
              <video autoplay muted loop>
                <source src="resources/data/images/background_vid_4.mp4" type="video/mp4" />
              </video>
            </div>
            <div class="tab-content scrollable">
              <h2>Wikipedia</h2>
    		  <br></br>
              <div class="wiki-menu" id="wikiMenu">
                <button class="wiki-button" data-entry="1">Ancestral System</button>
                <button class="wiki-button" data-entry="2">Entry 2</button>
                <button class="wiki-button" data-entry="3">Entry 3</button>
                <button class="wiki-button" data-entry="4">Entry 4</button>
                <button class="wiki-button" data-entry="5">Entry 5</button>
                <button class="wiki-button" data-entry="6">Entry 6</button>
                <button class="wiki-button" data-entry="7">Entry 7</button>
              </div>
              <div class="wiki-content" id="wikiContent">
                <p>Welcome to wikipedia, to get more information click on the buttons on top.</p>
              </div>
            </div>
          </div>
        </div>
      </div>
      <footer class="bottom-bar">
    	<div class="footer-copy">
    		Copyright 2025
    	<a href="https://www.mythbound.dev/">Mythbound</a> launcher by Manawa.
    	</div>
      </footer>
    </div>
    <script>
      const { ipcRenderer } = require('electron');

      // Window and button event listeners
      document.addEventListener('DOMContentLoaded', () => {
        // Window controls
        document.getElementById('minimizeBtn')?.addEventListener('click', () => {
          ipcRenderer.send('minimize-window');
        });
        document.getElementById('closeBtn')?.addEventListener('click', () => {
          ipcRenderer.send('close-window');
        });
        document.getElementById('launchButton').addEventListener('click', () => {
          handleLaunchButtonClick();
        });

       // Get all elements with an href attribute

const allHrefElements = document.querySelectorAll('[href]');

// Filter only those with an external URL (starting with "http")
const externalHrefElements = Array.from(allHrefElements).filter(el => {
const url = el.getAttribute('href');
return url && url.startsWith('http');
});

// Log them (tag name and href value)
externalHrefElements.forEach(el => {
console.log(el.tagName, el, el.getAttribute('href'));
});

        // Listen for update-status messages from main process
        ipcRenderer.on('update-status', (event, status) => {
          console.log("Update status:", status);
          setUpdateStatus(status);
          if (status.toLowerCase().includes("no update available")) {
            document.getElementById("progressBarContainer").style.display = "none";
          }
        });

    	ipcRenderer.on('resource-update-complete', (event, resource, version) => {

window.isGameInstalled = true; // Mark the game as installed/updated
const updateButton = document.getElementById("updateButton*" + resource);
if (updateButton) {
updateButton.innerText = "Up to Date";
updateButton.disabled = true;
updateButton.classList.add("upToDate");
document.getElementById("progressContainer*" + resource).style.display = "none";
}

const launchButton = document.getElementById("launchButton");
if (launchButton) {
launchButton.disabled = false;
launchButton.style.opacity = "";
}

const versionDisplay = document.getElementById("versionDisplay");
if (versionDisplay) {
versionDisplay.innerText = "Game Version: " + version;
}
});

        // Listen for download-progress messages
        ipcRenderer.on('download-progress', (event, progressMessage) => {

console.log("Download progress:", progressMessage);

// Update the progress text inside versionDisplay if needed
const versionDisplay = document.getElementById("versionDisplay");
if (versionDisplay) {
// If the message contains a percentage, you can update the progress bar too.
const match = progressMessage.match(/(\d+)%/);
if (match) {
const percent = parseInt(match[1]);
const progressBar = document.getElementById("progressBar_resource1");
if (progressBar) {
progressBar.style.width = percent + '%';
}
}
// Display the detailed progress text.
versionDisplay.innerText = progressMessage;
}
});

        // Listen for update-downloaded event (for launcher updates)
        ipcRenderer.on('update-downloaded', (event, info) => {
          console.log('Launcher update downloaded:', info);
          // Show your custom modal if you want; otherwise, your main process might auto-quit.
          document.getElementById('updateModal').style.display = 'block';
          const launchButton = document.getElementById('launchButton');
          launchButton.innerText = 'Restart';
          launchButton.disabled = false;
          setUpdateStatus("Update downloaded. Click 'Restart' to apply the update.");
          document.getElementById("progressBarContainer").style.display = "block";
        });
      });

      // Helper functions for updating the UI
      function setUpdateStatus(status) {
        const statusElem = document.getElementById("updateStatus");
        if (statusElem) {
          statusElem.innerText = status;
        }
      }
      function setProgress(percent) {
        const progressElem = document.getElementById("progressBar");
        if (progressElem) {
          progressElem.style.width = percent + '%';
          progressElem.innerText = percent + '%';
        }
      }
      function handleLaunchButtonClick() {

if (!window.isGameInstalled) {
// Optionally display a message to the user
alert('The game is not installed. Please click Update first.');
return;
}
const btn = document.getElementById('launchButton');
if (btn.innerText === 'Restart') {
ipcRenderer.send('restart_app');
} else {
ipcRenderer.send('launch_game');
}
}

      // Resource update functions
      function openResourceFolder(resource) {
        ipcRenderer.send('open-resource-folder', resource);
      }
      let updateInProgress = false;

function handleUpdate(resource) {
if (updateInProgress) return; // Prevent re-triggering if already updating
updateInProgress = true;

const launchButton = document.getElementById("launchButton");
const updateButton = document.getElementById("updateButton*" + resource);
const progressContainer = document.getElementById("progressContainer*" + resource);

if (launchButton) {
launchButton.disabled = true;
launchButton.style.opacity = "0.5";
}

if (updateButton) {
updateButton.innerText = "Updating...";
updateButton.disabled = true;
updateButton.classList.remove("upToDate");
}

if (progressContainer) {
progressContainer.style.display = "inline-flex";
const progressBar = document.getElementById("progressBar\_" + resource);
if (progressBar) progressBar.style.width = "0%";
}

// Simulate delay before triggering update (or send directly)
setTimeout(() => {
ipcRenderer.send('update-resource', resource);
}, 5000);
}

      // Optional: launcher update handler
      function handleLauncherUpdate() {
        ipcRenderer.send('restart_app');
      }

      // Listen for download-progress messages for resource updates
      ipcRenderer.on('download-progress', (event, progressMessage) => {
        console.log("Download progress (resource):", progressMessage);
        // Format: "Downloaded 50%"
        const matches = progressMessage.match(/Downloaded (\d+)%/);
        if (matches) {
          const percent = matches[1];
          const progressBars = document.querySelectorAll(".progress-bar");
          progressBars.forEach(bar => {
            bar.style.width = percent + "%";
          });
        }
      });

      ipcRenderer.on('game-started', () => {

// Disable the Update button while the game is running.
const updateButton = document.getElementById("updateButton_resource1");
if (updateButton) {
updateButton.disabled = true;
updateButton.style.opacity = "0.5";
}
});

      ipcRenderer.on('game-stopped', () => {

const launchButton = document.getElementById("launchButton");
if (launchButton) {
launchButton.disabled = false;
launchButton.style.opacity = "";
}

const updateButton = document.getElementById("updateButton_resource1");
if (updateButton) {
// If no update is needed, ensure the button remains in the "up-to-date" state.
updateButton.disabled = true;
updateButton.classList.add("upToDate");
updateButton.innerText = "Up to Date";
}

const progressContainer = document.getElementById("progressContainer_resource1");
if (progressContainer) {
progressContainer.style.display = "none";
}

// Optionally, reset your flag here if needed:
updateInProgress = false;
});

      // Check the status of a resource update (if needed)
      function checkResourceStatus(resource) {

ipcRenderer.invoke('check-resource-update', resource).then((status) => {
const updateButton = document.getElementById('updateButton\_' + resource);
const launchButton = document.getElementById('launchButton');

    if (status === 'up-to-date') {
      // Game is installed and updated
      updateButton.innerText = 'Up to Date';
      updateButton.disabled = true;
      updateButton.classList.add('upToDate');
      // Enable play button
      launchButton.disabled = false;
      launchButton.style.opacity = "";
      window.isGameInstalled = true;
    } else {
      // Game is not installed (or update is available)
      updateButton.innerText = 'Update';
      updateButton.disabled = false;
      updateButton.classList.remove('upToDate');
      // Disable play button to prevent launching an uninstalled game
      launchButton.disabled = true;
      launchButton.style.opacity = "0.5";
      window.isGameInstalled = false;
    }

});
}

// Check for each resource on startup
const resourcesToCheck = ['resource1'];
resourcesToCheck.forEach(resource => {
checkResourceStatus(resource);
});

      // Restart modal button (if using a custom modal for launcher updates)
      document.addEventListener('DOMContentLoaded', () => {
        const restartButton = document.getElementById('restartNowButton');
        if (restartButton) {
          restartButton.addEventListener('click', () => {
            ipcRenderer.send('restart_app');
          });
        } else {
          console.error('restartNowButton not found');
        }
      });

      document.addEventListener('click', function (event) {

const menuPanel = document.getElementById('menuPanel');
const menuButton = document.querySelector('.menu-btn');

// Check if the click target is NOT inside the menuPanel or the menuButton
if (!menuPanel.contains(event.target) && !menuButton.contains(event.target)) {
// Hide the menu panel (for example, by setting display to "none" or removing an "active" class)
menuPanel.style.display = 'none';
}
});
document.querySelectorAll('a').forEach(anchor => {
// Only intercept external links (starting with http)
if (anchor.getAttribute('href') && anchor.getAttribute('href').startsWith('http')) {
anchor.addEventListener('click', (e) => {
e.preventDefault();
openExternalLink(anchor.getAttribute('href'));
});
}
});

    </script>
    <script src="resources/data/js/aos.js"></script>
    <script src="resources/data/js/script.js"></script>

  </body>
</html>

================================================================================
FILE: mythbound-launcher/main.js
SIZE: 15K
MODIFIED: Sat May 24 07:48:17 AM AWST 2025
================================================================================

const {
app,
BrowserWindow,
Menu,
dialog,
ipcMain,
shell,
} = require("electron");
const path = require("path");
const { autoUpdater } = require("electron-updater");
const { exec } = require("child_process");
const fs = require("fs-extra");
const extract = require("extract-zip");
const jsYaml = require("js-yaml");
const https = require("https");
const { spawn } = require("child_process");
let gameProcess = null;

// -----------------------------------------------------------------------------
// Set up paths and variables
// -----------------------------------------------------------------------------

const resourceRoot =
process.env.NODE_ENV === "development" ? **dirname : process.resourcesPath;
const resourcesPath = path.join(**dirname, "resources");
console.log(`Resources Path (dev): ${resourcesPath}`);

const userDataDir = app.getPath("userData");
const persistentBaseDir = path.join(userDataDir, "mythbound");
fs.ensureDirSync(persistentBaseDir);

// const clientExePath = path.join(resourceRoot, 'resources', 'Exodus_Client.exe'); // If exe is inside folder resources where luncher is located (NOT RECOMMENDED, use instead the method to trigger download after install launcher, instead of installing launcher and game first time )
const clientExePath = path.join(
persistentBaseDir,
"resource1",
"Exodus_Client.exe"
); // If exe is inside folder resource1 (Folder .zip downloaded from host, so the game folder) if is inside of resource1 but inside folder data will be 'resource1', 'data', 'Exodus_Client.exe'
console.log(`Client Executable (resolved): ${clientExePath}`);

// -----------------------------------------------------------------------------
// Launch Game Client
// -----------------------------------------------------------------------------
function launchClient() {
if (gameProcess) {
console.log("Game is already running.");
return;
}

gameProcess = spawn(`"${clientExePath}"`, [], {
shell: true,
detached: true,
});
console.log("Game launched.");

mainWindow.webContents.send("game-started");

gameProcess.on("exit", (code) => {
console.log(`Game exited with code ${code}`);
gameProcess = null;
mainWindow.webContents.send("game-stopped");
});
}

// -----------------------------------------------------------------------------
// Helper: checkRemoteVersion - fetch and parse remote manifest (latest.yml).
// -----------------------------------------------------------------------------
function checkRemoteVersion(manifestUrl, callback) {
console.log("Fetching remote manifest from:", manifestUrl);
let data = "";
https
.get(manifestUrl, (res) => {
res.on("data", (chunk) => {
data += chunk;
});
res.on("end", () => {
try {
const manifest = jsYaml.load(data);
const remoteVersion = manifest.version || "0.0.0";
console.log("Remote manifest fetched; version:", remoteVersion);
callback(null, remoteVersion, manifest);
} catch (e) {
console.error("Error parsing remote manifest:", e);
callback(e);
}
});
})
.on("error", (err) => {
console.error("Error fetching remote manifest:", err);
callback(err);
});
}

// -----------------------------------------------------------------------------
// Patch httpExecutor.getTempFileName for electron-updater (Sanitized lines)
// -----------------------------------------------------------------------------
try {
const httpExecutor = require("builder-util-runtime/out/httpExecutor");
const originalGetTempFileName = httpExecutor.getTempFileName;
httpExecutor.getTempFileName = (url) => {
console.log("Original URL for temp file:", url);
const sanitized = url.replace(/[:\/\\]+/g, "\_");
console.log("Sanitized filename:", sanitized);
const cachePath =
typeof autoUpdater !== "undefined" && autoUpdater.baseCachePath
? autoUpdater.baseCachePath
: app.getPath("userData");
return path.join(cachePath, "temp-" + sanitized);
};
console.log("Patched httpExecutor.getTempFileName successfully.");
} catch (e) {
console.error("Failed to patch getTempFileName:", e);
}

// -----------------------------------------------------------------------------
// Setup updater directory
// -----------------------------------------------------------------------------
function ensureUpdaterDirs() {
const updatesDir = path.join(persistentBaseDir, "updates");
fs.ensureDirSync(updatesDir);
}

// -----------------------------------------------------------------------------
// Main Windows Luncher
// -----------------------------------------------------------------------------
let mainWindow;
function createWindow() {
mainWindow = new BrowserWindow({
width: 1800,
height: 900,
frame: false,
webPreferences: {
nodeIntegration: true,
contextIsolation: false,
},
});
Menu.setApplicationMenu(null);
mainWindow.loadFile("index.html");
}

// -----------------------------------------------------------------------------
// App event listeners
// -----------------------------------------------------------------------------
app.on("ready", () => {
console.log("App is ready.");
createWindow();
ensureUpdaterDirs();

const updatesDir = path.join(persistentBaseDir, "updates");
autoUpdater.baseCachePath = updatesDir;
console.log("Custom updates directory set to:", updatesDir);

autoUpdater.checkForUpdatesAndNotify();
});

app.on("window-all-closed", () => {
if (process.platform !== "darwin") app.quit();
});

app.on("activate", () => {
if (BrowserWindow.getAllWindows().length === 0) createWindow();
});

// -----------------------------------------------------------------------------
// Donwload and Update
// -----------------------------------------------------------------------------
function downloadAndUpdateResource(fileUrl, targetDir, ipcEvent, callback) {
console.log("Starting download from:", fileUrl);
const fileName = path.basename(fileUrl);
const filePath = path.join(targetDir, fileName);
const fileStream = fs.createWriteStream(filePath);

const startTime = Date.now();

https
.get(fileUrl, (response) => {
const totalBytes = parseInt(response.headers["content-length"], 10);
let downloadedBytes = 0;

      response.on("data", (chunk) => {
        downloadedBytes += chunk.length;
        const elapsedTime = (Date.now() - startTime) / 1000; // seconds
        const speed = downloadedBytes / (1024 * 1024 * elapsedTime); // MB/s
        const currentMB = (downloadedBytes / (1024 * 1024)).toFixed(2);
        const totalMB = (totalBytes / (1024 * 1024)).toFixed(2);
        const percent = Math.round((downloadedBytes / totalBytes) * 100);

        const progressMessage = `Speed: ${speed.toFixed(
          2
        )} MB/s | ${currentMB} MB / ${totalMB} MB | ${percent}%`;
        ipcEvent.sender.send("download-progress", progressMessage);
      });

      response.pipe(fileStream);

      fileStream.on("finish", () => {
        fileStream.close(() => {
          console.log("Download finished, file saved as:", filePath);

          ipcEvent.sender.send("download-progress", "Unpacking...");
          if (path.extname(fileName) === ".zip") {
            console.log("File is a ZIP archive, starting extraction...");
            extract(filePath, { dir: targetDir })
              .then(() => {
                console.log("Extraction complete.");
                fs.unlink(filePath, (err) => {
                  if (err) console.error("Error deleting zip file:", err);
                  else console.log("Zip file deleted after extraction.");
                  callback(null);
                });
              })
              .catch((err) => {
                console.error("Error during extraction:", err);
                callback(err);
              });
          } else {
            callback(null);
          }
        });
      });
    })
    .on("error", (err) => {
      console.error("Error during download:", err);
      fs.unlink(filePath, () => callback(err));
    });

}

// -----------------------------------------------------------------------------
// Update-resource
// -----------------------------------------------------------------------------
ipcMain.on("update-resource", (event, resource) => {
console.log(`Received IPC request to update resource: ${resource}`);

const baseUrl = `https://github.com/tibia-oce/mythbound-client-public/releases/latest/download/`;
const manifestUrl = baseUrl + "latest.yml";
console.log(`Manifest URL for resource "${resource}": ${manifestUrl}`);

const localManifestPath = path.join(
persistentBaseDir,
resource,
"latest.yml"
);
let localVersion = "0.0.0";
if (fs.existsSync(localManifestPath)) {
try {
const localManifestContent = fs.readFileSync(localManifestPath, "utf8");
const localManifest = jsYaml.load(localManifestContent);
if (localManifest && localManifest.version) {
localVersion = localManifest.version;
}
console.log(`Local version for resource "${resource}": ${localVersion}`);
} catch (e) {
console.error("Error reading local manifest:", e);
}
} else {
console.log(
`No local manifest found for resource "${resource}". Defaulting version to ${localVersion}`
);
}

checkRemoteVersion(manifestUrl, (err, remoteVersion, manifest) => {
if (err) {
console.error("Error checking remote version:", err);
event.sender.send("update-status", "Error checking update.");
return;
}

    console.log(`Remote version for resource "${resource}": ${remoteVersion}`);
    if (remoteVersion > localVersion) {
      console.log(
        `An update is available for ${resource}: ${remoteVersion} > ${localVersion}`
      );
      event.sender.send(
        "update-status",
        `New version ${remoteVersion} available. Downloading update...`
      );

      const fileUrl = baseUrl + manifest.zipFileName;
      console.log(`Downloading update from: ${fileUrl}`);
      const targetDir = path.join(persistentBaseDir, resource);
      fs.ensureDirSync(targetDir);
      fs.emptyDirSync(targetDir);
      event.sender.send("update-status", "Updating...");

      downloadAndUpdateResource(fileUrl, targetDir, event, (err) => {
        if (err) {
          console.error("Error during update download/extraction:", err);
          event.sender.send("update-status", "Error applying updates.");
        } else {
          console.log(`Resource "${resource}" updated successfully.`);
          event.sender.send("update-status", "Update applied successfully.");

          fs.writeFile(
            localManifestPath,
            jsYaml.dump(manifest),
            "utf8",
            (err) => {
              if (err) {
                console.error("Error saving local manifest:", err);
              } else {
                console.log(
                  `Local manifest for "${resource}" updated to version ${manifest.version}`
                );

                event.sender.send(
                  "resource-update-complete",
                  resource,
                  manifest.version
                );
              }
            }
          );
        }
      });
    } else {
      console.log(
        `No update available for resource "${resource}": remote (${remoteVersion}) <= local (${localVersion})`
      );
      event.sender.send("update-status", "No update available.");
    }

});
});

// -----------------------------------------------------------------------------
// Check-resource-update
// -----------------------------------------------------------------------------
ipcMain.handle("check-resource-update", async (event, resource) => {
const baseUrl = `https://github.com/tibia-oce/mythbound-client-public/releases/latest/download/`;
const manifestUrl = baseUrl + "latest.yml";

const localManifestPath = path.join(
persistentBaseDir,
resource,
"latest.yml"
);
let localVersion = "0.0.0";
if (fs.existsSync(localManifestPath)) {
try {
const localManifestContent = fs.readFileSync(localManifestPath, "utf8");
const localManifest = jsYaml.load(localManifestContent);
if (localManifest && localManifest.version) {
localVersion = localManifest.version;
}
} catch (e) {
console.error("Error reading local manifest:", e);
}
}

return new Promise((resolve, reject) => {
checkRemoteVersion(manifestUrl, (err, remoteVersion, manifest) => {
if (err) {
console.error("Error checking remote version for resource", resource);
return resolve("error");
}
if (remoteVersion > localVersion) {
resolve("update-available");
} else {
resolve("up-to-date");
}
});
});
});

// -----------------------------------------------------------------------------
// Open-resource-folder
// -----------------------------------------------------------------------------
ipcMain.on("open-resource-folder", (event, resource) => {
const folderPath = path.join(persistentBaseDir, resource);
console.log(`Request to open folder: ${folderPath}`);
fs.pathExists(folderPath, (err, exists) => {
if (exists) {
console.log(`Folder exists for resource "${resource}", opening...`);
shell.openPath(folderPath);
} else {
console.error(`Folder for resource "${resource}" does not exist.`);
dialog.showErrorBox(
"Folder Not Found",
`The folder for ${resource} does not exist.`
);
}
});
});

// -----------------------------------------------------------------------------
// Auto-updater for launcher updates: restart the app when an update is downloaded.
// -----------------------------------------------------------------------------
autoUpdater.on("update-downloaded", (info) => {
console.log("Launcher update downloaded:", info);

autoUpdater.quitAndInstall();
});

// -----------------------------------------------------------------------------
// Windows controls and launcher updates
// -----------------------------------------------------------------------------
ipcMain.on("minimize-window", () => {
if (mainWindow) {
console.log("Minimizing window.");
mainWindow.minimize();
}
});

ipcMain.on("close-window", () => {
if (mainWindow) {
console.log("Closing window.");
mainWindow.close();
}
});

ipcMain.handle("get-version", () => {
const version = app.getVersion();
console.log("Returning launcher version:", version);
return version;
});

ipcMain.on("restart_app", () => {
console.log("Restarting application for update.");
autoUpdater.quitAndInstall();
});

ipcMain.on("launch_game", () => {
launchClient();
});

console.log("Update cache path:", autoUpdater.baseCachePath);

module.exports = { launchClient };

================================================================================
FILE: mythbound-launcher/package.json
SIZE: 2.6K
MODIFIED: Sat May 24 07:58:45 AM AWST 2025
================================================================================

{
"name": "mythbound-launcher",
"version": "1.0.0",
"description": "Official launcher for Mythbound RPG.",
"main": "main.js",
"homepage": "https://www.mythbound.dev/",
"repository": {
"type": "git",
"url": "https://github.com/tibia-oce/mythbound-launcher-public.git"
},
"bugs": {
"url": "https://github.com/tibia-oce/mythbound-launcher-public/issues"
},
"scripts": {
"start": "electron .",
"build": "electron-builder",
"build-linux": "electron-builder --linux",
"build-windows": "electron-builder --win",
"build-all": "electron-builder --linux --win"
},
"keywords": [
"mythbound",
"game",
"launcher",
"mmorpg",
"electron",
"gaming"
],
"author": {
"name": "Jordan",
"email": "contact@mythbound.dev",
"url": "https://www.mythbound.dev/"
},
"license": "MIT",
"devDependencies": {
"electron": "^34.0.0",
"electron-builder": "^24.13.3"
},
"dependencies": {
"electron-updater": "^6.3.9",
"extract-zip": "^2.0.1",
"fs-extra": "^11.2.0",
"js-yaml": "^4.1.0",
"semver": "^7.7.1"
},
"build": {
"appId": "dev.mythbound.launcher",
"productName": "Mythbound Launcher",
"directories": {
"output": "dist"
},
"extraMetadata": {
"updateFolder": "updates"
},
"linux": {
"target": [
{
"target": "AppImage",
"arch": [
"x64"
]
},
{
"target": "deb",
"arch": [
"x64"
]
}
],
"category": "Game",
"synopsis": "Official launcher for Mythbound RPG.",
"description": "Launch and manage your Mythbound game installation with automatic updates and news feeds."
},
"win": {
"target": [
{
"target": "nsis",
"arch": [
"x64"
]
},
{
"target": "portable",
"arch": [
"x64"
]
}
],
"icon": "mythbound_logo.ico",
"publisherName": "Mythbound",
"verifyUpdateCodeSignature": false
},
"nsis": {
"oneClick": false,
"allowToChangeInstallationDirectory": true,
"createDesktopShortcut": true,
"createStartMenuShortcut": true,
"shortcutName": "Mythbound Launcher"
},
"files": [
"main.js",
"index.html",
"resources/**/*",
"!resources/.gitkeep"
],
"extraResources": [
{
"from": "resources",
"to": "resources",
"filter": [
"**/*"
]
}
]
}
}

================================================================================
FILE: mythbound-launcher/resources/data/css/aos.css
SIZE: 608
MODIFIED: Sun Mar 2 11:08:02 PM AWST 2025
================================================================================

[data-aos][data-aos][data-aos-delay="1000"].aos-animate, body[data-aos-delay="1000"] [data-aos].aos-animate {
transition-delay: 1s;
}

[data-aos^=fade][data-aos^=fade].aos-animate {
opacity: 1;
transform: translateZ(0);
}
[data-aos][data-aos][data-aos-delay="1000"], body[data-aos-delay="1000"] [data-aos] {
transition-delay: 0;
}
[data-aos][data-aos][data-aos-duration="500"], body[data-aos-duration="500"] [data-aos] {
transition-duration: .5s;
}
[data-aos][data-aos][data-aos-easing=ease], body[data-aos-easing=ease] [data-aos] {
transition-timing-function: ease;
}

================================================================================
FILE: mythbound-launcher/resources/data/css/style.css
SIZE: 11K
MODIFIED: Sun Mar 9 06:31:32 PM AWST 2025
================================================================================

- {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
  }

body {
font-family: sans-serif;
background-color: #222;
color: #ccc;
overflow: hidden;
height: 100vh;
width: 100vw;
}

#preloader {
position: fixed;
top: 0;
left: 0;
right: 0;
bottom: 0;
background: #111;
display: flex;
align-items: center;
justify-content: center;
z-index: 9999;
}

.spinner-multi {
position: relative;
width: 120px;
height: 120px;
}
.spinner-multi .circle {
position: absolute;
top: 50%;
left: 50%;
transform: translate(-50%, -50%);
border: 2px solid #999;
border-radius: 50%;
animation-iteration-count: infinite;
animation-timing-function: linear;
}

.spinner-multi .circle:nth-child(1) {
width: 20px;
height: 20px;
border-top-color: #ffcc00;
animation: spinCW 1.2s infinite;
}
.spinner-multi .circle:nth-child(2) {
width: 30px;
height: 30px;
border-right-color: #ffcc00;
animation: spinCCW 1.5s infinite;
}
.spinner-multi .circle:nth-child(3) {
width: 40px;
height: 40px;
border-bottom-color: #ffcc00;
animation: spinCW 1.8s infinite;
}
.spinner-multi .circle:nth-child(4) {
width: 50px;
height: 50px;
border-left-color: #ffcc00;
animation: spinCCW 2s infinite;
}
.spinner-multi .circle:nth-child(5) {
width: 60px;
height: 60px;
border-top-color: #ffcc00;
animation: spinCW 2.2s infinite;
}
.spinner-multi .circle:nth-child(6) {
width: 70px;
height: 70px;
border-right-color: #ffcc00;
animation: spinCCW 2.5s infinite;
}
.spinner-multi .circle:nth-child(7) {
width: 80px;
height: 80px;
border-bottom-color: #ffcc00;
animation: spinCW 2.8s infinite;
}
.spinner-multi .circle:nth-child(8) {
width: 90px;
height: 90px;
border-left-color: #ffcc00;
animation: spinCCW 3s infinite;
}
@keyframes spinCW {
0% {
transform: translate(-50%, -50%) rotate(0deg);
}
100% {
transform: translate(-50%, -50%) rotate(360deg);
}
}
@keyframes spinCCW {
0% {
transform: translate(-50%, -50%) rotate(0deg);
}
100% {
transform: translate(-50%, -50%) rotate(-360deg);
}
}

#launcher {
display: none;
height: 100%;
width: 100%;
overflow: hidden;
position: relative;
background-color: #1a1a1a;
}

.top-bar {
display: flex;
align-items: center;
justify-content: space-between;
background-color: #2b2b2b;
height: 50px;
padding: 0 10px;
color: #fff;
}
.top-left {
top: 3px;
margin-left:15px
display:flex;
align-items: center;
-webkit-app-region: no-drag;
}
.top-center,
.top-right {
display: flex;
align-items: center;
margin-right:13px;
top: 15px;
-webkit-app-region: no-drag;
}
.top-left {
position: relative;
}
.menu-btn {
background: none;
border: none;
color: #fff;
font-size: 1.2rem;
cursor: pointer;
margin-right: 10px;
transition: transform 0.3s;
}
.menu-btn:hover {
transform: scale(1.1);
}
.menu-panel {
display: none;
position: absolute;
top: 37px;
left: 0;
background: #2b2b2b;
border: 1px solid #444;
width: 150px;
z-index: 999;
}
.menu-panel ul {
list-style: none;
}
.menu-panel ul li a {
display: block;
padding: 10px;
color: #fff;
text-decoration: none;
transition: background 0.3s;
}
.menu-panel ul li a:hover {
background-color: #444;
}
.logo {
height: 40px;
object-fit: contain;
transition: transform 0.3s;
}
.logo:hover {
transform: scale(1.05);
}
.window-btn {
background: none;
border: none;
color: #fff;
font-size: 1.3rem;
cursor: pointer;
margin-left: 10px;
transition: transform 0.3s;
}
.window-btn:hover {
transform: scale(1.1);
}

.content-wrapper {
display: flex;
height: calc(100% - 100px);
background-color: #1a1a1a;
}

.left-panel {
width: 220px;
background-color: #2b2b2b;
border-right: 1px solid #444;
text-align: center;
}

.left-panel ul {
list-style: none;
margin: 0;
padding: 0;
}

.left-panel li {
position: relative;
display: flex;
align-items: center;
justify-content: center;
height: 80px;
padding-left: 80px;
cursor: pointer;
border-bottom: 1px solid #444;
user-select: none;
transition: background 0.3s, transform 0.3s;
}

.left-panel li.active {
background-color: #444;
}

.left-panel li:hover {
background-color: #3a3a3a;
transform: scale(1.02);
}

.left-panel li .tab-icon {
position: absolute;
left: 15px;
top: 50%;
width: 64px;
transform: translateY(-50%);
}

.left-panel li .tab-text {
display: block;
}

.tab-views {
flex: 1;
position: relative;
overflow: hidden;
}
.tab-view {
opacity: 0;
visibility: hidden;
transition: opacity 0.5s ease, visibility 0.5s;
position: absolute;
top: 0;
left: 0;
width: 100%;
height: 100%;
}
.tab-view.active {
opacity: 1;
visibility: visible;
z-index: 2;
}

.tab-background {
position: absolute;
top: 0;
left: 0;
right: 0;
bottom: 0;
overflow: hidden;
}
.tab-background img,
.tab-background video {
width: 100%;
height: 100%;
object-fit: cover;
}

.tab-content {
position: relative;
z-index: 3;
padding: 20px;
height: 100%;
width: 100%;
overflow-y: auto;
background-color: rgba(0, 0, 0, 0.4);
transition: background-color 0.3s;
}
.tab-content:hover {
background-color: rgba(0, 0, 0, 0.5);
}

.tab-content::-webkit-scrollbar {
width: 8px;
background-color: transparent;
}
.tab-content:hover::-webkit-scrollbar {
background-color: #333;
}
.tab-content:hover::-webkit-scrollbar-thumb {
background-color: #ffcc00;
border-radius: 4px;
}

.bottom-bar {
position: relative;
height: 50px;
background-color: #2b2b2b;
border-top: 1px solid #444;
}

.footer-copy {
position: absolute;
left: 50%;
top: 50%;
transform: translate(-50%, -50%);
font-size: 0.9rem;
color: #ccc;
text-align: center;
}

.footer-copy a {
color: #ffcc00;
text-decoration: none;
}

.footer-buttons {
position: absolute;
right: 10px;
top: 50%;
transform: translateY(-50%);
display: flex;
gap: 10px;
}

.action-btn {
background-color: #ffcc00;
color: #000;
border: none;
padding: 10px 20px;
cursor: pointer;
font-weight: bold;
border-radius: 4px;
transition: background 0.3s, transform 0.3s;
font-size: 1rem;
}
.action-btn:hover {
background-color: #ffdd44;
transform: scale(1.05);
}

.grid-container {
display: grid;
grid-template-columns: repeat(auto-fit, minmax(450px, 1fr));
gap: 16px;
margin-top: 20px;
}
.grid-item {
background-color: rgba(51, 51, 51, 0.5);
padding: 10px;
border-radius: 4px;
text-align: center;
transition: transform 0.3s;
}
.grid-item:hover {
transform: scale(1.02);
}
.grid-item img {
width: 100%;
height: 300px;
border-radius: 4px;
}

.news-panel {
background-color: rgba(51, 51, 51, 0.5);
margin: 20px auto;
padding: 15px;
border-radius: 4px;
transition: transform 0.3s;
display: flex;
flex-direction: row;
align-items: center;
width: 85%;
}
.news-panel:hover {
transform: scale(1.02);
}
.news-panel img {
width: 40%;
border-radius: 4px;
margin-right: 10px;
}
.news-panel p {
width: 60%;
margin: 0;
}

.changelog-panel {
width: 60%;
margin: 0 auto;
background-color: rgba(0, 0, 0, 0.6);
padding: 20px;
border-radius: 6px;
transition: transform 0.3s;
}
.changelog-panel:hover {
transform: scale(1.02);
}

.wiki-menu {
display: flex;
flex-wrap: wrap;
gap: 10px;
margin-bottom: 20px;
}
.wiki-button {
flex: 0 0 auto;
background-color: #333;
color: #ccc;
border: none;
padding: 10px;
border-radius: 6px;
cursor: pointer;
transition: background 0.3s, color 0.3s, transform 0.3s;
text-align: center;
min-width: 100px;
}
.wiki-button:hover {
background-color: #ffcc00;
color: #000;
transform: scale(1.05);
}
.wiki-content {
background-color: rgba(0, 0, 0, 0.5);
padding: 15px;
border-radius: 6px;
min-height: 200px;
transition: transform 0.3s;
}
.wiki-content:hover {
transform: scale(1.02);
}

.home-header {
text-align: center;
margin-top: 10px;
margin-bottom: 620px;
}
.home-logo {
max-width: 600px;
width: 100%;
margin-bottom: 20px;
margin-left:10px;
}

.home-description {
font-size: 1.2rem;
margin: 0 auto;
text-align: center;
margin-top: -300px;
max-width: 600px;
line-height: 1.4;
z-index: 1;
}

.scroll-indicator {
margin-bottom: 20px;
display: flex;
flex-direction: column;
align-items: center;
animation: bounce 2s infinite;
}
.scroll-indicator .arrow {
font-size: 2rem;
line-height: 1;
}
.scroll-indicator .scroll-text {
font-size: 1rem;
margin-top: 5px;
color: #ffcc00;
}
@keyframes bounce {
0%,
20%,
50%,
80%,
100% {
transform: translateY(0);
}
40% {
transform: translateY(10px);
}
60% {
transform: translateY(5px);
}
}

@media (max-width: 768px) {
.left-panel {
width: 60px;
}
.left-panel li {
padding: 10px;
font-size: 0.8rem;
}
.top-bar {
height: 40px;
}
.bottom-bar {
height: 40px;
}
.action-btn {
padding: 6px 12px;
font-size: 0.8rem;
}
.changelog-panel {
width: 90%;
}
}

.home-character {
position: absolute;
margin-top: 250px;
left: 51%;
-webkit-transform: translateX(-50%) !important;
-ms-transform: translateX(-50%) !important;
transform: translateX(-50%) !important;
top: 0;
z-index: -1;
pointer-events: none;
height: 93%;
max-width: 93%;
}

.home-character\_\_animation {
mix-blend-mode: screen;
position: absolute;
width: 93%;
height: 93%;
left: 0;
z-index: 1;
}

@media (max-width: 1300px) {
.home-character\_\_animation {
transform: scale(0.9);
}
}

@media (max-width: 1300px) {
.home-character**image {
transform: scale(0.9);
}
}
.home-character**image {
width: 93%;
height: 93%;
}

================================================================================
FILE: mythbound-launcher/resources/data/js/aos.js
SIZE: 25K
MODIFIED: Sat May 24 12:17:17 AM AWST 2025
================================================================================

!(function (e, t) {
"object" == typeof exports && "object" == typeof module
? (module.exports = t())
: "function" == typeof define && define.amd
? define([], t)
: "object" == typeof exports
? (exports.AOS = t())
: (e.AOS = t());
})(this, function () {
return (function (e) {
function t(o) {
if (n[o]) return n[o].exports;
var i = (n[o] = {
exports: {},
id: o,
loaded: !1,
});
return e[o].call(i.exports, i, i.exports, t), (i.loaded = !0), i.exports;
}
var n = {};
return (t.m = e), (t.c = n), (t.p = "dist/"), t(0);
})([
function (e, t, n) {
"use strict";
function o(e) {
return e && e.**esModule
? e
: {
default: e,
};
}
var i =
Object.assign ||
function (e) {
for (var t = 1; t < arguments.length; t++) {
var n = arguments[t];
for (var o in n)
Object.prototype.hasOwnProperty.call(n, o) && (e[o] = n[o]);
}
return e;
},
r = n(1),
a = (o(r), n(6)),
u = o(a),
c = n(7),
f = o(c),
s = n(8),
d = o(s),
l = n(9),
p = o(l),
m = n(10),
b = o(m),
v = n(11),
y = o(v),
g = n(14),
h = o(g),
w = [],
k = !1,
x = document.all && !window.atob,
j = {
offset: 120,
delay: 0,
easing: "ease",
duration: 400,
disable: !1,
once: !1,
startEvent: "DOMContentLoaded",
throttleDelay: 99,
debounceDelay: 50,
disableMutationObserver: !1,
},
O = function () {
var e =
arguments.length > 0 && void 0 !== arguments[0] && arguments[0];
if ((e && (k = !0), k))
return (w = (0, y.default)(w, j)), (0, b.default)(w, j.once), w;
},
_ = function () {
(w = (0, h.default)()), O();
},
S = function () {
w.forEach(function (e, t) {
e.node.removeAttribute("data-aos"),
e.node.removeAttribute("data-aos-easing"),
e.node.removeAttribute("data-aos-duration"),
e.node.removeAttribute("data-aos-delay");
});
},
z = function (e) {
return (
e === !0 ||
("mobile" === e && p.default.mobile()) ||
("phone" === e && p.default.phone()) ||
("tablet" === e && p.default.tablet()) ||
("function" == typeof e && e() === !0)
);
},
A = function (e) {
return (
(j = i(j, e)),
(w = (0, h.default)()),
z(j.disable) || x
? S()
: (document
.querySelector("body")
.setAttribute("data-aos-easing", j.easing),
document
.querySelector("body")
.setAttribute("data-aos-duration", j.duration),
document
.querySelector("body")
.setAttribute("data-aos-delay", j.delay),
"DOMContentLoaded" === j.startEvent &&
["complete", "interactive"].indexOf(document.readyState) > -1
? O(!0)
: "load" === j.startEvent
? window.addEventListener(j.startEvent, function () {
O(!0);
})
: document.addEventListener(j.startEvent, function () {
O(!0);
}),
window.addEventListener(
"resize",
(0, f.default)(O, j.debounceDelay, !0)
),
window.addEventListener(
"orientationchange",
(0, f.default)(O, j.debounceDelay, !0)
),
window.addEventListener(
"scroll",
(0, u.default)(function () {
(0, b.default)(w, j.once);
}, j.throttleDelay)
),
j.disableMutationObserver || (0, d.default)("[data-aos]", _),
w)
);
};
e.exports = {
init: A,
refresh: O,
refreshHard: _,
};
},
function (e, t) {},
,
,
,
,
function (e, t) {
(function (t) {
"use strict";
function n(e, t, n) {
function o(t) {
var n = b,
o = v;
return (b = v = void 0), (k = t), (g = e.apply(o, n));
}
function r(e) {
return (k = e), (h = setTimeout(s, t)), _ ? o(e) : g;
}
function a(e) {
var n = e - w,
o = e - k,
i = t - n;
return S ? j(i, y - o) : i;
}
function c(e) {
var n = e - w,
o = e - k;
return void 0 === w || n >= t || n < 0 || (S && o >= y);
}
function s() {
var e = O();
return c(e) ? d(e) : void (h = setTimeout(s, a(e)));
}
function d(e) {
return (h = void 0), z && b ? o(e) : ((b = v = void 0), g);
}
function l() {
void 0 !== h && clearTimeout(h), (k = 0), (b = w = v = h = void 0);
}
function p() {
return void 0 === h ? g : d(O());
}
function m() {
var e = O(),
n = c(e);
if (((b = arguments), (v = this), (w = e), n)) {
if (void 0 === h) return r(w);
if (S) return (h = setTimeout(s, t)), o(w);
}
return void 0 === h && (h = setTimeout(s, t)), g;
}
var b,
v,
y,
g,
h,
w,
k = 0,
_ = !1,
S = !1,
z = !0;
if ("function" != typeof e) throw new TypeError(f);
return (
(t = u(t) || 0),
i(n) &&
((_ = !!n.leading),
(S = "maxWait" in n),
(y = S ? x(u(n.maxWait) || 0, t) : y),
(z = "trailing" in n ? !!n.trailing : z)),
(m.cancel = l),
(m.flush = p),
m
);
}
function o(e, t, o) {
var r = !0,
a = !0;
if ("function" != typeof e) throw new TypeError(f);
return (
i(o) &&
((r = "leading" in o ? !!o.leading : r),
(a = "trailing" in o ? !!o.trailing : a)),
n(e, t, {
leading: r,
maxWait: t,
trailing: a,
})
);
}
function i(e) {
var t = "undefined" == typeof e ? "undefined" : c(e);
return !!e && ("object" == t || "function" == t);
}
function r(e) {
return (
!!e && "object" == ("undefined" == typeof e ? "undefined" : c(e))
);
}
function a(e) {
return (
"symbol" == ("undefined" == typeof e ? "undefined" : c(e)) ||
(r(e) && k.call(e) == d)
);
}
function u(e) {
if ("number" == typeof e) return e;
if (a(e)) return s;
if (i(e)) {
var t = "function" == typeof e.valueOf ? e.valueOf() : e;
e = i(t) ? t + "" : t;
}
if ("string" != typeof e) return 0 === e ? e : +e;
e = e.replace(l, "");
var n = m.test(e);
return n || b.test(e) ? v(e.slice(2), n ? 2 : 8) : p.test(e) ? s : +e;
}
var c =
"function" == typeof Symbol && "symbol" == typeof Symbol.iterator
? function (e) {
return typeof e;
}
: function (e) {
return e &&
"function" == typeof Symbol &&
e.constructor === Symbol &&
e !== Symbol.prototype
? "symbol"
: typeof e;
},
f = "Expected a function",
s = NaN,
d = "[object Symbol]",
l = /^\s+|\s+$/g,
          p = /^[-+]0x[0-9a-f]+$/i,
m = /^0b[01]+$/i,
          b = /^0o[0-7]+$/i,
v = parseInt,
y =
"object" == ("undefined" == typeof t ? "undefined" : c(t)) &&
t &&
t.Object === Object &&
t,
g =
"object" == ("undefined" == typeof self ? "undefined" : c(self)) &&
self &&
self.Object === Object &&
self,
h = y || g || Function("return this")(),
w = Object.prototype,
k = w.toString,
x = Math.max,
j = Math.min,
O = function () {
return h.Date.now();
};
e.exports = o;
}).call(
t,
(function () {
return this;
})()
);
},
function (e, t) {
(function (t) {
"use strict";
function n(e, t, n) {
function i(t) {
var n = b,
o = v;
return (b = v = void 0), (O = t), (g = e.apply(o, n));
}
function r(e) {
return (O = e), (h = setTimeout(s, t)), _ ? i(e) : g;
}
function u(e) {
var n = e - w,
o = e - O,
i = t - n;
return S ? x(i, y - o) : i;
}
function f(e) {
var n = e - w,
o = e - O;
return void 0 === w || n >= t || n < 0 || (S && o >= y);
}
function s() {
var e = j();
return f(e) ? d(e) : void (h = setTimeout(s, u(e)));
}
function d(e) {
return (h = void 0), z && b ? i(e) : ((b = v = void 0), g);
}
function l() {
void 0 !== h && clearTimeout(h), (O = 0), (b = w = v = h = void 0);
}
function p() {
return void 0 === h ? g : d(j());
}
function m() {
var e = j(),
n = f(e);
if (((b = arguments), (v = this), (w = e), n)) {
if (void 0 === h) return r(w);
if (S) return (h = setTimeout(s, t)), i(w);
}
return void 0 === h && (h = setTimeout(s, t)), g;
}
var b,
v,
y,
g,
h,
w,
O = 0,
_ = !1,
S = !1,
z = !0;
if ("function" != typeof e) throw new TypeError(c);
return (
(t = a(t) || 0),
o(n) &&
((\_ = !!n.leading),
(S = "maxWait" in n),
(y = S ? k(a(n.maxWait) || 0, t) : y),
(z = "trailing" in n ? !!n.trailing : z)),
(m.cancel = l),
(m.flush = p),
m
);
}
function o(e) {
var t = "undefined" == typeof e ? "undefined" : u(e);
return !!e && ("object" == t || "function" == t);
}
function i(e) {
return (
!!e && "object" == ("undefined" == typeof e ? "undefined" : u(e))
);
}
function r(e) {
return (
"symbol" == ("undefined" == typeof e ? "undefined" : u(e)) ||
(i(e) && w.call(e) == s)
);
}
function a(e) {
if ("number" == typeof e) return e;
if (r(e)) return f;
if (o(e)) {
var t = "function" == typeof e.valueOf ? e.valueOf() : e;
e = o(t) ? t + "" : t;
}
if ("string" != typeof e) return 0 === e ? e : +e;
e = e.replace(d, "");
var n = p.test(e);
return n || m.test(e) ? b(e.slice(2), n ? 2 : 8) : l.test(e) ? f : +e;
}
var u =
"function" == typeof Symbol && "symbol" == typeof Symbol.iterator
? function (e) {
return typeof e;
}
: function (e) {
return e &&
"function" == typeof Symbol &&
e.constructor === Symbol &&
e !== Symbol.prototype
? "symbol"
: typeof e;
},
c = "Expected a function",
f = NaN,
s = "[object Symbol]",
d = /^\s+|\s+$/g,
          l = /^[-+]0x[0-9a-f]+$/i,
p = /^0b[01]+$/i,
          m = /^0o[0-7]+$/i,
b = parseInt,
v =
"object" == ("undefined" == typeof t ? "undefined" : u(t)) &&
t &&
t.Object === Object &&
t,
y =
"object" == ("undefined" == typeof self ? "undefined" : u(self)) &&
self &&
self.Object === Object &&
self,
g = v || y || Function("return this")(),
h = Object.prototype,
w = h.toString,
k = Math.max,
x = Math.min,
j = function () {
return g.Date.now();
};
e.exports = n;
}).call(
t,
(function () {
return this;
})()
);
},
function (e, t) {
"use strict";
function n(e, t) {
var n = new r(o);
(a = t),
n.observe(i.documentElement, {
childList: !0,
subtree: !0,
removedNodes: !0,
});
}
function o(e) {
e &&
e.forEach(function (e) {
var t = Array.prototype.slice.call(e.addedNodes),
n = Array.prototype.slice.call(e.removedNodes),
o = t.concat(n).filter(function (e) {
return e.hasAttribute && e.hasAttribute("data-aos");
}).length;
o && a();
});
}
Object.defineProperty(t, "**esModule", {
value: !0,
});
var i = window.document,
r =
window.MutationObserver ||
window.WebKitMutationObserver ||
window.MozMutationObserver,
a = function () {};
t.default = n;
},
function (e, t) {
"use strict";
function n(e, t) {
if (!(e instanceof t))
throw new TypeError("Cannot call a class as a function");
}
function o() {
return navigator.userAgent || navigator.vendor || window.opera || "";
}
Object.defineProperty(t, "**esModule", {
value: !0,
});
var i = (function () {
function e(e, t) {
for (var n = 0; n < t.length; n++) {
var o = t[n];
(o.enumerable = o.enumerable || !1),
(o.configurable = !0),
"value" in o && (o.writable = !0),
Object.defineProperty(e, o.key, o);
}
}
return function (t, n, o) {
return n && e(t.prototype, n), o && e(t, o), t;
};
})(),
r =
/(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|mobile.+firefox|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows ce|xda|xiino/i,
a =
/1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-/i,
u =
/(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|mobile.+firefox|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows ce|xda|xiino|android|ipad|playbook|silk/i,
c =
/1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-/i,
f = (function () {
function e() {
n(this, e);
}
return (
i(e, [
{
key: "phone",
value: function () {
var e = o();
return !(!r.test(e) && !a.test(e.substr(0, 4)));
},
},
{
key: "mobile",
value: function () {
var e = o();
return !(!u.test(e) && !c.test(e.substr(0, 4)));
},
},
{
key: "tablet",
value: function () {
return this.mobile() && !this.phone();
},
},
]),
e
);
})();
t.default = new f();
},
function (e, t) {
"use strict";
Object.defineProperty(t, "**esModule", {
value: !0,
});
var n = function (e, t, n) {
var o = e.node.getAttribute("data-aos-once");
t > e.position
? e.node.classList.add("aos-animate")
: "undefined" != typeof o &&
("false" === o || (!n && "true" !== o)) &&
e.node.classList.remove("aos-animate");
},
o = function (e, t) {
var o = window.pageYOffset,
i = window.innerHeight;
e.forEach(function (e, r) {
n(e, i + o, t);
});
};
t.default = o;
},
function (e, t, n) {
"use strict";
function o(e) {
return e && e.**esModule
? e
: {
default: e,
};
}
Object.defineProperty(t, "**esModule", {
value: !0,
});
var i = n(12),
r = o(i),
a = function (e, t) {
return (
e.forEach(function (e, n) {
e.node.classList.add("aos-init"),
(e.position = (0, r.default)(e.node, t.offset));
}),
e
);
};
t.default = a;
},
function (e, t, n) {
"use strict";
function o(e) {
return e && e.**esModule
? e
: {
default: e,
};
}
Object.defineProperty(t, "**esModule", {
value: !0,
});
var i = n(13),
r = o(i),
a = function (e, t) {
var n = 0,
o = 0,
i = window.innerHeight,
a = {
offset: e.getAttribute("data-aos-offset"),
anchor: e.getAttribute("data-aos-anchor"),
anchorPlacement: e.getAttribute("data-aos-anchor-placement"),
};
switch (
(a.offset && !isNaN(a.offset) && (o = parseInt(a.offset)),
a.anchor &&
document.querySelectorAll(a.anchor) &&
(e = document.querySelectorAll(a.anchor)[0]),
(n = (0, r.default)(e).top),
a.anchorPlacement)
) {
case "top-bottom":
break;
case "center-bottom":
n += e.offsetHeight / 2;
break;
case "bottom-bottom":
n += e.offsetHeight;
break;
case "top-center":
n += i / 2;
break;
case "bottom-center":
n += i / 2 + e.offsetHeight;
break;
case "center-center":
n += i / 2 + e.offsetHeight / 2;
break;
case "top-top":
n += i;
break;
case "bottom-top":
n += e.offsetHeight + i;
break;
case "center-top":
n += e.offsetHeight / 2 + i;
}
return a.anchorPlacement || a.offset || isNaN(t) || (o = t), n + o;
};
t.default = a;
},
function (e, t) {
"use strict";
Object.defineProperty(t, "\_\_esModule", {
value: !0,
});
var n = function (e) {
for (
var t = 0, n = 0;
e && !isNaN(e.offsetLeft) && !isNaN(e.offsetTop);

        )
          (t += e.offsetLeft - ("BODY" != e.tagName ? e.scrollLeft : 0)),
            (n += e.offsetTop - ("BODY" != e.tagName ? e.scrollTop : 0)),
            (e = e.offsetParent);
        return {
          top: n,
          left: t,
        };
      };
      t.default = n;
    },
    function (e, t) {
      "use strict";
      Object.defineProperty(t, "__esModule", {
        value: !0,
      });
      var n = function (e) {
        return (
          (e = e || document.querySelectorAll("[data-aos]")),
          Array.prototype.map.call(e, function (e) {
            return {
              node: e,
            };
          })
        );
      };
      t.default = n;
    },

]);
});

================================================================================
FILE: mythbound-launcher/resources/data/js/script.js
SIZE: 2.8K
MODIFIED: Sat May 24 12:17:15 AM AWST 2025
================================================================================

window.addEventListener("load", () => {
const preloader = document.getElementById("preloader");
const launcher = document.getElementById("launcher");
setTimeout(() => {
preloader.style.display = "none";
launcher.style.display = "block";
}, 1000);
});

const tabButtons = document.querySelectorAll(".tab-button");
const tabViews = document.querySelectorAll(".tab-view");
tabButtons.forEach((btn) => {
btn.addEventListener("click", () => {
tabButtons.forEach((b) => b.classList.remove("active"));
tabViews.forEach((view) => view.classList.remove("active"));
btn.classList.add("active");
const targetTab = btn.getAttribute("data-tab");
document.getElementById(targetTab).classList.add("active");
});
});

const menuBtn = document.querySelector(".menu-btn");
const menuPanel = document.getElementById("menuPanel");
menuBtn.addEventListener("click", () => {
menuPanel.style.display =
menuPanel.style.display === "block" ? "none" : "block";
});

const wikiButtons = document.querySelectorAll(".wiki-button");
const wikiContent = document.getElementById("wikiContent");
const wikiData = {
1: "<img src='https://opengamescommunity.com/hellgrave/img/features/ancestral_hall_craft.png' style='width:800px'> <img src='https://opengamescommunity.com/hellgrave/img/features/forge_windows1.png' style='width:480px'><br><div class='wiki__content-title-desc'> Ancestral Hall, is a place that can be reached after completing the <b>Secret Quest</b>.<br> At this place you will find some crafting tables where you can start craft ressources and materials, but also scrolls, parchments, artifacts, emblems, equipments, potions and much more.<br>Before to start you will find at the entrance two green tables, where you can start crafting the right scrolls in order to use the right tables (right click on each table to see the recipes and start Crafting , you can see each recipe for each craft ).<br> For example if you wish craft Minerals, you will need before craft Minning Scroll then use it in order to learn recipes and start crafting minerals or refined minerals.</div>",
2: "How install wikipedia:<br>Go to your launcher folder:<br>- Enter on resources/data/js/script.js<br>- Edit the content here.",
3: "Content for Entry 3. Lorem ipsum dolor sit amet, ...",
4: "Content for Entry 4. Lorem ipsum dolor sit amet, ...",
5: "Content for Entry 5. Lorem ipsum dolor sit amet, ...",
6: "Content for Entry 6. Lorem ipsum dolor sit amet, ...",
7: "Content for Entry 7. Lorem ipsum dolor sit amet, ...",
};
wikiButtons.forEach((button) => {
button.addEventListener("click", () => {
const entryKey = button.getAttribute("data-entry");
wikiContent.innerHTML =
wikiData[entryKey] || "No content available for this entry.";
});
});

================================================================================
FILE: package.json
SIZE: 61
MODIFIED: Sat May 24 12:17:01 AM AWST 2025
================================================================================

{
"dependencies": {
"electron-updater": "^6.3.9"
}
}

================================================================================
FILE: readme.md
SIZE: 793
MODIFIED: Sat May 24 08:00:00 AM AWST 2025
================================================================================

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

================================================================================
EXPORT SUMMARY
================================================================================
Total files processed: 0
Text files: 0
Binary files: 0
Export completed at: Sat May 24 08:01:10 AM AWST 2025
================================================================================
