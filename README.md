# Eye Care App

A cross-platform eye care application built with Flutter that helps reduce eye strain through blink reminders, screen rest periods, and guided eye exercises.

## Features

- **Blink Reminders**: Periodic full-screen overlay reminders to blink
- **Blank Screen Mode**: Timed screen blanking for eye rest (20-20-20 rule)
- **Eye Training Exercises**: Guided exercises including Focus Shifting, Figure 8, and 20-20-20 rule
- **Background Mode**: Continues working when app is minimized (Android)
- **System Overlay**: Shows reminders on top of other apps (Android)
- **Text-to-Speech**: Voice guidance during exercises (Mobile)
- **Customizable Settings**: Presets and manual configuration

## Supported Platforms

| Platform | Status | Background Mode | Overlay Support |
|----------|--------|-----------------|-----------------|
| Android  | Full   | Yes             | Yes (requires permission) |
| iOS      | Full   | Limited         | No |
| Windows  | Partial| No              | No |
| macOS    | Partial| No              | No |
| Linux    | Partial| No              | No |

## Prerequisites

### All Platforms
- Flutter SDK 3.10.4 or higher
- Dart SDK 3.0 or higher

### Android
- Android SDK
- Android Studio or VS Code with Flutter extension
- Physical device or emulator (API 21+)

### iOS
- macOS with Xcode 14+
- iOS Simulator or physical device
- Apple Developer account (for device testing)

### Windows
- Visual Studio 2022 with "Desktop development with C++" workload
- NuGet CLI (for flutter_tts package)

### macOS
- Xcode 14+
- CocoaPods

### Linux
- Clang, CMake, GTK development libraries
- pkg-config

## Installation

### 1. Clone the Repository
```bash
git clone <repository-url>
cd eye_care_app
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Platform-Specific Setup

#### Android
No additional setup required. The app will request necessary permissions at runtime.

#### iOS
```bash
cd ios
pod install
cd ..
```

#### Windows
1. Install NuGet CLI:
   - Download from https://www.nuget.org/downloads
   - Add to system PATH

2. Install Visual Studio 2022 with C++ workload

#### macOS
```bash
cd macos
pod install
cd ..
```

#### Linux
```bash
sudo apt-get install clang cmake ninja-build pkg-config libgtk-3-dev
```

## Running the App

### Android (Recommended)
```bash
# Debug mode
flutter run -d android

# Release APK
flutter build apk --release

# Install APK
flutter install
```

### iOS
```bash
# Debug mode (simulator)
flutter run -d ios

# Release build
flutter build ios --release
```

### Windows
```bash
# Debug mode
flutter run -d windows

# Release build
flutter build windows --release
```

### macOS
```bash
# Debug mode
flutter run -d macos

# Release build
flutter build macos --release
```

### Linux
```bash
# Debug mode
flutter run -d linux

# Release build
flutter build linux --release
```

## Android Permissions

The app requires the following permissions on Android:

- **SYSTEM_ALERT_WINDOW**: Display overlay on top of other apps
- **POST_NOTIFICATIONS**: Show notification reminders
- **WAKE_LOCK**: Keep device awake during exercises
- **VIBRATE**: Haptic feedback for reminders
- **SCHEDULE_EXACT_ALARM**: Schedule precise reminders
- **FOREGROUND_SERVICE**: Background operation

### Granting Overlay Permission

1. Open the app
2. A dialog will prompt you to enable overlay permission
3. Tap "Enable Now"
4. In system settings, toggle "Allow display over other apps" for Eye Care

## Build Outputs

| Platform | Debug Location | Release Location |
|----------|----------------|------------------|
| Android  | `build/app/outputs/flutter-apk/app-debug.apk` | `build/app/outputs/flutter-apk/app-release.apk` |
| iOS      | Xcode build folder | `build/ios/iphoneos/` |
| Windows  | `build/windows/runner/Debug/` | `build/windows/runner/Release/` |
| macOS    | `build/macos/Build/Products/Debug/` | `build/macos/Build/Products/Release/` |
| Linux    | `build/linux/x64/debug/bundle/` | `build/linux/x64/release/bundle/` |

## Usage

### Quick Start
1. Launch the app
2. Grant overlay permission (Android)
3. Tap "Start Protection" on the home screen
4. The app will now show blink reminders periodically

### Settings
- **Presets**: Choose from Intense Focus, Normal, or Relaxed modes
- **Blink Reminder**: Enable/disable and set interval (5-60 seconds)
- **Blank Screen**: Enable/disable and set duration/interval
- **Voice Guide**: Enable/disable TTS during exercises
- **Background Mode**: Keep running when minimized (Android)

### Eye Training
1. Navigate to "Eye Training" from home screen
2. Select an exercise:
   - **20-20-20 Rule**: Look 20 feet away for 20 seconds every 20 minutes
   - **Focus Shifting**: Alternate focus between near and far objects
   - **Figure 8**: Trace a figure 8 pattern with your eyes
3. Follow the on-screen and voice guidance

## Troubleshooting

### Android: Overlay not showing
- Ensure overlay permission is granted in Settings > Apps > Eye Care > Display over other apps
- Check if battery optimization is disabled for the app

### Android: Reminders not working in background
- Disable battery optimization for Eye Care
- Ensure Background Mode is enabled in settings

### Windows: Build fails with NuGet error
- Install NuGet CLI from https://www.nuget.org/downloads
- Add NuGet.exe to system PATH
- Restart terminal/IDE

### General: App crashes on startup
- Run `flutter clean` and `flutter pub get`
- Ensure Flutter SDK is up to date: `flutter upgrade`

## Architecture

```
lib/
├── main.dart              # App entry point + overlay entry point
├── models/                # Data models
│   └── settings_model.dart
├── providers/             # State management
│   ├── settings_provider.dart
│   ├── eye_care_provider.dart
│   └── exercise_provider.dart
├── screens/               # UI screens
│   ├── home_screen.dart
│   ├── settings_screen.dart
│   └── training_screen.dart
├── services/              # Business logic
│   ├── background_service.dart
│   ├── notification_service.dart
│   ├── overlay_service.dart
│   ├── tts_service.dart
│   └── storage_service.dart
├── utils/                 # Utilities
│   ├── constants.dart
│   └── platform_utils.dart
└── widgets/               # Reusable widgets
    ├── blink_overlay.dart
    ├── blank_screen.dart
    └── preset_selector.dart
```

## License

This project is licensed under the MIT License.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
