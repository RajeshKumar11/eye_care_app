# 👁️ Eye Care App

<div align="center">

[![Flutter](https://img.shields.io/badge/Flutter-3.10.4+-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)

A cross-platform eye care application built with Flutter that helps reduce eye strain through blink reminders, screen rest periods, and guided eye exercises.

[Features](#features) • [Installation](#installation) • [Usage](#usage) • [Contributing](#contributing) • [License](#license)

</div>

---

## 🌟 Why Eye Care App?

In our digital age, we spend countless hours staring at screens, leading to:
- **Digital Eye Strain**: Headaches, blurred vision, dry eyes
- **Reduced Blink Rate**: From 15-20 blinks/min to just 5-7 blinks/min
- **Long-term Vision Problems**: Increased risk of myopia and other conditions

### 🎯 Who Is This For?

**Primary Audience:**
- 👨‍💻 **Software Engineers & Developers** - Spending 8-12 hours daily coding
- 👩‍💼 **Tech Professionals** - Working on computers all day
- 🎮 **Gamers** - Long gaming sessions affecting eye health
- 📱 **Heavy Mobile Users** - Constant phone/tablet usage
- 🎓 **Students** - Extended study hours on devices
- 🏢 **Remote Workers** - Home office setups with extended screen time

**Eye Care App** is your personal eye health companion, reminding you to:
- 👁️ Blink regularly to prevent dry eyes
- 🛑 Take screen breaks following the 20-20-20 rule
- 🏃 Practice eye exercises to reduce strain
- 🧘 Maintain healthy vision habits during intense work sessions

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

## 🤝 Contributing

We love contributions! Whether it's bug reports, feature requests, or code contributions, all are welcome!

Please read our [Contributing Guidelines](CONTRIBUTING.md) and [Code of Conduct](CODE_OF_CONDUCT.md) before getting started.

### Quick Contribution Steps

1. 🍴 Fork the repository
2. 🔧 Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. ✅ Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. 📤 Push to the branch (`git push origin feature/AmazingFeature`)
5. 🎉 Open a Pull Request

## 🐛 Found a Bug?

If you find a bug, please [create an issue](https://github.com/RajeshKumar11/eye_care_app/issues/new?template=bug_report.md) with:
- Clear description of the bug
- Steps to reproduce
- Expected vs actual behavior
- Screenshots (if applicable)
- Platform and version information

## 💡 Feature Requests

Have an idea? [Open a feature request](https://github.com/RajeshKumar11/eye_care_app/issues/new?template=feature_request.md)!

## 🙏 Acknowledgments

- Thanks to all contributors who have helped improve this project
- Inspired by the 20-20-20 rule recommended by optometrists worldwide
- Built with ❤️ using Flutter

## 📞 Support & Community

- **Issues**: [GitHub Issues](https://github.com/RajeshKumar11/eye_care_app/issues)
- **Discussions**: [GitHub Discussions](https://github.com/RajeshKumar11/eye_care_app/discussions)
- **Email**: kakumanurajeshkumar@gmail.com

## ⭐ Show Your Support

If this project helped you, please consider giving it a ⭐ on GitHub! It helps others discover the project.

## 📈 Project Stats

![GitHub stars](https://img.shields.io/github/stars/RajeshKumar11/eye_care_app?style=social)
![GitHub forks](https://img.shields.io/github/forks/RajeshKumar11/eye_care_app?style=social)
![GitHub watchers](https://img.shields.io/github/watchers/RajeshKumar11/eye_care_app?style=social)

## 📝 Changelog

See [CHANGELOG.md](CHANGELOG.md) for a history of changes to this project.

## 🔐 Security

For security issues, please see our [Security Policy](SECURITY.md).
