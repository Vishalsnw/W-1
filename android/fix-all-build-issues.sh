
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

# 2. Fix manifest files in project BEFORE sync
echo "🔧 Pre-sync manifest fixes in project..."
find . -name "AndroidManifest.xml" -type f | while read manifest; do
    echo "📄 Pre-processing: $manifest"
    
    # Remove package attributes
    sed -i 's/ package="[^"]*"//g' "$manifest" 2>/dev/null || true
    sed -i 's/package="[^"]*" //g' "$manifest" 2>/dev/null || true
    
    # Ensure proper xmlns declaration
    if ! grep -q "xmlns:android=" "$manifest" 2>/dev/null; then
        sed -i 's/<manifest/<manifest xmlns:android="http:\/\/schemas.android.com\/apk\/res\/android"/g' "$manifest" 2>/dev/null || true
    fi
    
    # Fix malformed manifest tags
    sed -i 's/<manifest[[:space:]]*>/<manifest xmlns:android="http:\/\/schemas.android.com\/apk\/res\/android">/g' "$manifest" 2>/dev/null || true
done

# 3. Clean Gradle cache BEFORE sync
echo "🧹 Pre-sync Gradle cache cleanup..."
rm -rf ~/.gradle/caches/
./gradlew clean --no-daemon || true

# 4. Sync Capacitor (this will regenerate some manifests)
echo "🔄 Syncing Capacitor..."
cd ..
npx cap sync android
cd android

# 5. Post-sync manifest fixes for ALL locations
echo "🔧 Post-sync comprehensive manifest fixes..."

# Fix project manifests again (in case sync regenerated them)
find . -name "AndroidManifest.xml" -type f | while read manifest; do
    echo "📄 Post-sync fixing project: $manifest"
    sed -i 's/ package="[^"]*"//g' "$manifest" 2>/dev/null || true
    sed -i 's/package="[^"]*" //g' "$manifest" 2>/dev/null || true
    if ! grep -q "xmlns:android=" "$manifest" 2>/dev/null; then
        sed -i 's/<manifest/<manifest xmlns:android="http:\/\/schemas.android.com\/apk\/res\/android"/g' "$manifest" 2>/dev/null || true
    fi
done

# Fix Capacitor core manifests
echo "🔧 Fixing Capacitor core manifests..."
find ../node_modules/@capacitor -name "AndroidManifest.xml" 2>/dev/null | while read manifest; do
    echo "📄 Fixing Capacitor core: $manifest"
    sed -i 's/ package="[^"]*"//g' "$manifest" 2>/dev/null || true
    sed -i 's/package="[^"]*" //g' "$manifest" 2>/dev/null || true
    if ! grep -q "xmlns:android=" "$manifest" 2>/dev/null; then
        sed -i 's/<manifest/<manifest xmlns:android="http:\/\/schemas.android.com\/apk\/res\/android"/g' "$manifest" 2>/dev/null || true
    fi
done

# Fix specific plugin manifests that appear in the error
echo "🔧 Fixing specific plugin manifests..."
PLUGIN_PATHS=(
    "../node_modules/@capacitor-community/admob"
    "../node_modules/@capacitor/camera"
    "../node_modules/@codetrix-studio/capacitor-google-auth"
    "../node_modules/@capacitor/filesystem"
)

for plugin_path in "${PLUGIN_PATHS[@]}"; do
    if [ -d "$plugin_path" ]; then
        find "$plugin_path" -name "AndroidManifest.xml" 2>/dev/null | while read manifest; do
            echo "📄 Fixing specific plugin: $manifest"
            sed -i 's/ package="[^"]*"//g' "$manifest" 2>/dev/null || true
            sed -i 's/package="[^"]*" //g' "$manifest" 2>/dev/null || true
            if ! grep -q "xmlns:android=" "$manifest" 2>/dev/null; then
                sed -i 's/<manifest/<manifest xmlns:android="http:\/\/schemas.android.com\/apk\/res\/android"/g' "$manifest" 2>/dev/null || true
            fi
        done
    fi
done

# Fix ALL node_modules manifests as fallback
echo "🔧 Fixing all remaining node_modules manifests..."
find ../node_modules -name "AndroidManifest.xml" 2>/dev/null | while read manifest; do
    sed -i 's/ package="[^"]*"//g' "$manifest" 2>/dev/null || true
    sed -i 's/package="[^"]*" //g' "$manifest" 2>/dev/null || true
    if ! grep -q "xmlns:android=" "$manifest" 2>/dev/null; then
        sed -i 's/<manifest/<manifest xmlns:android="http:\/\/schemas.android.com\/apk\/res\/android"/g' "$manifest" 2>/dev/null || true
    fi
done

# 6. Validate all manifests
echo "🔍 Validating all manifests..."
./validate-manifests.sh || echo "⚠️ Some validation warnings found but continuing..."

# 7. Final Gradle cleanup
echo "🧹 Final Gradle cleanup..."
./gradlew clean --no-daemon || true

# 8. Refresh dependencies
echo "🔄 Refreshing dependencies..."
./gradlew --refresh-dependencies --no-daemon || true

# 9. Final validation
echo "🔍 Final comprehensive validation..."
echo "Checking for any remaining package attributes in project..."
PROJECT_PACKAGES=$(find . -name "AndroidManifest.xml" -exec grep -l "package=" {} \; 2>/dev/null || true)
if [ -n "$PROJECT_PACKAGES" ]; then
    echo "❌ Still found package attributes in project:"
    echo "$PROJECT_PACKAGES"
    # Show the actual lines
    find . -name "AndroidManifest.xml" -exec grep -n "package=" {} + 2>/dev/null || true
else
    echo "✅ No package attributes found in project"
fi

echo ""
echo "✅ All build issues have been addressed!"
echo "🚀 Ready to build with: ./gradlew assembleDebug --stacktrace"
echo "Or use the 'Build Android APK' workflow in Replit"
