# Google Play Store Upload Guide

## Prerequisites

1. **Google Play Developer Account**
   - Sign up at [Google Play Console](https://play.google.com/console)
   - One-time registration fee: $25 USD
   - Complete account verification

2. **App Information Ready**
   - App name, description, screenshots
   - Privacy policy URL (required)
   - App icon and feature graphic
   - Content rating information

## Step 1: Prepare Your App for Release

### 1.1 Update Version Information

Check your `pubspec.yaml`:
```yaml
version: 1.0.0+1
```
- Format: `versionName+versionCode`
- `1.0.0` = version name (user-visible)
- `1` = version code (must increment for each upload)

### 1.2 Configure Release Signing

✅ **Already Done:**
- Keystore created: `~/.keys/com.lt.rubiks.jks`
- Signing configured in `android/app/build.gradle.kts`
- `android/key.properties` file created

**Action Required:**
Update `android/key.properties` with your passwords:
```properties
storePassword=your_keystore_password
keyPassword=your_key_password
keyAlias=upload
storeFile=/Users/falcon/.keys/com.lt.rubiks.jks
```

### 1.3 Build Release App Bundle

```bash
flutter build appbundle --release
```

**Output location:**
```
build/app/outputs/bundle/release/app-release.aab
```

**Verify the build:**
- Check file size (should be reasonable, not too large)
- Note the file path for upload

## Step 2: Google Play Console Setup

### 2.1 Create New App

1. Go to [Google Play Console](https://play.google.com/console)
2. Click **"Create app"**
3. Fill in:
   - **App name**: Rubik Solver
   - **Default language**: English (United States)
   - **App or game**: App
   - **Free or paid**: Free
   - **Declarations**: Accept terms

### 2.2 Complete Store Listing

Navigate to **Store presence > Store listing**

**Required Information:**
- **App name**: Rubik Solver
- **Short description** (80 chars max): Step-by-step solver
- **Full description** (4000 chars max): Use content from `APP_STORE_LISTING.md`
- **App icon**: 512x512 PNG (no transparency)
- **Feature graphic**: 1024x500 PNG
- **Screenshots**: 
  - Phone: At least 2, up to 8 (16:9 or 9:16)
  - Tablet (optional): At least 2, up to 8
- **Privacy Policy URL**: Required (e.g., `https://yourdomain.com/privacy`)

**Graphics Requirements:**
- **App icon**: 512x512 px, 32-bit PNG, no transparency
- **Feature graphic**: 1024x500 px, 24-bit PNG or JPEG
- **Screenshots**: 
  - Minimum: 320px
  - Maximum: 3840px
  - Aspect ratio: 16:9 or 9:16
  - Format: PNG or JPEG (24-bit)

### 2.3 Content Rating

1. Go to **Policy > App content**
2. Complete the **Content rating questionnaire**
3. Answer questions about your app's content
4. Submit for rating (usually instant)

### 2.4 Privacy Policy

**Required for all apps**

1. Create a privacy policy page (can use `docs/PRIVACY.html` if you have one)
2. Host it online (GitHub Pages, your website, etc.)
3. Add the URL in **Policy > App content > Privacy policy**

**Your app doesn't collect data**, so your policy should state:
- No data collection
- No third-party sharing
- All processing is local

### 2.5 App Access (if applicable)

If your app requires special permissions or access:
- Declare sensitive permissions
- Complete data safety section
- For your app: Likely minimal (no network, no data collection)

## Step 3: Upload Your App

### 3.1 Create Production Release

1. Go to **Production** (or **Testing** for initial testing)
2. Click **"Create new release"**
3. Upload your AAB file:
   - Drag and drop `app-release.aab`
   - Or click "Browse files"

### 3.2 Release Notes

Add release notes for this version:
```
Initial release
- Step-by-step Rubik's cube solutions
- 2D and 3D cube visualization
- Manual cube input
- Multi-language support
```

### 3.3 Review and Rollout

1. Review all information
2. Click **"Save"** (saves as draft)
3. Click **"Review release"**
4. Review checklist:
   - ✅ Store listing complete
   - ✅ Content rating done
   - ✅ Privacy policy added
   - ✅ App bundle uploaded
5. Click **"Start rollout to Production"**

## Step 4: Review Process

### 4.1 Google Review

- **Timeline**: Usually 1-3 business days
- **Status**: Check in Play Console under "Review status"
- **Common issues**:
  - Missing privacy policy
  - Content rating incomplete
  - App crashes or policy violations

### 4.2 Monitor Status

Check **Dashboard** for:
- Review status
- Any policy violations
- User feedback (after launch)

## Step 5: App Goes Live

Once approved:
- App appears in Play Store
- Available for download
- You can track downloads, ratings, etc.

## Testing Before Production

### Internal Testing (Recommended)

1. Create **Internal testing track**
2. Upload AAB to internal testing
3. Add testers (up to 100)
4. Test the app thoroughly
5. Then promote to Production

### Closed/Open Testing

- **Closed testing**: Limited testers
- **Open testing**: Public beta
- Good for gathering feedback before production

## Important Notes

### Version Code Increment

**Every upload must have a higher version code:**
- First release: `1.0.0+1`
- Update: `1.0.1+2` (increment the number after `+`)
- Update: `1.0.2+3`, etc.

Update in `pubspec.yaml`:
```yaml
version: 1.0.1+2  # Increment both
```

### Keystore Security

⚠️ **CRITICAL**: Keep your keystore safe!
- Backup `~/.keys/com.lt.rubiks.jks` securely
- Save passwords in a password manager
- **If you lose the keystore, you cannot update your app!**
- Google Play requires the same keystore for all updates

### App Bundle vs APK

- **Use AAB (App Bundle)**: Required for new apps
- **APK**: Only for updates to very old apps
- AAB is smaller and optimized by Google

## Checklist Before Upload

- [ ] Version code incremented in `pubspec.yaml`
- [ ] Passwords set in `android/key.properties`
- [ ] Release AAB built successfully
- [ ] Store listing complete (name, description, graphics)
- [ ] Privacy policy URL added and accessible
- [ ] Content rating completed
- [ ] Screenshots prepared (at least 2 phone screenshots)
- [ ] App icon (512x512) ready
- [ ] Feature graphic (1024x500) ready
- [ ] Tested app on real device
- [ ] Keystore backed up securely

## Quick Reference Commands

```bash
# Build release app bundle
flutter build appbundle --release

# Check build output
ls -lh build/app/outputs/bundle/release/

# Verify keystore (requires password)
keytool -list -v -keystore ~/.keys/com.lt.rubiks.jks

# Clean and rebuild
flutter clean
flutter pub get
flutter build appbundle --release
```

## Troubleshooting

### Build Errors

**"Keystore file not found"**
- Check path in `key.properties`
- Verify keystore exists: `ls ~/.keys/com.lt.rubiks.jks`

**"Wrong password"**
- Verify passwords in `key.properties`
- Test with: `keytool -list -keystore ~/.keys/com.lt.rubiks.jks`

**"Signing config not found"**
- Check `build.gradle.kts` has signing config
- Verify `key.properties` file exists

### Upload Errors

**"Version code already used"**
- Increment version code in `pubspec.yaml`
- Rebuild and upload

**"Missing privacy policy"**
- Add privacy policy URL in Play Console
- Ensure URL is accessible

## Resources

- [Google Play Console](https://play.google.com/console)
- [Flutter App Release Guide](https://docs.flutter.dev/deployment/android)
- [Google Play Policy](https://play.google.com/about/developer-content-policy/)
- [App Bundle Format](https://developer.android.com/guide/app-bundle)

---

**App Details:**
- **Package Name**: `com.lt.rubiks`
- **Keystore**: `~/.keys/com.lt.rubiks.jks`
- **Key Alias**: `upload`

