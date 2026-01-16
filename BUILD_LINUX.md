# Building Eye Care App for Linux (Ubuntu)

## Prerequisites Installation

The build failed because of missing dependencies. Run these commands to install them:

### Step 1: Install Required Dependencies

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

### Step 2: Clean Previous Build (Optional)

```bash
cd /home/rajesh/CreatingEarning/Health/eye_care_app
flutter clean
```

### Step 3: Get Dependencies

```bash
flutter pub get
```

### Step 4: Build Linux Release

```bash
flutter build linux --release
```

## Build Output Location

After successful build, the executable will be at:
```
build/linux/x64/release/bundle/eye_care_app
```

## Running the App

### Run Directly
```bash
./build/linux/x64/release/bundle/eye_care_app
```

### Create Desktop Entry (Optional)

Create a `.desktop` file for application launcher:

```bash
cat > ~/.local/share/applications/eye-care-app.desktop <<EOF
[Desktop Entry]
Name=Eye Care App
Comment=Protect Your Vision from Digital Eye Strain
Exec=/home/rajesh/CreatingEarning/Health/eye_care_app/build/linux/x64/release/bundle/eye_care_app
Icon=/home/rajesh/CreatingEarning/Health/eye_care_app/assets/icons/app_icon.png
Terminal=false
Type=Application
Categories=Utility;Health;
Keywords=eye;care;health;blink;reminder;
EOF
```

Update desktop database:
```bash
update-desktop-database ~/.local/share/applications/
```

## Create Distributable Package

### Method 1: Create Tarball

```bash
cd build/linux/x64/release/bundle
tar -czf ~/eye-care-app-linux-x64-v1.0.0.tar.gz *
```

Users can extract and run:
```bash
tar -xzf eye-care-app-linux-x64-v1.0.0.tar.gz
cd eye-care-app
./eye_care_app
```

### Method 2: Create AppImage (Advanced)

Install AppImage tools:
```bash
sudo apt-get install -y appimagetool
```

Create AppImage structure:
```bash
mkdir -p AppDir/usr/bin
mkdir -p AppDir/usr/share/applications
mkdir -p AppDir/usr/share/icons

# Copy executable
cp build/linux/x64/release/bundle/* AppDir/usr/bin/

# Create desktop file
cat > AppDir/usr/share/applications/eye-care-app.desktop <<EOF
[Desktop Entry]
Name=Eye Care App
Exec=eye_care_app
Icon=eye-care-app
Type=Application
Categories=Utility;Health;
EOF

# Copy icon (if you have one)
# cp assets/icons/app_icon.png AppDir/usr/share/icons/eye-care-app.png

# Create AppImage
appimagetool AppDir eye-care-app-x86_64.AppImage
```

### Method 3: Create DEB Package (Advanced)

Install build tools:
```bash
sudo apt-get install -y dpkg-dev debhelper
```

Create package structure:
```bash
mkdir -p eye-care-app_1.0.0_amd64/DEBIAN
mkdir -p eye-care-app_1.0.0_amd64/usr/bin
mkdir -p eye-care-app_1.0.0_amd64/usr/share/applications
mkdir -p eye-care-app_1.0.0_amd64/usr/share/doc/eye-care-app

# Create control file
cat > eye-care-app_1.0.0_amd64/DEBIAN/control <<EOF
Package: eye-care-app
Version: 1.0.0
Section: utils
Priority: optional
Architecture: amd64
Depends: libgtk-3-0, libayatana-appindicator3-1
Maintainer: Rajesh Kumar <kakumanurajeshkumar@gmail.com>
Description: Eye Care App - Protect Your Vision
 A cross-platform eye care application that helps reduce digital eye strain
 through blink reminders, screen rest periods, and guided eye exercises.
EOF

# Copy files
cp -r build/linux/x64/release/bundle/* eye-care-app_1.0.0_amd64/usr/bin/

# Create desktop file
cat > eye-care-app_1.0.0_amd64/usr/share/applications/eye-care-app.desktop <<EOF
[Desktop Entry]
Name=Eye Care App
Comment=Protect Your Vision from Digital Eye Strain
Exec=/usr/bin/eye_care_app
Icon=eye-care-app
Terminal=false
Type=Application
Categories=Utility;Health;
Keywords=eye;care;health;blink;reminder;
EOF

# Build package
dpkg-deb --build eye-care-app_1.0.0_amd64
```

Install package:
```bash
sudo dpkg -i eye-care-app_1.0.0_amd64.deb
```

## Troubleshooting

### Build Fails with CMake Error

**Error**: "The `tray_manager` package requires ayatana-appindicator3-0.1"

**Solution**: Install dependencies:
```bash
sudo apt-get install -y libayatana-appindicator3-dev
```

### Build Fails with GTK Error

**Error**: "Package gtk+-3.0 was not found"

**Solution**: Install GTK development files:
```bash
sudo apt-get install -y libgtk-3-dev
```

### App Doesn't Start

**Error**: "error while loading shared libraries"

**Solution**: Install runtime dependencies:
```bash
sudo apt-get install -y \
    libgtk-3-0 \
    libayatana-appindicator3-1 \
    libnotify4
```

### Deprecation Warnings During Build

The app uses some deprecated Flutter APIs (`.withOpacity()`). These are warnings only and don't prevent the build. To fix them:

1. Open the file mentioned in the warning
2. Replace `.withOpacity(value)` with `.withValues(alpha: value)`

Example:
```dart
// Old (deprecated)
color: Colors.blue.withOpacity(0.5)

// New
color: Colors.blue.withValues(alpha: 0.5)
```

## Testing the Build

### Run in Debug Mode First
```bash
flutter run -d linux
```

### Check for Runtime Errors
```bash
./build/linux/x64/release/bundle/eye_care_app 2>&1 | tee app.log
```

### Verify File Size
```bash
du -h build/linux/x64/release/bundle/
```

Expected size: 30-50 MB

## Distribution Checklist

Before distributing the Linux build:

- [ ] Test on clean Ubuntu system
- [ ] Verify all dependencies are documented
- [ ] Test system tray functionality
- [ ] Test notifications
- [ ] Create installation instructions
- [ ] Package as tarball or AppImage
- [ ] Upload to GitHub Releases

## System Requirements

### Minimum Requirements
- Ubuntu 20.04 LTS or newer (or equivalent)
- GTK 3.0+
- 2GB RAM
- 100MB disk space

### Recommended
- Ubuntu 22.04 LTS or newer
- 4GB RAM
- GNOME or KDE desktop environment

## Known Limitations on Linux

1. **No System Overlay**: Unlike Android, Linux doesn't support full-screen overlays on top of all apps
2. **Limited Background Service**: App must remain open for reminders to work
3. **No TTS by Default**: Text-to-speech requires additional setup
4. **Tray Icon**: May not work on all desktop environments

## Alternative: Run as Web App

If Linux build is problematic, you can run the web version:

```bash
flutter run -d chrome
# or
flutter build web --release
python -m http.server -d build/web 8080
```

## Next Steps After Building

1. **Test thoroughly** on your system
2. **Create screenshots** for documentation
3. **Upload to GitHub Releases**
4. **Update README** with Linux installation instructions
5. **Consider Snap/Flatpak** for easier distribution

## Support

If you encounter issues:
- Check Flutter Linux documentation: https://docs.flutter.dev/get-started/install/linux
- Open issue: https://github.com/RajeshKumar11/eye_care_app/issues
- Email: kakumanurajeshkumar@gmail.com

---

**Last Updated**: 2026-01-16
