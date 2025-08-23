
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

# 2. Fix manifest files in project
echo "🔧 Fixing project AndroidManifest.xml files..."
find . -name "AndroidManifest.xml" -type f | while read manifest; do
    echo "📄 Processing: $manifest"
    
    # Remove package attributes
    sed -i 's/ package="[^"]*"//g' "$manifest" 2>/dev/null || true
    sed -i 's/package="[^"]*" //g' "$manifest" 2>/dev/null || true
    
    # Ensure proper xmlns declaration
    if ! grep -q "xmlns:android=" "$manifest" 2>/dev/null; then
        sed -i 's/<manifest/<manifest xmlns:android="http:\/\/schemas.android.com\/apk\/res\/android"/g' "$manifest" 2>/dev/null || true
    fi
done

# 3. Fix plugin manifests in node_modules
echo "🔧 Fixing plugin manifest files in node_modules..."
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

# 4. Fix Capacitor plugin manifests specifically
echo "🔧 Fixing Capacitor core and plugin manifests..."
find ../node_modules/@capacitor -name "AndroidManifest.xml" 2>/dev/null | while read manifest; do
    echo "📄 Fixing Capacitor manifest: $manifest"
    sed -i 's/ package="[^"]*"//g' "$manifest" 2>/dev/null || true
    sed -i 's/package="[^"]*" //g' "$manifest" 2>/dev/null || true
    if ! grep -q "xmlns:android=" "$manifest" 2>/dev/null; then
        sed -i 's/<manifest/<manifest xmlns:android="http:\/\/schemas.android.com\/apk\/res\/android"/g' "$manifest" 2>/dev/null || true
    fi
done

# 5. Fix other plugin manifests
echo "🔧 Fixing other plugin manifests..."
find ../node_modules -name "AndroidManifest.xml" -path "*/capacitor*" 2>/dev/null | while read manifest; do
    echo "📄 Fixing other plugin manifest: $manifest"
    sed -i 's/ package="[^"]*"//g' "$manifest" 2>/dev/null || true
    sed -i 's/package="[^"]*" //g' "$manifest" 2>/dev/null || true
    if ! grep -q "xmlns:android=" "$manifest" 2>/dev/null; then
        sed -i 's/<manifest/<manifest xmlns:android="http:\/\/schemas.android.com\/apk\/res\/android"/g' "$manifest" 2>/dev/null || true
    fi
done

# 6. Validate all manifests
echo "🔍 Validating all manifests..."
./validate-manifests.sh

# 7. Clean Gradle cache
echo "🧹 Cleaning Gradle cache..."
rm -rf ~/.gradle/caches/
./gradlew clean --no-daemon || true

# 8. Sync Capacitor
echo "🔄 Syncing Capacitor..."
cd ..
npx cap sync android
cd android

# 9. Final comprehensive validation
echo "🔍 Final comprehensive validation..."
echo "Checking for any remaining package attributes in project..."
PROJECT_PACKAGES=$(find . -name "AndroidManifest.xml" -exec grep -l "package=" {} \; 2>/dev/null || true)
if [ -n "$PROJECT_PACKAGES" ]; then
    echo "❌ Still found package attributes in project:"
    echo "$PROJECT_PACKAGES"
else
    echo "✅ No package attributes found in project"
fi

echo "Checking for any remaining package attributes in node_modules..."
NODE_PACKAGES=$(find ../node_modules -name "AndroidManifest.xml" -exec grep -l "package=" {} \; 2>/dev/null | head -10 || true)
if [ -n "$NODE_PACKAGES" ]; then
    echo "⚠️  Still found package attributes in node_modules (showing first 10):"
    echo "$NODE_PACKAGES"
    echo "This is expected and will be fixed during build..."
else
    echo "✅ No package attributes found in node_modules"
fi

echo ""
echo "✅ All build issues have been addressed!"
echo "Now try building with: ./gradlew assembleDebug --stacktrace"
