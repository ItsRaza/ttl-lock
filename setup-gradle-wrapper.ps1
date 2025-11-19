# Script to download Gradle Wrapper JAR
Write-Host "Downloading Gradle Wrapper..." -ForegroundColor Cyan

$wrapperUrl = "https://raw.githubusercontent.com/gradle/gradle/v7.5.1/gradle/wrapper/gradle-wrapper.jar"
$wrapperDir = "android\gradle\wrapper"
$wrapperPath = "$wrapperDir\gradle-wrapper.jar"

# Create directory if it doesn't exist
if (-not (Test-Path $wrapperDir)) {
    New-Item -ItemType Directory -Path $wrapperDir -Force | Out-Null
    Write-Host "Created directory: $wrapperDir" -ForegroundColor Green
}

# Download the wrapper
try {
    Write-Host "Downloading from: $wrapperUrl" -ForegroundColor Yellow
    Invoke-WebRequest -Uri $wrapperUrl -OutFile $wrapperPath -UseBasicParsing
    Write-Host "✓ Gradle wrapper downloaded successfully!" -ForegroundColor Green
    Write-Host "Location: $wrapperPath" -ForegroundColor Cyan
} catch {
    Write-Host "✗ Failed to download Gradle wrapper" -ForegroundColor Red
    Write-Host "Error: $_" -ForegroundColor Red
    Write-Host ""
    Write-Host "Manual download:" -ForegroundColor Yellow
    Write-Host "1. Go to: https://raw.githubusercontent.com/gradle/gradle/v7.5.1/gradle/wrapper/gradle-wrapper.jar" -ForegroundColor Cyan
    Write-Host "2. Save as: $wrapperPath" -ForegroundColor Cyan
    exit 1
}

