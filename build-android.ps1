# Android APK Build Script
# This script builds the Android APK without requiring Android Studio

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "TTLock App - Android APK Builder" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if we're in the right directory
if (-not (Test-Path "package.json")) {
    Write-Host "Error: package.json not found. Please run this script from the project root." -ForegroundColor Red
    exit 1
}

# Check for Node.js
Write-Host "Checking Node.js..." -ForegroundColor Yellow
try {
    $nodeVersion = node -version
    Write-Host "✓ Node.js found: $nodeVersion" -ForegroundColor Green
} catch {
    Write-Host "✗ Node.js not found. Please install Node.js from https://nodejs.org/" -ForegroundColor Red
    exit 1
}

# Check for Java
Write-Host "Checking Java..." -ForegroundColor Yellow
try {
    $javaVersion = java -version 2>&1 | Select-Object -First 1
    Write-Host "✓ Java found: $javaVersion" -ForegroundColor Green
} catch {
    Write-Host "✗ Java not found. Please install Java JDK 17 from https://adoptium.net/" -ForegroundColor Red
    exit 1
}

# Check for Android SDK
Write-Host "Checking Android SDK..." -ForegroundColor Yellow
$androidHome = $env:ANDROID_HOME
if (-not $androidHome) {
    $androidHome = $env:ANDROID_SDK_ROOT
}

if (-not $androidHome) {
    Write-Host "⚠ Android SDK not found in environment variables." -ForegroundColor Yellow
    Write-Host "  Checking android/local.properties..." -ForegroundColor Yellow
    
    if (Test-Path "android/local.properties") {
        $localProps = Get-Content "android/local.properties" | Where-Object { $_ -match "sdk.dir" }
        if ($localProps) {
            $sdkPath = $localProps -replace "sdk.dir=", "" -replace "\\", "\"
            if (Test-Path $sdkPath) {
                Write-Host "✓ Android SDK found in local.properties: $sdkPath" -ForegroundColor Green
                $androidHome = $sdkPath
            }
        }
    }
    
    if (-not $androidHome) {
        Write-Host "✗ Android SDK not found. Please install Android SDK or set ANDROID_HOME." -ForegroundColor Red
        Write-Host "  See BUILD_ANDROID.md for instructions." -ForegroundColor Yellow
        exit 1
    }
} else {
    Write-Host "✓ Android SDK found: $androidHome" -ForegroundColor Green
}

# Check for Gradle wrapper
Write-Host "Checking Gradle wrapper..." -ForegroundColor Yellow
if (-not (Test-Path "android\gradlew.bat")) {
    Write-Host "✗ Gradle wrapper not found. Creating it..." -ForegroundColor Yellow
    # Try to create gradle wrapper
    if (Get-Command gradle -ErrorAction SilentlyContinue) {
        Set-Location android
        gradle wrapper
        Set-Location ..
        Write-Host "✓ Gradle wrapper created" -ForegroundColor Green
    } else {
        Write-Host "⚠ Gradle not found. You may need to install Gradle or use Android Studio to generate the wrapper." -ForegroundColor Yellow
        Write-Host "  Alternatively, download gradle-wrapper.jar from:" -ForegroundColor Yellow
        Write-Host "  https://raw.githubusercontent.com/gradle/gradle/master/gradle/wrapper/gradle-wrapper.jar" -ForegroundColor Cyan
        Write-Host "  Place it in: android\gradle\wrapper\gradle-wrapper.jar" -ForegroundColor Yellow
    }
}

if (Test-Path "android\gradlew.bat") {
    Write-Host "✓ Gradle wrapper found" -ForegroundColor Green
} else {
    Write-Host "✗ Gradle wrapper setup incomplete. Cannot proceed." -ForegroundColor Red
    exit 1
}

# Install npm dependencies if node_modules doesn't exist
Write-Host ""
Write-Host "Checking npm dependencies..." -ForegroundColor Yellow
if (-not (Test-Path "node_modules")) {
    Write-Host "Installing npm dependencies (this may take a few minutes)..." -ForegroundColor Yellow
    npm install
    if ($LASTEXITCODE -ne 0) {
        Write-Host "✗ Failed to install npm dependencies" -ForegroundColor Red
        exit 1
    }
    Write-Host "✓ Dependencies installed" -ForegroundColor Green
} else {
    Write-Host "✓ Dependencies already installed" -ForegroundColor Green
}

# Build the APK
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Building Android APK..." -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Set-Location android

# Clean previous builds
Write-Host "Cleaning previous builds..." -ForegroundColor Yellow
.\gradlew.bat clean

# Build debug APK
Write-Host "Building debug APK (this may take several minutes on first build)..." -ForegroundColor Yellow
.\gradlew.bat assembleDebug

if ($LASTEXITCODE -eq 0) {
    Set-Location ..
    $apkPath = "android\app\build\outputs\apk\debug\app-debug.apk"
    
    if (Test-Path $apkPath) {
        $apkSize = (Get-Item $apkPath).Length / 1MB
        Write-Host ""
        Write-Host "========================================" -ForegroundColor Green
        Write-Host "✓ Build Successful!" -ForegroundColor Green
        Write-Host "========================================" -ForegroundColor Green
        Write-Host ""
        Write-Host "APK Location: $apkPath" -ForegroundColor Cyan
        Write-Host "APK Size: $([math]::Round($apkSize, 2)) MB" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "To install on your phone:" -ForegroundColor Yellow
        Write-Host "1. Transfer the APK file to your Android device" -ForegroundColor White
        Write-Host "2. Enable 'Install from Unknown Sources' in settings" -ForegroundColor White
        Write-Host "3. Open the APK file and install" -ForegroundColor White
        Write-Host ""
        
        # Ask if user wants to open the folder
        $openFolder = Read-Host "Open the APK folder? (Y/N)"
        if ($openFolder -eq "Y" -or $openFolder -eq "y") {
            Start-Process explorer.exe -ArgumentList (Split-Path (Resolve-Path $apkPath))
        }
    } else {
        Write-Host "✗ APK file not found at expected location" -ForegroundColor Red
        exit 1
    }
} else {
    Set-Location ..
    Write-Host ""
    Write-Host "✗ Build failed. Check the error messages above." -ForegroundColor Red
    exit 1
}

