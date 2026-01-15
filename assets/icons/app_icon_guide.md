# App Icon Guide

## Icon Requirements by Platform

### Android
- **Launcher Icon**:
  - 192x192px (xxxhdpi)
  - 144x144px (xxhdpi)
  - 96x96px (xhdpi)
  - 72x72px (hdpi)
  - 48x48px (mdpi)
- **Adaptive Icon** (Android 8.0+):
  - Foreground: 432x432px
  - Background: 432x432px
- **Notification Icon**: 24x24dp (white on transparent)
- **Store Listing**: 512x512px

### iOS
- **App Icon**:
  - 1024x1024px (App Store)
  - 180x180px (iPhone @3x)
  - 120x120px (iPhone @2x)
  - 167x167px (iPad Pro @2x)
  - 152x152px (iPad @2x)
  - 76x76px (iPad @1x)
- **Notification Icon**: System uses app icon

### Windows
- **App Icon**: 256x256px (PNG with transparency)
- **Store Icon**: 300x300px

### macOS
- **App Icon**: 1024x1024px (PNG)
- **Menu Bar Icon**: 16x16px, 32x32px (template images)

### Linux
- **App Icon**: 512x512px (PNG)
- **Desktop Entry Icon**: 256x256px

### Web
- **Favicon**:
  - 32x32px, 16x16px (ICO or PNG)
  - 192x192px (Android Chrome)
  - 512x512px (maskable icon)
- **Apple Touch Icon**: 180x180px

## Design Guidelines

### Eye Care App Icon Concept
The icon should represent:
- **Eye health/vision** - Use eye symbol
- **Protection/care** - Shield or heart element
- **Digital wellness** - Screen or monitor element
- **Reminder/timer** - Clock or notification element

### Recommended Color Scheme
- **Primary**: Blue (#2196F3) - Trust, health, technology
- **Secondary**: Green (#4CAF50) - Wellness, health
- **Accent**: White/Light blue - Clean, medical

### Icon Style
- Modern flat design
- High contrast for visibility
- Simple and recognizable at small sizes
- No text (text doesn't scale well)

## How to Generate Icons

### Option 1: Online Icon Generator (Recommended)
1. Create a single 1024x1024px master icon
2. Use tools like:
   - https://appicon.co/
   - https://icon.kitchen/
   - https://makeappicon.com/

### Option 2: Flutter Package
```bash
# Install flutter_launcher_icons package
flutter pub add --dev flutter_launcher_icons

# Configure in pubspec.yaml
flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/icons/app_icon_1024.png"

# Generate icons
flutter pub run flutter_launcher_icons
```

### Option 3: Manual Creation
Use design tools:
- Adobe Illustrator / Photoshop
- Figma
- Sketch
- Inkscape (free)
- GIMP (free)

## Current Status

**Status**: Placeholder icons needed
**Priority**: HIGH - Required for public release

**TODO**:
1. Design master 1024x1024px icon
2. Generate platform-specific icons
3. Add icons to respective directories
4. Update platform configurations
5. Test on all platforms

## Placeholder Solution (Temporary)

Until custom icons are created, you can use:
- Flutter's default icon (current)
- Generic eye icon from open source libraries
- Placeholder from icon generators

**Note**: Custom branded icons are essential for professional app store presence.
