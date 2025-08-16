
# WhatsOrder Android App - Capacitor Setup

![Build Status](https://github.com/your-username/whatsorder/workflows/Build%20Android%20APK/badge.svg)

## 🚀 Complete Setup Instructions

### 1. Install Dependencies
```bash
npm install
```

### 2. Initialize Capacitor (if not done)
```bash
npx cap init "WhatsOrder" "com.vishal.whatsorder"
```

### 3. Add Android Platform
```bash
npx cap add android
```

### 4. Firebase Setup

#### A. Create Firebase Project
1. Go to https://console.firebase.google.com/
2. Create new project named "WhatsOrder"
3. Enable Google Sign-In in Authentication > Sign-in method

#### B. Android App Configuration
1. Add Android app to Firebase project:
   - Package name: `com.vishal.whatsorder`
   - App nickname: `WhatsOrder`
2. Download `google-services.json`
3. Place it in: `android/app/google-services.json`

#### C. Get SHA-1/SHA-256 Fingerprints
```bash
# For debug keystore
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android

# For release keystore (create one first)
keytool -genkey -v -keystore whatsorder-release-key.keystore -alias whatsorder -keyalg RSA -keysize 2048 -validity 10000
keytool -list -v -keystore whatsorder-release-key.keystore -alias whatsorder
```

Add these fingerprints to Firebase project settings.

#### D. Update capacitor.config.ts
Replace `YOUR_FIREBASE_WEB_CLIENT_ID` with your Firebase Web Client ID from Firebase Console > Project Settings > General > Web API Key.

### 5. Build Commands

#### Sync and Copy Web Assets
```bash
npx cap sync android
```

#### Open in Android Studio
```bash
npx cap open android
```

### 6. Android Studio Setup

1. **Gradle Sync**: Wait for Gradle to sync all dependencies
2. **Build APK**: Build > Build Bundle(s)/APK(s) > Build APK(s)
3. **Generate Signed APK**: Build > Generate Signed Bundle/APK

### 7. File Upload Configuration

The app supports:
- ✅ `<input type="file">` from web page
- ✅ Camera capture via Capacitor Camera plugin
- ✅ Gallery selection via Capacitor Camera plugin
- ✅ Document picker through native file picker

### 8. Testing

#### Test Google Sign In:
```javascript
import { signInWithGoogle } from './src/google-auth.js';

// Add button to your web app
document.getElementById('google-login').onclick = async () => {
  try {
    const user = await signInWithGoogle();
    console.log('Signed in user:', user);
  } catch (error) {
    console.error('Sign in error:', error);
  }
};
```

#### Test File Upload:
```javascript
import { takePicture, selectFromGallery } from './src/google-auth.js';

// Camera
document.getElementById('camera-btn').onclick = async () => {
  const imageData = await takePicture();
  document.getElementById('preview').src = imageData;
};

// Gallery
document.getElementById('gallery-btn').onclick = async () => {
  const imageData = await selectFromGallery();
  document.getElementById('preview').src = imageData;
};
```

## 📁 Final Folder Structure
```
whatsorder-capacitor/
├── android/
│   ├── app/
│   │   ├── src/main/
│   │   │   ├── java/com/vishal/whatsorder/MainActivity.java
│   │   │   ├── AndroidManifest.xml
│   │   │   └── res/xml/file_paths.xml
│   │   ├── build.gradle
│   │   └── google-services.json  ← Place Firebase config here
│   └── build.gradle
├── src/
│   └── google-auth.js
├── capacitor.config.ts
├── package.json
└── README.md
```

## 🔧 Troubleshooting

### Common Issues:

1. **Google Sign In fails**: Check SHA-1/SHA-256 fingerprints in Firebase
2. **File upload not working**: Ensure permissions in AndroidManifest.xml
3. **App crashes**: Check Android Studio Logcat for errors
4. **Build fails**: Clean project and rebuild: Build > Clean Project

### Production Build:
```bash
# Create release build
./gradlew assembleRelease

# Create AAB for Play Store
./gradlew bundleRelease
```

## 🚀 Deployment to Play Store

1. Create signed AAB: `./gradlew bundleRelease`
2. Upload to Google Play Console
3. Fill app details, screenshots, descriptions
4. Submit for review

## ⚠️ Important Notes

- Replace `YOUR_FIREBASE_WEB_CLIENT_ID` in capacitor.config.ts
- Add actual SHA-1/SHA-256 fingerprints to Firebase
- Test on physical device for camera/file upload features
- The app will load your Vercel URL (https://whats-order-osr3.vercel.app) in WebView
