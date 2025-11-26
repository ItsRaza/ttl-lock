# Building Android APK Without Android Studio

This guide will help you build an Android APK using only command-line tools (no Android Studio required).

## Prerequisites

### 1. Install Java JDK (Required)

Download and install **Java JDK 17** (or JDK 11):
- Download from: https://adoptium.net/ (choose JDK 17 for Windows x64)
- Or use: https://www.oracle.com/java/technologies/downloads/#java17
- After installation, verify:
  ```powershell
  java -version
  ```
  Should show version 17 or higher.

### 2. Install Android SDK Command Line Tools (Required)

1. Download Android SDK Command Line Tools:
   - Go to: https://developer.android.com/studio#command-tools
   - Download "Command line tools only" for Windows
   - Extract to a folder (e.g., `C:\Android\cmdline-tools`)

2. Create SDK directory structure:
   ```powershell
   # Create directories
   New-Item -ItemType Directory -Path "C:\Android\sdk" -Force
   New-Item -ItemType Directory -Path "C:\Android\cmdline-tools\latest" -Force
   ```

3. Move extracted tools to `latest` folder:
   - Extract the downloaded zip
   - Move all contents to `C:\Android\cmdline-tools\latest\`

4. Set environment variables:
   ```powershell
   # Set ANDROID_HOME
   [System.Environment]::SetEnvironmentVariable("ANDROID_HOME", "C:\Android\sdk", "User")
   
   # Add to PATH
   $currentPath = [System.Environment]::GetEnvironmentVariable("Path", "User")
   [System.Environment]::SetEnvironmentVariable("Path", "$currentPath;C:\Android\sdk\platform-tools;C:\Android\sdk\tools;C:\Android\cmdline-tools\latest\bin", "User")
   ```

5. Install required SDK components:
   ```powershell
   # Accept licenses and install components
   cd C:\Android\cmdline-tools\latest\bin
   .\sdkmanager.bat --licenses
   .\sdkmanager.bat "platform-tools" "platforms;android-33" "build-tools;33.0.0"
   ```

### 3. Install Node.js and npm (If not already installed)

- Download from: https://nodejs.org/ (LTS version)
- Verify installation:
  ```powershell
  node -version
  npm -version
  ```

## Building the APK

### Step 1: Install Project Dependencies

```powershell
cd D:\Raza\TTLockApp
npm install
```
----yahan tak kr lia 23/11/25 10:13---
### Step 2: Update Android local.properties

Create or update `android/local.properties` file and add your SDK path:

**Note:** This is a file edit, not a PowerShell command. Open `android/local.properties` in a text editor and add/update this line:

```properties
sdk.dir=C:\\Android\\sdk
```

Or if your SDK is in a different location, update the path accordingly (use double backslashes `\\` for Windows paths).

### Step 3: Build the APK

**Important:** Before building, make sure your environment variables are set. In your PowerShell terminal, run:

```powershell
$env:ANDROID_HOME = "C:\Android\sdk"
```

**Option A: Using Gradle Wrapper (Recommended)**

```powershell
cd android
$env:ANDROID_HOME = "C:\Android\sdk"
.\gradlew.bat assembleDebug
```

The APK will be generated at:
`android/app/build/outputs/apk/debug/app-debug.apk`

**Option B: Using npm script**

```powershell
cd D:\Raza\TTLockApp
npm run android
```

### Step 4: Install on Your Phone

1. Transfer `app-debug.apk` to your Android phone
2. Enable "Install from Unknown Sources" in your phone settings
3. Open the APK file on your phone and install

## Alternative: Using GitHub Actions (Cloud Build)

If you prefer not to install Android SDK locally, you can use GitHub Actions to build the APK in the cloud. I can help set this up if you'd like.

## Troubleshooting

### "SDK location not found"
- Make sure `android/local.properties` exists with correct `sdk.dir` path
- Use double backslashes: `C:\\Android\\sdk`

### "Java not found"
- Make sure Java JDK is installed and in PATH
- Verify with: `java -version`

### "Gradle build failed"
- Make sure all SDK components are installed
- Check internet connection (Gradle downloads dependencies)

### Build takes too long
- First build downloads many dependencies (can take 10-20 minutes)
- Subsequent builds are much faster

## Quick Build Script

I've created a `build-android.ps1` script to automate the build process. Run:

```powershell
.\build-android.ps1
```

