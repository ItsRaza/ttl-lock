# Setting Up Gradle Wrapper

The Gradle wrapper files are needed to build the Android APK. Here are options to set them up:

## Option 1: Download Gradle Wrapper JAR (Easiest)

1. Download `gradle-wrapper.jar` from:
   https://raw.githubusercontent.com/gradle/gradle/v7.5.1/gradle/wrapper/gradle-wrapper.jar

2. Place it in: `android/gradle/wrapper/gradle-wrapper.jar`

3. The `gradlew.bat` and `gradle-wrapper.properties` files are already created.

## Option 2: Install Gradle and Generate Wrapper

1. Download Gradle from: https://gradle.org/releases/
   - Download Gradle 7.5.1 or later
   - Extract to a folder (e.g., `C:\Gradle`)

2. Add Gradle to PATH:
   ```powershell
   $currentPath = [System.Environment]::GetEnvironmentVariable("Path", "User")
   [System.Environment]::SetEnvironmentVariable("Path", "$currentPath;C:\Gradle\gradle-7.5.1\bin", "User")
   ```

3. Generate wrapper:
   ```powershell
   cd android
   gradle wrapper
   ```

## Option 3: Use Android Studio (One-time setup)

1. Install Android Studio (even if you don't plan to use it regularly)
2. Open the `android` folder in Android Studio
3. Android Studio will automatically set up the Gradle wrapper
4. You can then use the command line to build

## Quick Download Script

You can also use PowerShell to download the wrapper:

```powershell
$wrapperUrl = "https://raw.githubusercontent.com/gradle/gradle/v7.5.1/gradle/wrapper/gradle-wrapper.jar"
$wrapperPath = "android\gradle\wrapper\gradle-wrapper.jar"
New-Item -ItemType Directory -Path (Split-Path $wrapperPath) -Force
Invoke-WebRequest -Uri $wrapperUrl -OutFile $wrapperPath
```

