# Script to restore missing Android icons
$baseUrl = "https://raw.githubusercontent.com/google/material-design-icons/master/png/action/android/materialicons/48dp/1x/baseline_android_black_48dp.png"
$resDir = "android\app\src\main\res"
$densities = @("mdpi", "hdpi", "xhdpi", "xxhdpi", "xxxhdpi")

foreach ($density in $densities) {
    $dir = "$resDir\mipmap-$density"
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
        Write-Host "Created $dir"
    }
    
    # Download/Copy icon
    $iconPath = "$dir\ic_launcher.png"
    $roundIconPath = "$dir\ic_launcher_round.png"
    
    try {
        Invoke-WebRequest -Uri $baseUrl -OutFile $iconPath -UseBasicParsing
        Copy-Item $iconPath $roundIconPath -Force
        Write-Host "Restored icons in $density"
    } catch {
        Write-Warning "Failed to download icon for $density"
    }
}

Write-Host "Icon restoration complete."

