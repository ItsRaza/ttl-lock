# Script to build a Release APK (Standalone)
$env:ANDROID_HOME = "C:\Android\sdk"

Write-Host "1. Cleaning previous builds..." -ForegroundColor Cyan
cd android
.\gradlew.bat clean
cd ..

Write-Host "2. Building Release APK..." -ForegroundColor Cyan
# assembleRelease automatically bundles the JS and assets
cd android
.\gradlew.bat assembleRelease
cd ..

Write-Host "Build Complete!" -ForegroundColor Green
Write-Host "APK Location: android\app\build\outputs\apk\release\app-release.apk" -ForegroundColor Cyan
Write-Host "NOTE: This APK is signed with the debug key, but acts like a release build (no Metro server needed)." -ForegroundColor Yellow

