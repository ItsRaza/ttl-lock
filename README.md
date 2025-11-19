# TTLock BLE MVP

A React Native mobile application for controlling TTLock smart locks via Bluetooth Low Energy (BLE).

## Features

- 🔌 Connect to TTLock devices via BLE
- 🔓 Unlock doors remotely
- 🔒 Lock doors remotely
- 📱 Cross-platform support (iOS & Android)

## Prerequisites

- Node.js >= 16
- React Native development environment set up
- For iOS: Xcode and CocoaPods
- For Android: Android Studio and Android SDK

## Installation

1. Install dependencies:
```bash
npm install
```

2. For iOS, install CocoaPods:
```bash
cd ios
pod install
cd ..
```

## Configuration

Before running the app, you need to configure your lock credentials in `config/lockConfig.js`:

```javascript
export default {
    LOCK_MAC: "AA:BB:CC:DD:EE:FF", // Replace with your actual lock MAC address
    LOCK_DATA: "PUT_LOCK_DATA_HERE", // Replace with your lock data
    AES_KEY: "PUT_AES_KEY_HERE", // Replace with your AES key
    PROTOCOL_VERSION: 3,
};
```

## Running the App

### iOS
```bash
npm run ios
```

### Android
```bash
npm run android
```

### Start Metro Bundler
```bash
npm start
```

## Building Android APK (Without Android Studio)

To build an APK that you can install on your phone for testing:

1. **Set up build environment** (one-time setup):
   - Install Java JDK 17: https://adoptium.net/
   - Install Android SDK Command Line Tools (see `BUILD_ANDROID.md` for detailed instructions)
   - Set up Gradle wrapper: Run `.\setup-gradle-wrapper.ps1`

2. **Build the APK**:
   ```powershell
   .\build-android.ps1
   ```
   
   Or manually:
   ```powershell
   cd android
   .\gradlew.bat assembleDebug
   ```

3. **Find your APK**:
   - Location: `android/app/build/outputs/apk/debug/app-debug.apk`
   - Transfer to your phone and install

**Note**: The app will show helpful error messages if lock credentials are not configured, so you can test the UI even without real lock credentials.

For detailed build instructions, see [BUILD_ANDROID.md](./BUILD_ANDROID.md)

## Permissions

### iOS
The app requires the following permissions (already configured in `Info.plist`):
- Bluetooth Always Usage
- Location When In Use (required for BLE scanning)

### Android
The app requires the following permissions (already configured in `AndroidManifest.xml`):
- BLUETOOTH
- BLUETOOTH_ADMIN
- BLUETOOTH_SCAN
- BLUETOOTH_CONNECT
- ACCESS_FINE_LOCATION
- ACCESS_COARSE_LOCATION

## Project Structure

```
TTLockApp/
├── App.js                    # Main app component
├── config/
│   ├── lockConfig.js        # Lock configuration
│   └── services/
│       └── BLEService.js    # BLE service wrapper
├── android/                  # Android native project
├── ios/                      # iOS native project
└── package.json
```

## Dependencies

- `react-native`: 0.72.4
- `react-native-ttlock`: ^1.0.0

## Notes

- The app uses the `react-native-ttlock` SDK for BLE communication
- BLE scanning requires location permissions on both platforms
- Make sure Bluetooth is enabled on your device before using the app
