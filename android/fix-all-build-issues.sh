
#!/bin/bash
echo "🔧 Comprehensive Android Build Fix Script"
echo "=========================================="

# Make scripts executable
chmod +x *.sh

# 1. Clean all build directories
echo "🧹 Cleaning build directories..."
rm -rf .gradle
rm -rf app/build
rm -rf */build
rm -rf build

# 2. Fix manifest files
echo "🔧 Fixing AndroidManifest.xml files..."
./fix-manifests.sh

# 3. Fix plugin manifests in node_modules
echo "🔧 Fixing plugin manifest files..."
find ../node_modules -name "AndroidManifest.xml" -path "*/android/src/main/*" 2>/dev/null | while read manifest; do
    echo "📄 Fixing plugin manifest: $manifest"
    # Remove package attributes
    sed -i 's/ package="[^"]*"//g' "$manifest" 2>/dev/null || true
    sed -i 's/package="[^"]*" //g' "$manifest" 2>/dev/null || true
    # Ensure proper xmlns
    if ! grep -q "xmlns:android=" "$manifest" 2>/dev/null; then
        sed -i 's/<manifest/<manifest xmlns:android="http:\/\/schemas.android.com\/apk\/res\/android"/g' "$manifest" 2>/dev/null || true
    fi
done

# 4. Validate all manifests
echo "🔍 Validating all manifests..."
./validate-manifests.sh

# 5. Clean Gradle cache
echo "🧹 Cleaning Gradle cache..."
rm -rf ~/.gradle/caches/
./gradlew clean --no-daemon || true

# 6. Sync Capacitor
echo "🔄 Syncing Capacitor..."
cd ..
npx cap sync android
cd android

# 7. Final validation
echo "🔍 Final validation..."
echo "Checking for any remaining package attributes..."
REMAINING_PACKAGES=$(find . -name "AndroidManifest.xml" -exec grep -l "package=" {} \; 2>/dev/null)
if [ -n "$REMAINING_PACKAGES" ]; then
    echo "❌ Still found package attributes in:"
    echo "$REMAINING_PACKAGES"
    exit 1
else
    echo "✅ No package attributes found"
fi

echo ""
echo "✅ All build issues have been fixed!"
echo "Now try building with: ./gradlew assembleDebug --stacktrace"
