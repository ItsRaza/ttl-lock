# Script to build a standalone Android APK (with bundled JS)
$env:ANDROID_HOME = "C:\Android\sdk"

Write-Host "1. Cleaning previous builds..." -ForegroundColor Cyan
cd android
.\gradlew.bat clean
cd ..

Write-Host "2. Creating asset directory..." -ForegroundColor Cyan
$assetDir = "android\app\src\main\assets"
if (-not (Test-Path $assetDir)) {
    New-Item -ItemType Directory -Path $assetDir -Force | Out-Null
}

Write-Host "3. Bundling JavaScript..." -ForegroundColor Cyan
cmd /c "npx react-native bundle --platform android --dev false --entry-file index.js --bundle-output android/app/src/main/assets/index.android.bundle --assets-dest android/app/src/main/res"

if ($LASTEXITCODE -ne 0) {
    Write-Error "Bundling failed!"
    exit 1
}

Write-Host "4. Building APK..." -ForegroundColor Cyan
cd android
.\gradlew.bat assembleDebug
cd ..

Write-Host "Build Complete!" -ForegroundColor Green
Write-Host "APK Location: android\app\build\outputs\apk\debug\app-debug.apk" -ForegroundColor Cyan
