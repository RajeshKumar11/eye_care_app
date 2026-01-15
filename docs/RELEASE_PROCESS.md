# Release Process

This document describes the release process for Eye Care App.

## Version Numbering

We follow [Semantic Versioning](https://semver.org/): `MAJOR.MINOR.PATCH+BUILD`

Example: `1.2.3+45`
- `1` = Major version (breaking changes)
- `2` = Minor version (new features, backwards compatible)
- `3` = Patch version (bug fixes)
- `45` = Build number (must increment for each release)

## Pre-Release Checklist

- [ ] All tests pass (`flutter test`)
- [ ] Code is formatted (`dart format .`)
- [ ] No analyzer warnings (`flutter analyze`)
- [ ] CHANGELOG.md is updated
- [ ] Version bumped in pubspec.yaml
- [ ] Screenshots are up to date
- [ ] Documentation is current
- [ ] Android signing is configured
- [ ] All PRs are merged
- [ ] No blocking issues

## Release Steps

### 1. Prepare Release

```bash
# Update version in pubspec.yaml
version: 1.1.0+2  # Increment appropriately

# Update CHANGELOG.md
## [1.1.0] - 2026-01-20
### Added
- New feature X
### Fixed
- Bug Y

# Commit changes
git add pubspec.yaml CHANGELOG.md
git commit -m "chore: prepare release v1.1.0"
git push origin main
```

### 2. Create Release Tag

```bash
# Create annotated tag
git tag -a v1.1.0 -m "Release version 1.1.0"

# Push tag to trigger release workflow
git push origin v1.1.0
```

### 3. GitHub Actions Automation

The `release.yml` workflow automatically:
- Creates GitHub release
- Builds Android APK
- Builds Windows ZIP
- Builds Linux tarball
- Uploads artifacts to release

### 4. Manual Platform Releases

#### Android (Google Play)
```bash
# Build App Bundle
flutter build appbundle --release

# Upload to Play Console
# Located at: build/app/outputs/bundle/release/app-release.aab
```

#### iOS (App Store)
```bash
# Build for iOS
flutter build ios --release

# Open in Xcode for archiving
open ios/Runner.xcworkspace

# Archive and upload via Xcode
```

#### Desktop Platforms
Artifacts are automatically built by GitHub Actions.

### 5. Verify Release

- [ ] Check GitHub release page
- [ ] Download and test APK
- [ ] Verify changelog in release notes
- [ ] Test on multiple platforms
- [ ] Check version numbers

### 6. Post-Release

- [ ] Announce in Discussions
- [ ] Update README badges if needed
- [ ] Close related issues
- [ ] Plan next release

## Hotfix Process

For critical bugs:

```bash
# Create hotfix branch
git checkout -b hotfix/v1.0.1 v1.0.0

# Fix the bug
# ...

# Update version (patch only)
# pubspec.yaml: 1.0.1+2

# Commit and tag
git commit -m "fix: critical bug"
git tag -a v1.0.1 -m "Hotfix release 1.0.1"

# Push
git push origin hotfix/v1.0.1
git push origin v1.0.1

# Merge back to main
git checkout main
git merge hotfix/v1.0.1
git push origin main
```

## Release Channels

### Stable
- Main releases
- Thoroughly tested
- Recommended for all users

### Beta (Future)
- Pre-release testing
- May contain bugs
- For early adopters

### Dev (Future)
- Cutting edge
- Frequent updates
- For developers

## Platform-Specific Notes

### Android
- Requires signing configuration
- See `android/SIGNING_GUIDE.md`
- Play Store review: 1-3 days

### iOS
- Requires Apple Developer account
- TestFlight for beta testing
- App Store review: 1-3 days

### Windows
- No signing required for sideload
- Consider code signing for trust

### Linux
- Distribute via GitHub releases
- Consider Snap/Flatpak (future)

### macOS
- Code signing recommended
- Notarization for Gatekeeper

## Versioning Examples

### Major Release (Breaking Changes)
```
1.5.2 → 2.0.0
```
- API changes
- Major feature rewrites
- Incompatible changes

### Minor Release (New Features)
```
1.5.2 → 1.6.0
```
- New features
- Enhancements
- Backwards compatible

### Patch Release (Bug Fixes)
```
1.5.2 → 1.5.3
```
- Bug fixes only
- Security patches
- Minor improvements

## Rollback Procedure

If a release has critical issues:

1. **Stop distribution** (if possible)
2. **Create hotfix** (see above)
3. **Notify users** via GitHub
4. **Release fixed version** ASAP

## Automation

### GitHub Actions Workflows

- **test.yml**: Runs on every push/PR
- **build.yml**: Builds all platforms
- **release.yml**: Creates releases on tags
- **pr-checks.yml**: Validates PRs

### Secrets Configuration

Required GitHub Secrets:
- `CODECOV_TOKEN`: Code coverage reporting
- `KEYSTORE_BASE64`: Android signing (optional)
- `STORE_PASSWORD`: Android signing (optional)
- `KEY_PASSWORD`: Android signing (optional)

## Release Checklist Template

Copy this for each release:

```markdown
## Release v1.X.X Checklist

### Pre-Release
- [ ] All tests passing
- [ ] Code formatted and analyzed
- [ ] CHANGELOG.md updated
- [ ] Version bumped
- [ ] Docs updated

### Release
- [ ] Tag created and pushed
- [ ] GitHub release created
- [ ] Artifacts uploaded
- [ ] Android APK tested
- [ ] iOS build successful

### Post-Release
- [ ] Announcement posted
- [ ] Issues closed
- [ ] Next milestone planned
```

## Contact

Questions about releases? Contact:
- Email: kakumanurajeshkumar@gmail.com
- GitHub: @RajeshKumar11

---

**Last Updated**: 2026-01-16
