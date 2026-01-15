# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Planned
- iOS background service improvements
- Desktop platform full support
- Statistics dashboard for eye care habits
- Dark mode theme
- Multiple language support
- Custom exercise routines
- Integration with health tracking apps

## [1.0.0] - 2026-01-16

### Added
- Initial release of Eye Care App
- Blink reminder functionality with full-screen overlay
- Blank screen mode for mandatory screen breaks
- Eye training exercises:
  - 20-20-20 rule guided exercise
  - Focus shifting exercise
  - Figure 8 eye movement exercise
- Customizable settings with three presets:
  - Intense Focus (frequent reminders)
  - Normal (balanced reminders)
  - Relaxed (gentle reminders)
- Text-to-speech voice guidance for exercises
- Background service for Android (continues when minimized)
- System overlay support for Android (shows on top of other apps)
- Notification support with customizable intervals
- Persistent settings storage
- Cross-platform support:
  - Full support for Android
  - Full support for iOS
  - Partial support for Windows, macOS, and Linux

### Android Specific
- Overlay permission request and management
- Foreground service for background operation
- Battery optimization handling
- Notification channel setup
- Exact alarm scheduling

### iOS Specific
- Background task handling
- Voice guidance with AVFoundation
- Local notifications

### Security
- Minimal permissions requested
- No data collection or analytics
- All data stored locally on device
- No network requests or external dependencies

## Version History

### Version Numbering
- **Major version** (X.0.0): Breaking changes or major feature additions
- **Minor version** (0.X.0): New features, backwards compatible
- **Patch version** (0.0.X): Bug fixes and minor improvements

---

## How to Contribute to Changelog

When submitting a pull request, please update the [Unreleased] section with your changes under the appropriate category:

### Categories
- **Added**: New features
- **Changed**: Changes in existing functionality
- **Deprecated**: Soon-to-be removed features
- **Removed**: Removed features
- **Fixed**: Bug fixes
- **Security**: Security improvements or fixes

### Example Entry Format
```markdown
### Added
- New feature description [#issue-number]

### Fixed
- Bug fix description [#issue-number]
```

---

[Unreleased]: https://github.com/RajeshKumar11/eye_care_app/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/RajeshKumar11/eye_care_app/releases/tag/v1.0.0
