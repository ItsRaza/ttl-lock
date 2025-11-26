# Script to generate debug.keystore
$keystorePath = "android\app\debug.keystore"

if (Test-Path $keystorePath) {
    Write-Host "Keystore already exists at $keystorePath"
} else {
    Write-Host "Generating debug.keystore..."
    
    # Use specific path found
    $keytool = "C:\Program Files\Java\jdk-17\bin\keytool.exe"
    
    if (-not (Test-Path $keytool)) {
        Write-Error "keytool not found at $keytool. Please verify Java installation."
        exit 1
    }

    & $keytool -genkey -v -keystore $keystorePath -storepass android -alias androiddebugkey -keypass android -keyalg RSA -keysize 2048 -validity 10000 -dname "CN=Android Debug,O=Android,C=US"
    
    if (Test-Path $keystorePath) {
        Write-Host "Debug keystore generated successfully!" -ForegroundColor Green
    } else {
        Write-Host "Failed to generate keystore" -ForegroundColor Red
    }
}
