# Deployment Guide for Rubik's Cube Solver

This guide covers deploying the app to both Apple App Store and Google Play Store.

## Prerequisites

### iOS (App Store)
- Apple Developer Account ($99/year)
- Xcode installed
- App Store Connect access
- Certificates and provisioning profiles set up

### Android (Play Store)
- Google Play Developer Account ($25 one-time)
- Java JDK installed
- Android Studio (optional, for signing)

## Build Commands

### iOS

1. **Build IPA for App Store:**
   ```bash
   flutter build ipa --release
   ```
   Output: `build/ios/ipa/rubiks_cube_solver.ipa`

2. **Build for TestFlight (optional):**
   ```bash
   flutter build ipa --release --export-options-plist=ios/ExportOptions.plist
   ```

### Android

1. **Build App Bundle (required for Play Store):**
   ```bash
   flutter build appbundle --release
   ```
   Output: `build/app/outputs/bundle/release/app-release.aab`

2. **Build APK (for testing):**
   ```bash
   flutter build apk --release
   ```
   Output: `build/app/outputs/flutter-apk/app-release.apk`

## Deployment Options

### Option 1: Manual Upload (Easiest)

#### iOS - App Store Connect
1. Open Xcode
2. Go to **Product > Archive**
3. Wait for archive to complete
4. Click **Distribute App**
5. Choose **App Store Connect**
6. Follow the wizard to upload
7. Go to [App Store Connect](https://appstoreconnect.apple.com)
8. Complete app information, screenshots, description
9. Submit for review

#### Android - Google Play Console
1. Go to [Google Play Console](https://play.google.com/console)
2. Create new app or select existing
3. Go to **Production** (or **Internal testing** / **Closed testing**)
4. Click **Create new release**
5. Upload the `.aab` file from `build/app/outputs/bundle/release/`
6. Fill in release notes
7. Review and roll out

### Option 2: CLI Upload (Automated)

#### iOS - Using `xcrun altool` (Deprecated) or `xcrun notarytool`
Apple has deprecated `altool`. Use App Store Connect API or Xcode GUI instead.

**Alternative: Use Fastlane (Recommended)**
```bash
# Install fastlane
sudo gem install fastlane

# Navigate to ios directory
cd ios

# Initialize fastlane (first time only)
fastlane init

# Upload to App Store Connect
fastlane deliver
```

#### Android - Using `bundletool` and Google Play API
```bash
# Install Google Play API Python client
pip install google-api-python-client google-auth-httplib2 google-auth-oauthlib

# Use Google Play Console API to upload
# See: https://developers.google.com/android-publisher
```

**Alternative: Use Fastlane (Recommended)**
```bash
# Install fastlane
sudo gem install fastlane

# Navigate to android directory
cd android

# Initialize fastlane (first time only)
fastlane init

# Upload to Play Store
fastlane supply
```

## Fastlane Setup (Recommended for Automation)

### iOS Fastlane Setup

1. **Install Fastlane:**
   ```bash
   sudo gem install fastlane
   ```

2. **Initialize in iOS directory:**
   ```bash
   cd ios
   fastlane init
   ```

3. **Configure Fastfile:**
   ```ruby
   # ios/fastlane/Fastfile
   default_platform(:ios)

   platform :ios do
     desc "Build and upload to App Store"
     lane :release do
       increment_build_number
       build_app(
         workspace: "Runner.xcworkspace",
         scheme: "Runner",
         export_method: "app-store"
       )
       upload_to_app_store(
         skip_metadata: false,
         skip_screenshots: false
       )
     end
   end
   ```

4. **Run:**
   ```bash
   fastlane release
   ```

### Android Fastlane Setup

1. **Install Fastlane:**
   ```bash
   sudo gem install fastlane
   ```

2. **Initialize in Android directory:**
   ```bash
   cd android
   fastlane init
   ```

3. **Configure Fastfile:**
   ```ruby
   # android/fastlane/Fastfile
   default_platform(:android)

   platform :android do
     desc "Build and upload to Play Store"
     lane :release do
       gradle(
         task: "bundle",
         build_type: "Release"
       )
       upload_to_play_store(
         track: "production",
         aab: "../build/app/outputs/bundle/release/app-release.aab"
       )
     end
   end
   ```

4. **Run:**
   ```bash
   fastlane release
   ```

## App Store Listing Requirements

### iOS App Store
- **App Name:** Up to 30 characters
- **Subtitle:** Up to 30 characters
- **Description:** Up to 4000 characters
- **Keywords:** Up to 100 characters
- **Screenshots:** Required for all device sizes
- **App Icon:** 1024x1024px (already generated)
- **Privacy Policy URL:** Required

### Google Play Store
- **App Name:** Up to 50 characters
- **Short Description:** Up to 80 characters
- **Full Description:** Up to 4000 characters
- **Screenshots:** At least 2, up to 8 per device type
- **App Icon:** 512x512px (will be generated from 1024x1024)
- **Feature Graphic:** 1024x500px (optional but recommended)
- **Privacy Policy URL:** Required

## Localized App Information

The app titles and descriptions are already localized in:
- **iOS:** `ios/Runner/*.lproj/InfoPlist.strings`
- **Android:** `android/app/src/main/res/values-*/strings.xml`

Make sure to add these translations in App Store Connect and Google Play Console for each locale.

## Signing

### iOS
- Automatic signing via Xcode (recommended)
- Or manual signing with certificates from Apple Developer portal

### Android
- Signing key is automatically generated on first build
- Located at: `android/app/key.jks` (if created)
- **IMPORTANT:** Backup your signing key! You'll need it for all future updates.

## Testing Before Release

1. **Test on real devices:**
   ```bash
   flutter run --release
   ```

2. **Test iOS on TestFlight:**
   - Upload to App Store Connect
   - Add internal testers
   - Test before public release

3. **Test Android on Internal Testing:**
   - Upload to Play Console
   - Add internal testers
   - Test before production release

## Version Management

Update version in `pubspec.yaml`:
```yaml
version: 1.0.0+1  # version+build_number
```

- **Version:** User-facing version (1.0.0)
- **Build Number:** Increment for each upload (+1)

## Checklist Before Deployment

### iOS
- [ ] App icon generated and set
- [ ] App name localized
- [ ] Version number updated
- [ ] Build number incremented
- [ ] Signing certificates configured
- [ ] Privacy policy URL added
- [ ] Screenshots prepared
- [ ] App Store listing information ready

### Android
- [ ] App icon generated and set
- [ ] App name localized
- [ ] Version number updated
- [ ] Version code incremented
- [ ] Signing key backed up
- [ ] Privacy policy URL added
- [ ] Screenshots prepared
- [ ] Play Store listing information ready

## Quick Start Commands

### Build for Release
```bash
# iOS
flutter build ipa --release

# Android
flutter build appbundle --release
```

### Upload (Manual)
- **iOS:** Use Xcode Archive and Distribute
- **Android:** Upload `.aab` file via Play Console

### Upload (Automated with Fastlane)
```bash
# iOS
cd ios && fastlane release

# Android
cd android && fastlane release
```

## Need Help?

- **iOS:** [Apple Developer Documentation](https://developer.apple.com/documentation/)
- **Android:** [Google Play Console Help](https://support.google.com/googleplay/android-developer)
- **Fastlane:** [Fastlane Documentation](https://docs.fastlane.tools/)

