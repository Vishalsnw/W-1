
#!/bin/bash
echo "🔍 Verifying Firebase Crashlytics Setup..."
echo "=========================================="

# Check if google-services.json exists
if [ -f "app/google-services.json" ]; then
    echo "✅ google-services.json found"
    
    # Check if project_id exists in the file
    if grep -q "project_id" app/google-services.json; then
        PROJECT_ID=$(grep -o '"project_id"[^,]*' app/google-services.json | cut -d'"' -f4)
        echo "✅ Project ID: $PROJECT_ID"
    else
        echo "❌ No project_id found in google-services.json"
    fi
else
    echo "❌ google-services.json not found in app/ directory"
fi

echo ""
echo "🔧 Checking Gradle configuration..."

# Check if crashlytics plugin is applied
if grep -q "com.google.firebase.crashlytics" app/build.gradle; then
    echo "✅ Crashlytics plugin applied in app/build.gradle"
else
    echo "❌ Crashlytics plugin not found in app/build.gradle"
fi

# Check if Firebase dependencies are included
if grep -q "firebase-crashlytics" app/build.gradle; then
    echo "✅ Firebase Crashlytics dependency found"
else
    echo "❌ Firebase Crashlytics dependency not found"
fi

if grep -q "firebase-analytics" app/build.gradle; then
    echo "✅ Firebase Analytics dependency found (for breadcrumbs)"
else
    echo "⚠️  Firebase Analytics dependency not found (breadcrumbs won't work)"
fi

echo ""
echo "📱 Next steps:"
echo "1. Build the app: ./gradlew assembleDebug"
echo "2. Install on device/emulator"
echo "3. Open the app and click 'Test Crash' button"
echo "4. Restart the app after crash"
echo "5. Check Firebase Console > Crashlytics for crash report"
echo ""
echo "🌐 Firebase Console: https://console.firebase.google.com/project/$PROJECT_ID/crashlytics"

chmod +x verify-crashlytics.sh
