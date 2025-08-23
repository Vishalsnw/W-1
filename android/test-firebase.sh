
#!/bin/bash
echo "🔍 Testing Firebase Configuration..."
echo "==================================="

# Check if google-services.json exists
if [ -f "app/google-services.json" ]; then
    echo "✅ google-services.json found"
    
    # Check if it has proper client configuration
    if grep -q '"oauth_client": \[\]' app/google-services.json; then
        echo "⚠️  WARNING: oauth_client is empty - Google Sign-In may not work"
        echo "   Add SHA-1/SHA-256 fingerprints to Firebase Console"
    else
        echo "✅ oauth_client configuration found"
    fi
    
    # Check project ID
    PROJECT_ID=$(grep '"project_id"' app/google-services.json | sed 's/.*: *"\([^"]*\)".*/\1/')
    echo "📋 Project ID: $PROJECT_ID"
    
    # Check package name
    PACKAGE_NAME=$(grep '"package_name"' app/google-services.json | sed 's/.*: *"\([^"]*\)".*/\1/')
    echo "📦 Package Name: $PACKAGE_NAME"
    
else
    echo "❌ google-services.json NOT FOUND"
    echo "   Download from Firebase Console and place in android/app/"
fi

echo ""
echo "🔧 To fix Google Sign-In:"
echo "1. Go to Firebase Console > Project Settings"
echo "2. Add SHA-1 fingerprint (run: keytool -list -v -keystore ~/.android/debug.keystore)"
echo "3. Download updated google-services.json"
echo "4. Replace the current file"
