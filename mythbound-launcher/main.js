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
  process.env.NODE_ENV === "development" ? __dirname : process.resourcesPath;
const resourcesPath = path.join(__dirname, "resources");
console.log(`Resources Path (dev): ${resourcesPath}`);

const userDataDir = app.getPath("userData");
const persistentBaseDir = path.join(userDataDir, "mythbound");
fs.ensureDirSync(persistentBaseDir);

// const clientExePath = path.join(resourceRoot, 'resources', 'otclient.exe'); // If exe is inside folder resources where luncher is located (NOT RECOMMENDED, use instead the method to trigger download after install launcher, instead of installing launcher and game first time )
const clientExePath = path.join(
  persistentBaseDir,
  "mythbound-windows",
  "otclient.exe"
);
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
    const sanitized = url.replace(/[:\/\\]+/g, "_");
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

  // autoUpdater.setFeedURL({
  //   provider: "github",
  //   owner: "tibia-oce",
  //   repo: "mythbound-client-public",
  //   private: false,
  // });

  // autoUpdater.checkForUpdatesAndNotify();
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

      const zipFileName = manifest.zipFileName || manifest.path;
      if (!zipFileName) {
        console.error("No zipFileName or path found in manifest.");
        event.sender.send("update-status", "Missing zip filename in manifest.");
        return;
      }
      const fileUrl = baseUrl + zipFileName;

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
