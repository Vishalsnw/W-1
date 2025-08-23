#!/bin/bash

echo "🔍 Testing Firebase Configuration..."
echo "==================================="

# Check google-services.json
if [ -f "app/google-services.json" ]; then
    echo "✅ google-services.json found"

    # Extract project info
    PROJECT_ID=$(grep -o '"project_id": "[^"]*"' app/google-services.json | cut -d'"' -f4)
    PACKAGE_NAME=$(grep -o '"package_name": "[^"]*"' app/google-services.json | cut -d'"' -f4)

    echo "📋 Project ID: $PROJECT_ID"
    echo "📦 Package Name: $PACKAGE_NAME"

    # Check oauth_client array
    OAUTH_CLIENT_COUNT=$(grep -c '"oauth_client":' app/google-services.json)
    if [ "$OAUTH_CLIENT_COUNT" -gt 0 ]; then
        # Check if oauth_client array is empty
        if grep -q '"oauth_client": \[\]' app/google-services.json; then
            echo "⚠️  WARNING: oauth_client is empty - Google Sign-In may not work"
            echo "   Add SHA-1/SHA-256 fingerprints to Firebase Console"
        else
            echo "✅ oauth_client configured"
        fi
    fi

    # Check for required services
    if grep -q '"firebase_crashlytics"' app/google-services.json; then
        echo "✅ Crashlytics service configured"
    else
        echo "⚠️  Crashlytics service not found in google-services.json"
    fi

else
    echo "❌ google-services.json not found!"
    echo "   Download from Firebase Console and place in android/app/"
    exit 1
fi

echo ""
echo "🔑 Debug Keystore Info:"
if [ -f ~/.android/debug.keystore ]; then
    echo "✅ Debug keystore found"
    echo "SHA-1 Fingerprint:"
    keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android 2>/dev/null | grep SHA1 | head -1 || echo "❌ Could not extract SHA1"
else
    echo "⚠️  Debug keystore not found - creating one..."
    mkdir -p ~/.android
    keytool -genkey -v -keystore ~/.android/debug.keystore -storepass android -alias androiddebugkey -keypass android -keyalg RSA -keysize 2048 -validity 10000 -dname "CN=Android Debug,O=Android,C=US"
    echo "✅ Debug keystore created"
fi

echo ""
echo "🔧 Firebase Build Configuration:"
if grep -q "google-services" build.gradle; then
    echo "✅ Google Services plugin in root build.gradle"
else
    echo "❌ Google Services plugin missing in root build.gradle"
fi

if grep -q "google-services" app/build.gradle; then
    echo "✅ Google Services applied in app build.gradle"
else
    echo "❌ Google Services not applied in app build.gradle"
fi

if grep -q "firebase-crashlytics" app/build.gradle; then
    echo "✅ Firebase Crashlytics plugin configured"
else
    echo "⚠️  Firebase Crashlytics plugin not configured"
fi

echo ""
echo "🔧 To fix Google Sign-In:"
echo "1. Go to Firebase Console > Project Settings"
echo "2. Add SHA-1 fingerprint (copy from above)"
echo "3. Download updated google-services.json"
echo "4. Replace the current file"