# Android App Signing Guide

## Overview

This guide explains how to sign your Eye Care App for release on Google Play Store.

## Current Status

⚠️ **WARNING**: The app is currently configured to use **debug signing** for release builds if no release keystore is configured. This is only suitable for testing, NOT for Play Store distribution.

## Why Proper Signing Matters

1. **Security**: Ensures app authenticity and prevents tampering
2. **Updates**: Apps must be signed with same key for updates
3. **Play Store Requirement**: Google Play requires properly signed apps
4. **Trust**: Users can verify app publisher

## Step-by-Step Signing Setup

### 1. Generate a Release Keystore

Run this command from the `android` directory:

```bash
keytool -genkey -v -keystore ~/upload-keystore.jks \
  -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 \
  -alias upload
```

You will be prompted for:
- **Keystore password** (choose a strong password)
- **Key password** (can be same as keystore password)
- **Your name, organization, city, state, country**

**IMPORTANT**:
- Keep this file and passwords SECURE
- NEVER commit the keystore to git
- NEVER share the keystore or passwords
- Back up the keystore to a secure location
- If you lose this, you cannot update your app!

### 2. Create key.properties File

Create a file named `key.properties` in the `android/` directory (NOT `android/app/`):

```properties
storePassword=YOUR_KEYSTORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=upload
storeFile=../upload-keystore.jks
```

**Or use absolute path**:
```properties
storePassword=YOUR_KEYSTORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=upload
storeFile=/home/rajesh/upload-keystore.jks
```

Replace:
- `YOUR_KEYSTORE_PASSWORD` with your keystore password
- `YOUR_KEY_PASSWORD` with your key password
- Adjust `storeFile` path to where you saved the keystore

### 3. Secure the key.properties File

The `key.properties` file is already in `.gitignore`, but verify:

```bash
# Check if key.properties is ignored
git check-ignore android/key.properties

# Should output: android/key.properties
```

If not ignored, add to `.gitignore`:
```
# Android signing
android/key.properties
*.jks
*.keystore
```

### 4. Build Release APK

Once configured, build your release APK:

```bash
# From project root
flutter build apk --release

# Or build App Bundle (recommended for Play Store)
flutter build appbundle --release
```

The signed outputs will be in:
- **APK**: `build/app/outputs/flutter-apk/app-release.apk`
- **AAB**: `build/app/outputs/bundle/release/app-release.aab`

### 5. Verify Signing

Verify your APK is properly signed:

```bash
# Check signing info
jarsigner -verify -verbose -certs build/app/outputs/flutter-apk/app-release.apk

# View certificate details
keytool -printcert -jarfile build/app/outputs/flutter-apk/app-release.apk
```

Should show:
- ✅ "jar verified"
- Certificate fingerprints (SHA1, SHA256)
- Valid certificate dates

## Google Play App Signing

### Option 1: Upload Key (Recommended)

Let Google manage your app signing key:

1. Generate upload key (as shown above)
2. Upload your AAB to Play Console
3. Google generates and manages the app signing key
4. You only need to keep the upload key

Benefits:
- Google manages security of final signing key
- Can reset upload key if compromised
- Industry best practice

### Option 2: App Signing Key

Use your own app signing key:

1. Generate signing key (keep VERY secure)
2. Sign APK/AAB with your key
3. Upload to Play Console

**WARNING**: If you lose this key, you can NEVER update your app!

## Key Management Best Practices

### Storage
- ✅ Store keystore in a secure, encrypted location
- ✅ Keep multiple backups (encrypted cloud storage, external drive)
- ✅ Use a password manager for passwords
- ❌ Never commit to version control
- ❌ Never share via email/chat
- ❌ Never store in project directory

### Passwords
- Use strong, unique passwords
- Store passwords in secure password manager
- Never write passwords in documentation
- Consider using environment variables in CI/CD

### Team Access
- Limit access to signing keys
- Use separate keys for different team members (if needed)
- Rotate keys if team member leaves
- Use Play Console's key management for team signing

## CI/CD Integration

For GitHub Actions or other CI/CD:

```yaml
# Example GitHub Actions workflow
- name: Decode keystore
  run: |
    echo "${{ secrets.KEYSTORE_BASE64 }}" | base64 --decode > android/app/upload-keystore.jks

- name: Create key.properties
  run: |
    echo "storePassword=${{ secrets.STORE_PASSWORD }}" > android/key.properties
    echo "keyPassword=${{ secrets.KEY_PASSWORD }}" >> android/key.properties
    echo "keyAlias=upload" >> android/key.properties
    echo "storeFile=../app/upload-keystore.jks" >> android/key.properties

- name: Build release
  run: flutter build appbundle --release
```

Store in GitHub Secrets:
- `KEYSTORE_BASE64`: Base64-encoded keystore file
- `STORE_PASSWORD`: Keystore password
- `KEY_PASSWORD`: Key password

## Troubleshooting

### Build fails: "keystore file not found"
- Check `storeFile` path in `key.properties`
- Use absolute path if relative path fails
- Verify keystore exists at specified location

### Build fails: "incorrect password"
- Verify passwords in `key.properties`
- Check for extra spaces or special characters
- Ensure passwords match what you set during keytool generation

### "key.properties not found" warning
- File must be in `android/` directory (not `android/app/`)
- Check file name is exactly `key.properties`
- Verify file is not ignored by .gitignore unintentionally

### Play Store rejects APK
- Use AAB format (preferred by Play Store)
- Ensure version code is incremented
- Check signing configuration is using release keystore
- Verify ProGuard rules don't break functionality

## Version Management

Update version in `pubspec.yaml`:

```yaml
version: 1.0.1+2
#        │    │
#        │    └── versionCode (must increment)
#        └─────── versionName (semantic version)
```

Rules:
- **versionCode** (number after `+`): Must increase for every release
- **versionName** (before `+`): Semantic versioning (1.0.0, 1.0.1, 1.1.0, etc.)

## Quick Reference

```bash
# Generate keystore
keytool -genkey -v -keystore ~/upload-keystore.jks -alias upload -keyalg RSA -keysize 2048 -validity 10000

# Build release APK
flutter build apk --release

# Build release AAB (for Play Store)
flutter build appbundle --release

# Verify signing
jarsigner -verify -verbose build/app/outputs/flutter-apk/app-release.apk

# View certificate
keytool -list -v -keystore ~/upload-keystore.jks -alias upload
```

## Additional Resources

- [Flutter App Signing](https://docs.flutter.dev/deployment/android#signing-the-app)
- [Android App Signing](https://developer.android.com/studio/publish/app-signing)
- [Play App Signing](https://support.google.com/googleplay/android-developer/answer/9842756)

---

**Remember**: Your keystore and passwords are critical. Treat them like your bank account credentials!
