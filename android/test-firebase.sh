
#!/bin/bash
echo "🔥 Firebase Services Test"
echo "========================="

# Check if we're in the android directory
if [ ! -f "app/build.gradle" ]; then
    echo "❌ Please run this script from the android/ directory"
    exit 1
fi

echo "📋 Testing Firebase Configuration..."

# Test 1: Check google-services.json
echo ""
echo "🧪 Test 1: google-services.json validation"
if [ -f "app/google-services.json" ]; then
    echo "✅ google-services.json exists"
    
    # Validate JSON structure
    if command -v python3 >/dev/null 2>&1; then
        python3 -c "import json; json.load(open('app/google-services.json'))" 2>/dev/null
        if [ $? -eq 0 ]; then
            echo "✅ google-services.json is valid JSON"
        else
            echo "❌ google-services.json has invalid JSON format"
        fi
    fi
    
    # Check required fields
    if grep -q "project_info" "app/google-services.json" && \
       grep -q "client" "app/google-services.json" && \
       grep -q "services" "app/google-services.json"; then
        echo "✅ google-services.json has required structure"
    else
        echo "❌ google-services.json missing required fields"
    fi
else
    echo "❌ google-services.json not found"
    echo "   📝 Download from: Firebase Console > Project Settings > General > Your apps"
fi

# Test 2: Check Gradle plugins
echo ""
echo "🧪 Test 2: Gradle plugins verification"
if grep -q "com.google.gms.google-services" "build.gradle"; then
    echo "✅ Google Services plugin found in root build.gradle"
else
    echo "❌ Google Services plugin missing from root build.gradle"
fi

if grep -q "com.google.firebase.crashlytics" "build.gradle"; then
    echo "✅ Crashlytics plugin found in root build.gradle"
else
    echo "❌ Crashlytics plugin missing from root build.gradle"
fi

if grep -q "com.google.gms.google-services" "app/build.gradle"; then
    echo "✅ Google Services plugin applied in app build.gradle"
else
    echo "❌ Google Services plugin not applied in app build.gradle"
fi

if grep -q "com.google.firebase.crashlytics" "app/build.gradle"; then
    echo "✅ Crashlytics plugin applied in app build.gradle"
else
    echo "❌ Crashlytics plugin not applied in app build.gradle"
fi

# Test 3: Check Firebase dependencies
echo ""
echo "🧪 Test 3: Firebase dependencies verification"
DEPS_TO_CHECK=(
    "firebase-bom"
    "firebase-crashlytics"
    "firebase-analytics"
    "firebase-auth"
)

for dep in "${DEPS_TO_CHECK[@]}"; do
    if grep -q "$dep" "app/build.gradle"; then
        echo "✅ $dep dependency found"
    else
        echo "⚠️  $dep dependency missing"
    fi
done

# Test 4: Check permissions
echo ""
echo "🧪 Test 4: Android permissions verification"
REQUIRED_PERMS=(
    "android.permission.INTERNET"
    "android.permission.ACCESS_NETWORK_STATE"
)

for perm in "${REQUIRED_PERMS[@]}"; do
    if grep -q "$perm" "app/src/main/AndroidManifest.xml"; then
        echo "✅ $perm permission found"
    else
        echo "❌ $perm permission missing"
    fi
done

# Test 5: Check application configuration
echo ""
echo "🧪 Test 5: Application configuration verification"
if grep -q "android:usesCleartextTraffic=\"true\"" "app/src/main/AndroidManifest.xml"; then
    echo "✅ Cleartext traffic enabled (for development)"
else
    echo "⚠️  Cleartext traffic not enabled (may affect development)"
fi

if grep -q "multiDexEnabled true" "app/build.gradle"; then
    echo "✅ MultiDex enabled"
else
    echo "⚠️  MultiDex not enabled (may be needed for Firebase)"
fi

# Test 6: Build configuration
echo ""
echo "🧪 Test 6: Build configuration verification"
if grep -q "minSdk.*2[4-9]" "app/build.gradle"; then
    echo "✅ Minimum SDK version compatible with Firebase (24+)"
else
    echo "⚠️  Check minimum SDK version (should be 21+ for Firebase)"
fi

# Test 7: Test build without running
echo ""
echo "🧪 Test 7: Gradle configuration test"
echo "Testing Gradle configuration (dry run)..."
./gradlew help --dry-run >/dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✅ Gradle configuration is valid"
else
    echo "❌ Gradle configuration has issues"
fi

# Summary
echo ""
echo "📊 FIREBASE TEST SUMMARY"
echo "========================"
echo "🔥 Firebase services test completed"
echo ""
echo "🚀 READY TO BUILD:"
echo "   ./gradlew assembleDebug --stacktrace"
echo ""
echo "🧪 READY TO TEST CRASHLYTICS:"
echo "   1. Build and install the app"
echo "   2. Open app and tap 'Test Crash' button"
echo "   3. Restart app to send crash report"
echo "   4. Check Firebase Console after 5-10 minutes"
echo ""
echo "✅ Firebase test complete!"
