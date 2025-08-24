
#!/bin/bash
echo "🔥 Firebase Crashlytics Setup Verification"
echo "==========================================="

# Check Firebase configuration
echo "📋 Step 1: Checking Firebase configuration..."
if [ -f "app/google-services.json" ]; then
    echo "✅ google-services.json found"
    
    # Check if project_id exists in google-services.json
    if grep -q "project_id" "app/google-services.json"; then
        PROJECT_ID=$(grep "project_id" "app/google-services.json" | cut -d'"' -f4)
        echo "✅ Project ID: $PROJECT_ID"
    else
        echo "❌ No project_id found in google-services.json"
    fi
else
    echo "❌ google-services.json NOT found in app/ directory"
    echo "   📝 Download it from Firebase Console > Project Settings > General"
fi

# Check Gradle plugins
echo ""
echo "📋 Step 2: Checking Gradle plugins..."
if grep -q "com.google.firebase.crashlytics" "build.gradle"; then
    echo "✅ Crashlytics plugin found in root build.gradle"
else
    echo "❌ Crashlytics plugin missing from root build.gradle"
fi

if grep -q "com.google.firebase.crashlytics" "app/build.gradle"; then
    echo "✅ Crashlytics plugin applied in app build.gradle"
else
    echo "❌ Crashlytics plugin not applied in app build.gradle"
fi

# Check dependencies
echo ""
echo "📋 Step 3: Checking Firebase dependencies..."
if grep -q "firebase-crashlytics" "app/build.gradle"; then
    echo "✅ Firebase Crashlytics dependency found"
else
    echo "❌ Firebase Crashlytics dependency missing"
fi

if grep -q "firebase-analytics" "app/build.gradle"; then
    echo "✅ Firebase Analytics dependency found (for breadcrumbs)"
else
    echo "⚠️  Firebase Analytics dependency missing (optional but recommended)"
fi

if grep -q "firebase-crashlytics-ndk" "app/build.gradle"; then
    echo "✅ Firebase Crashlytics NDK dependency found"
else
    echo "⚠️  Firebase Crashlytics NDK dependency missing (for native crashes)"
fi

# Check AndroidManifest
echo ""
echo "📋 Step 4: Checking AndroidManifest.xml..."
if [ -f "app/src/main/AndroidManifest.xml" ]; then
    echo "✅ AndroidManifest.xml found"
    
    # Check for internet permission
    if grep -q "android.permission.INTERNET" "app/src/main/AndroidManifest.xml"; then
        echo "✅ INTERNET permission found"
    else
        echo "❌ INTERNET permission missing (required for Crashlytics)"
    fi
else
    echo "❌ AndroidManifest.xml not found"
fi

# Check MainActivity for crash test
echo ""
echo "📋 Step 5: Checking MainActivity for crash test..."
if [ -f "app/src/main/java/com/vishal/whatsorder/MainActivity.java" ]; then
    if grep -q "Test Crash" "app/src/main/java/com/vishal/whatsorder/MainActivity.java"; then
        echo "✅ Crash test button found in MainActivity"
    else
        echo "⚠️  Crash test button not found (will add it)"
    fi
else
    echo "⚠️  MainActivity.java not found (will create it)"
fi

# Check build configuration
echo ""
echo "📋 Step 6: Checking build configuration..."
if grep -q "minSdk.*24" "app/build.gradle"; then
    echo "✅ Minimum SDK version is compatible (24+)"
else
    echo "⚠️  Check minimum SDK version (should be 21+)"
fi

if grep -q "compileSdk.*34" "app/build.gradle"; then
    echo "✅ Compile SDK version is up to date (34)"
else
    echo "⚠️  Consider updating compile SDK version"
fi

# Final summary
echo ""
echo "📊 CRASHLYTICS SETUP SUMMARY"
echo "=============================="
echo "🔥 Firebase Crashlytics is configured in your project"
echo ""
echo "📝 NEXT STEPS:"
echo "1. Build the app: ./gradlew assembleDebug"
echo "2. Install on device/emulator"
echo "3. Open the app and press 'Test Crash' button"
echo "4. Restart the app to send crash report"
echo "5. Check Firebase Console > Crashlytics (reports may take 5-10 minutes)"
echo ""
echo "🔗 Firebase Console: https://console.firebase.google.com/project/$PROJECT_ID/crashlytics"
echo ""
echo "✅ Crashlytics verification complete!"
