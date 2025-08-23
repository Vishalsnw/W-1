
#!/bin/bash
echo "🔧 Comprehensive Android Build Fix Script (Enhanced)"
echo "===================================================="

# Make scripts executable
chmod +x *.sh

# 1. Clean all build directories and caches FIRST
echo "🧹 Deep cleaning all build artifacts..."
rm -rf .gradle
rm -rf app/build
rm -rf */build
rm -rf build
rm -rf ~/.gradle/caches/
rm -rf ~/.gradle/daemon/
rm -rf ~/.gradle/native/
rm -rf ~/.gradle/wrapper/

# 2. Kill any existing gradle daemons
echo "🔄 Stopping Gradle daemons..."
./gradlew --stop || true
pkill -f gradle || true

# 3. Pre-sync manifest fixes (before Capacitor sync)
echo "🔧 Phase 1: Pre-sync manifest fixes..."
find . -name "AndroidManifest.xml" -type f | while read manifest; do
    echo "📄 Pre-fixing: $manifest"
    
    # Backup original
    cp "$manifest" "$manifest.pre-fix-backup" 2>/dev/null || true
    
    # Aggressive package attribute removal
    sed -i 's/package="[^"]*"//g' "$manifest" 2>/dev/null || true
    sed -i 's/package = "[^"]*"//g' "$manifest" 2>/dev/null || true
    sed -i 's/package=[^[:space:]]*//g' "$manifest" 2>/dev/null || true
    
    # Fix manifest tag structure
    sed -i 's/<manifest[[:space:]]*>/<manifest xmlns:android="http:\/\/schemas.android.com\/apk\/res\/android">/g' "$manifest" 2>/dev/null || true
    sed -i 's/<manifest[[:space:]]\+/<manifest xmlns:android="http:\/\/schemas.android.com\/apk\/res\/android" /g' "$manifest" 2>/dev/null || true
    
    # Ensure xmlns declaration exists
    if ! grep -q "xmlns:android=" "$manifest" 2>/dev/null; then
        sed -i 's/<manifest/<manifest xmlns:android="http:\/\/schemas.android.com\/apk\/res\/android"/g' "$manifest" 2>/dev/null || true
    fi
done

# 4. Fix node_modules manifests BEFORE sync
echo "🔧 Phase 2: Pre-sync node_modules manifest fixes..."
find ../node_modules -name "AndroidManifest.xml" 2>/dev/null | while read manifest; do
    echo "📄 Pre-fixing node_modules: $manifest"
    sed -i 's/package="[^"]*"//g' "$manifest" 2>/dev/null || true
    sed -i 's/package = "[^"]*"//g' "$manifest" 2>/dev/null || true
    sed -i 's/package=[^[:space:]]*//g' "$manifest" 2>/dev/null || true
    if ! grep -q "xmlns:android=" "$manifest" 2>/dev/null; then
        sed -i 's/<manifest/<manifest xmlns:android="http:\/\/schemas.android.com\/apk\/res\/android"/g' "$manifest" 2>/dev/null || true
    fi
done

# 5. Force clean Gradle before sync
echo "🧹 Force Gradle clean before sync..."
./gradlew clean --no-daemon || true

# 6. Sync Capacitor (this regenerates manifests)
echo "🔄 Syncing Capacitor..."
cd ..
npx cap sync android --force
cd android

# 7. IMMEDIATE post-sync manifest fixes (critical timing)
echo "🔧 Phase 3: Immediate post-sync manifest fixes..."
sleep 2  # Brief pause to ensure sync completes

# Fix ALL manifests again immediately after sync
find . -name "AndroidManifest.xml" -type f | while read manifest; do
    echo "📄 Post-sync fixing: $manifest"
    sed -i 's/package="[^"]*"//g' "$manifest" 2>/dev/null || true
    sed -i 's/package = "[^"]*"//g' "$manifest" 2>/dev/null || true
    sed -i 's/package=[^[:space:]]*//g' "$manifest" 2>/dev/null || true
    if ! grep -q "xmlns:android=" "$manifest" 2>/dev/null; then
        sed -i 's/<manifest/<manifest xmlns:android="http:\/\/schemas.android.com\/apk\/res\/android"/g' "$manifest" 2>/dev/null || true
    fi
done

# 8. Target specific problematic plugins from the error log
echo "🔧 Phase 4: Targeting specific problematic plugins..."
PROBLEM_PLUGINS=(
    "@capacitor/android"
    "@capacitor-community/admob" 
    "@capacitor/camera"
    "@codetrix-studio/capacitor-google-auth"
    "@capacitor/filesystem"
    "capacitor-cordova-android-plugins"
)

for plugin in "${PROBLEM_PLUGINS[@]}"; do
    echo "🎯 Targeting plugin: $plugin"
    find ../node_modules -path "*$plugin*" -name "AndroidManifest.xml" 2>/dev/null | while read manifest; do
        echo "📄 Fixing problematic plugin: $manifest"
        sed -i 's/package="[^"]*"//g' "$manifest" 2>/dev/null || true
        sed -i 's/package = "[^"]*"//g' "$manifest" 2>/dev/null || true
        sed -i 's/package=[^[:space:]]*//g' "$manifest" 2>/dev/null || true
        if ! grep -q "xmlns:android=" "$manifest" 2>/dev/null; then
            sed -i 's/<manifest/<manifest xmlns:android="http:\/\/schemas.android.com\/apk\/res\/android"/g' "$manifest" 2>/dev/null || true
        fi
        
        # Show what we fixed
        echo "   📋 First 3 lines after fix:"
        head -3 "$manifest" | sed 's/^/     /' 2>/dev/null || true
    done
done

# 9. Final comprehensive sweep of ALL node_modules
echo "🔧 Phase 5: Final comprehensive node_modules sweep..."
find ../node_modules -name "AndroidManifest.xml" 2>/dev/null | while read manifest; do
    # Apply all fixes one more time
    sed -i 's/package="[^"]*"//g' "$manifest" 2>/dev/null || true
    sed -i 's/package = "[^"]*"//g' "$manifest" 2>/dev/null || true  
    sed -i 's/package=[^[:space:]]*//g' "$manifest" 2>/dev/null || true
    if ! grep -q "xmlns:android=" "$manifest" 2>/dev/null; then
        sed -i 's/<manifest/<manifest xmlns:android="http:\/\/schemas.android.com\/apk\/res\/android"/g' "$manifest" 2>/dev/null || true
    fi
done

# 10. Validation with detailed output
echo "🔍 Phase 6: Comprehensive validation..."
echo "Checking project manifests..."
PROJECT_ISSUES=0
find . -name "AndroidManifest.xml" -type f | while read manifest; do
    if grep -q "package=" "$manifest" 2>/dev/null; then
        echo "❌ PROJECT ISSUE: $manifest still has package attribute"
        echo "   Line: $(grep -n "package=" "$manifest" 2>/dev/null)"
        PROJECT_ISSUES=$((PROJECT_ISSUES + 1))
    fi
done

echo "Checking critical plugin manifests..."
PLUGIN_ISSUES=0
for plugin in "${PROBLEM_PLUGINS[@]}"; do
    find ../node_modules -path "*$plugin*" -name "AndroidManifest.xml" 2>/dev/null | while read manifest; do
        if grep -q "package=" "$manifest" 2>/dev/null; then
            echo "❌ PLUGIN ISSUE: $manifest still has package attribute"
            echo "   Line: $(grep -n "package=" "$manifest" 2>/dev/null)"
            PLUGIN_ISSUES=$((PLUGIN_ISSUES + 1))
        fi
    done
done

# 11. Final Gradle preparation
echo "🔧 Phase 7: Final Gradle preparation..."
./gradlew clean --no-daemon || true
./gradlew --refresh-dependencies --no-daemon || true

echo ""
echo "✅ ENHANCED BUILD FIX COMPLETED!"
echo "🚀 Ready to build with: ./gradlew assembleDebug --stacktrace"
echo "📊 If build still fails, run: ./gradlew assembleDebug --debug --stacktrace"
echo ""
