# Screenshots Guide

## Required Screenshots for README

### Priority Screenshots (Minimum 4)

1. **Home Screen**
   - Show main interface with "Start Protection" button
   - Display current preset selection
   - Show status indicators
   - Filename: `home_screen.png`

2. **Blink Reminder Overlay**
   - Capture full-screen blink reminder in action
   - Show "Blink Your Eyes" message
   - Demonstrate overlay transparency
   - Filename: `blink_overlay.png`

3. **Settings Screen**
   - Show all customization options
   - Display preset selector
   - Show interval controls
   - Filename: `settings_screen.png`

4. **Eye Training Exercises**
   - Capture exercise in progress
   - Show timer/progress
   - Display instructions
   - Filename: `exercise_screen.png`

### Additional Screenshots (Nice to Have)

5. **Blank Screen Mode**
   - Show 20-20-20 rule screen break
   - Display countdown timer
   - Filename: `blank_screen.png`

6. **Permission Request**
   - Android overlay permission dialog
   - Filename: `permission_dialog.png`

7. **Notification**
   - Foreground service notification
   - Filename: `notification.png`

8. **Multiple Devices**
   - Show app on phone and tablet
   - Cross-platform demonstration
   - Filename: `multi_device.png`

## Screenshot Specifications

### Dimensions
- **Phone**: 1080x2400px (portrait)
- **Tablet**: 1200x1920px (portrait)
- **Desktop**: 1920x1080px (landscape)

### Format
- PNG format (best quality)
- JPG acceptable for photo-realistic shots
- Maximum 1MB per image (optimize if needed)

### Quality Guidelines
- High resolution (2x or 3x density)
- Clean UI (no debug overlays)
- Real content (avoid lorem ipsum)
- Proper lighting/visibility
- Consistent styling across screenshots

## How to Capture Screenshots

### Android
```bash
# Using ADB
adb shell screencap -p /sdcard/screenshot.png
adb pull /sdcard/screenshot.png

# Or press: Power + Volume Down
```

### iOS Simulator
```bash
# Using xcrun
xcrun simctl io booted screenshot screenshot.png

# Or: Cmd + S in simulator
```

### Physical iOS Device
- Press: Side Button + Volume Up

### Windows
```bash
# Using Flutter DevTools
flutter screenshot

# Or: Windows + Shift + S
```

### Linux/macOS Desktop
```bash
flutter screenshot

# Or use native screenshot tools
```

## Screenshot Processing

### Recommended Tools
1. **ImageMagick** - Command-line batch processing
2. **TinyPNG** - Compression
3. **Figma/Photoshop** - Adding device frames
4. **Shotty/Previewed** - Device mockup generators

### Add Device Frames (Optional)
Makes screenshots more appealing:
- https://mockuphone.com/
- https://previewed.app/
- https://deviceframes.com/

### Optimize File Size
```bash
# Using ImageMagick
convert input.png -quality 85 output.png

# Using pngquant
pngquant --quality=65-80 input.png
```

## Directory Structure

Create the following structure:
```
docs/
└── screenshots/
    ├── mobile/
    │   ├── home_screen.png
    │   ├── blink_overlay.png
    │   ├── settings_screen.png
    │   └── exercise_screen.png
    ├── tablet/
    │   └── (tablet-specific screenshots)
    ├── desktop/
    │   └── (desktop screenshots)
    └── demo/
        ├── app_demo.gif (animated demo)
        └── feature_showcase.mp4
```

## Creating Animated GIFs

### Recording Screen
```bash
# Android
adb shell screenrecord /sdcard/demo.mp4
adb pull /sdcard/demo.mp4

# iOS Simulator
xcrun simctl io booted recordVideo demo.mov
```

### Converting to GIF
```bash
# Using ffmpeg
ffmpeg -i demo.mp4 -vf "fps=10,scale=320:-1:flags=lanczos" demo.gif

# Optimize GIF size
gifsicle -O3 --colors 256 demo.gif -o demo_optimized.gif
```

### Online GIF Makers
- https://ezgif.com/
- https://gifski.app/
- https://www.screentogif.com/

## README Integration

Update README.md with:
```markdown
## Screenshots

<div align="center">
  <img src="docs/screenshots/mobile/home_screen.png" width="200" alt="Home Screen"/>
  <img src="docs/screenshots/mobile/blink_overlay.png" width="200" alt="Blink Reminder"/>
  <img src="docs/screenshots/mobile/settings_screen.png" width="200" alt="Settings"/>
  <img src="docs/screenshots/mobile/exercise_screen.png" width="200" alt="Exercises"/>
</div>

## Demo

<div align="center">
  <img src="docs/screenshots/demo/app_demo.gif" width="300" alt="App Demo"/>
</div>
```

## Placeholder Screenshots (Temporary)

Until real screenshots are available:
1. Create wireframes/mockups using Figma
2. Use Flutter Golden Tests to generate UI snapshots
3. Add "Coming Soon" placeholder images

## Current Status

**Status**: ❌ No screenshots available
**Priority**: 🔴 HIGH - Critical for README appeal

**Action Items**:
- [ ] Capture 4 primary screenshots
- [ ] Optimize images (<500KB each)
- [ ] Create demo GIF
- [ ] Add device frames (optional)
- [ ] Update README with images
- [ ] Add alt text for accessibility

## Tips for Great Screenshots

1. **Clean UI**: Remove debug banners, status bars (if appropriate)
2. **Realistic Content**: Use actual features, not placeholders
3. **Show Key Features**: Highlight what makes the app unique
4. **Consistent Branding**: Use same theme/colors across shots
5. **Action Shots**: Show app in use, not just static screens
6. **Context**: Include just enough to understand the feature
7. **Accessibility**: Always include alt text descriptions

---

**Note**: Screenshots significantly increase GitHub star rate and user engagement. Professional screenshots are essential for public repository success.
