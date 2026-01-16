# Build Instructions for Eye Care App

## Quick Build for Linux (Ubuntu)

### Step 1: Install Dependencies

Open a terminal and run:

```bash
sudo apt-get update
sudo apt-get install -y \
    libayatana-appindicator3-dev \
    libgtk-3-dev \
    clang \
    cmake \
    ninja-build \
    pkg-config \
    libblkid-dev \
    liblzma-dev
```

### Step 2: Use the Automated Build Script

```bash
cd /home/rajesh/CreatingEarning/Health/eye_care_app
./build-linux.sh
```

The script will:
- Check dependencies
- Get Flutter packages
- Build the Linux app
- Optionally create a tarball

### Step 3: Run the App

```bash
./build/linux/x64/release/bundle/eye_care_app
```

## Manual Build (Alternative)

If you prefer to build manually:

```bash
# Get dependencies
flutter pub get

# Build
flutter build linux --release

# Run
./build/linux/x64/release/bundle/eye_care_app
```

## Build for Other Platforms

### Android APK

```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

**Note**: See [android/SIGNING_GUIDE.md](android/SIGNING_GUIDE.md) for production signing.

### Android App Bundle (for Play Store)

```bash
flutter build appbundle --release
# Output: build/app/outputs/bundle/release/app-release.aab
```

### Web

```bash
flutter build web --release
# Output: build/web/

# Run locally
python -m http.server -d build/web 8080
# Visit: http://localhost:8080
```

### Windows (on Windows)

```bash
flutter build windows --release
# Output: build\windows\runner\Release\
```

### macOS (on macOS)

```bash
flutter build macos --release
# Output: build/macos/Build/Products/Release/eye_care_app.app
```

### iOS (on macOS)

```bash
flutter build ios --release --no-codesign
# Output: build/ios/iphoneos/
```

## Build Outputs Summary

| Platform | Command | Output Location |
|----------|---------|-----------------|
| Android APK | `flutter build apk --release` | `build/app/outputs/flutter-apk/app-release.apk` |
| Android AAB | `flutter build appbundle --release` | `build/app/outputs/bundle/release/app-release.aab` |
| Linux | `flutter build linux --release` | `build/linux/x64/release/bundle/` |
| Windows | `flutter build windows --release` | `build/windows/runner/Release/` |
| macOS | `flutter build macos --release` | `build/macos/Build/Products/Release/` |
| iOS | `flutter build ios --release` | `build/ios/iphoneos/` |
| Web | `flutter build web --release` | `build/web/` |

## Troubleshooting

### Linux Build Fails

**Error**: "The `tray_manager` package requires ayatana-appindicator3-0.1"

**Fix**: Install dependency:
```bash
sudo apt-get install -y libayatana-appindicator3-dev
```

### Deprecation Warnings

The app shows deprecation warnings for `.withOpacity()`. These don't prevent building and can be ignored for now.

To fix them (optional), replace in code:
```dart
// Old
Colors.blue.withOpacity(0.5)

// New
Colors.blue.withValues(alpha: 0.5)
```

### Android Build Needs Signing

For Play Store, you need to set up signing. See:
- [android/SIGNING_GUIDE.md](android/SIGNING_GUIDE.md)

### Tests Failing

Run tests:
```bash
flutter test
```

If tests fail, you can still build (tests are independent).

## Development Builds

For development/testing:

```bash
# Linux
flutter run -d linux

# Android (device/emulator)
flutter run -d android

# Web
flutter run -d chrome
```

## Clean Build

If you encounter issues:

```bash
flutter clean
flutter pub get
flutter build linux --release
```

## Create Distribution Packages

### Linux Tarball

```bash
cd build/linux/x64/release/bundle
tar -czf ~/eye-care-app-linux-v1.0.0.tar.gz *
```

### Linux DEB Package

See detailed instructions in [BUILD_LINUX.md](BUILD_LINUX.md)

### Android Release

Upload `app-release.aab` to Google Play Console.

## CI/CD Builds

GitHub Actions automatically builds for all platforms on release tags.

See: [.github/workflows/build.yml](.github/workflows/build.yml)

## Next Steps After Building

1. **Test the build** on your system
2. **Take screenshots** for documentation
3. **Create a release tag**:
   ```bash
   git tag -a v1.0.0 -m "Release version 1.0.0"
   git push origin v1.0.0
   ```
4. **GitHub Actions** will automatically build and create a release

## Documentation

- **Linux Build**: [BUILD_LINUX.md](BUILD_LINUX.md)
- **Android Signing**: [android/SIGNING_GUIDE.md](android/SIGNING_GUIDE.md)
- **Release Process**: [docs/RELEASE_PROCESS.md](docs/RELEASE_PROCESS.md)
- **Architecture**: [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md)

## Support

Need help building?
- Check [BUILD_LINUX.md](BUILD_LINUX.md) for detailed Linux instructions
- Open issue: https://github.com/RajeshKumar11/eye_care_app/issues
- Email: kakumanurajeshkumar@gmail.com

---

**Quick Reference**:
- Linux: `./build-linux.sh`
- Android: `flutter build apk --release`
- Web: `flutter build web --release`

**Last Updated**: 2026-01-16
