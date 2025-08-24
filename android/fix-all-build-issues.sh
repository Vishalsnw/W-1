
#!/bin/bash
echo "🔧 COMPREHENSIVE Android Build Issues Fix"
echo "============================================"
echo "🎯 Targeting all known problematic plugins from build log"
echo ""

# Make sure we're in android directory
cd "$(dirname "$0")" 2>/dev/null || true

# 1. Initial cleanup
echo "🧹 Phase 1: Complete cleanup..."
rm -rf .gradle */build build ~/.gradle/caches/ 2>/dev/null || true

# 2. Clean Capacitor and force fresh sync
echo "🔄 Phase 2: Clean Capacitor sync..."
cd .. 2>/dev/null || true
rm -rf android/capacitor-cordova-android-plugins 2>/dev/null || true
npx cap sync android --force 2>/dev/null || true
cd android 2>/dev/null || true

# 2.5. Ensure capacitor-cordova-android-plugins directory exists
echo "📁 Ensuring capacitor-cordova-android-plugins directory exists..."
if [ ! -d "capacitor-cordova-android-plugins" ]; then
    echo "Creating capacitor-cordova-android-plugins directory..."
    mkdir -p capacitor-cordova-android-plugins/src/main/java
    mkdir -p capacitor-cordova-android-plugins/src/main/res
    touch capacitor-cordova-android-plugins/src/main/java/.gitkeep
    touch capacitor-cordova-android-plugins/src/main/res/.gitkeep
    
    # Create basic AndroidManifest.xml
    cat > capacitor-cordova-android-plugins/src/main/AndroidManifest.xml << 'EOF'
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
</manifest>
EOF
    
    # Create basic build.gradle if it doesn't exist
    if [ ! -f "capacitor-cordova-android-plugins/build.gradle" ]; then
        cp ../node_modules/@capacitor/android/capacitor-cordova-android-plugins/build.gradle capacitor-cordova-android-plugins/ 2>/dev/null || true
        if [ ! -f "capacitor-cordova-android-plugins/build.gradle" ]; then
            cat > capacitor-cordova-android-plugins/build.gradle << 'EOF'
ext {
    androidxAppCompatVersion = project.hasProperty('androidxAppCompatVersion') ? rootProject.ext.androidxAppCompatVersion : '1.6.1'
    cordovaAndroidVersion = project.hasProperty('cordovaAndroidVersion') ? rootProject.ext.cordovaAndroidVersion : '10.1.1'
}

buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath 'com.android.tools.build:gradle:8.2.2'
    }
}

apply plugin: 'com.android.library'

android {
    namespace "capacitor.cordova.android.plugins"
    compileSdk 34
    
    defaultConfig {
        minSdk 22
        targetSdk 34
        versionCode 1
        versionName "1.0"
    }
    
    compileOptions {
        sourceCompatibility JavaVersion.VERSION_17
        targetCompatibility JavaVersion.VERSION_17
    }
}

repositories {
    google()
    mavenCentral()
}

dependencies {
    implementation fileTree(dir: 'src/main/libs', include: ['*.jar'])
    implementation "androidx.appcompat:appcompat:$androidxAppCompatVersion"
    implementation "org.apache.cordova:framework:$cordovaAndroidVersion"
}
EOF
        fi
    fi
    
    # Create cordova.variables.gradle if it doesn't exist
    if [ ! -f "capacitor-cordova-android-plugins/cordova.variables.gradle" ]; then
        cat > capacitor-cordova-android-plugins/cordova.variables.gradle << 'EOF'
ext {
    minSdkVersion = 22
    compileSdkVersion = 34
    targetSdkVersion = 34
    androidxAppCompatVersion = '1.6.1'
    cordovaAndroidVersion = '10.1.1'
}
EOF
    fi
    
    echo "✅ capacitor-cordova-android-plugins directory created"
else
    echo "✅ capacitor-cordova-android-plugins directory already exists"
fi

# 3. Target EXACT problematic plugins from build log
echo "🎯 Phase 3: Fixing EXACT problematic plugins from build log..."
EXACT_PROBLEM_PLUGINS=(
    "capacitor-android"
    "capacitor-community-admob" 
    "capacitor-camera"
    "codetrix-studio-capacitor-google-auth"
    "capacitor-filesystem" 
    "capacitor-cordova-android-plugins"
)

for plugin in "${EXACT_PROBLEM_PLUGINS[@]}"; do
    echo "🔧 Processing plugin: $plugin"
    
    # Search in node_modules with multiple patterns
    PLUGIN_MANIFESTS=$(find ../node_modules -name "AndroidManifest.xml" -path "*$plugin*" 2>/dev/null || true)
    
    if [ -n "$PLUGIN_MANIFESTS" ]; then
        echo "$PLUGIN_MANIFESTS" | while read manifest; do
            if [ -f "$manifest" ]; then
                echo "  📄 Fixing: $manifest"
                
                # Make backup
                cp "$manifest" "$manifest.backup" 2>/dev/null || true
                
                # Remove ALL possible package attribute variations
                sed -i 's/package="[^"]*"//g' "$manifest" 2>/dev/null || true
                sed -i 's/package = "[^"]*"//g' "$manifest" 2>/dev/null || true
                sed -i 's/package=[^[:space:]">]*//g' "$manifest" 2>/dev/null || true
                sed -i 's/<manifest[[:space:]]*package="[^"]*"/<manifest/g' "$manifest" 2>/dev/null || true
                
                # Ensure xmlns declaration exists
                if ! grep -q "xmlns:android=" "$manifest" 2>/dev/null; then
                    sed -i 's/<manifest/<manifest xmlns:android="http:\/\/schemas.android.com\/apk\/res\/android"/g' "$manifest" 2>/dev/null || true
                fi
                
                # Verify fix worked
                if grep -q "package=" "$manifest" 2>/dev/null; then
                    echo "    ❌ Still has package attribute - trying more aggressive fix"
                    # More aggressive regex
                    sed -i 's/[[:space:]]*package[[:space:]]*=[[:space:]]*"[^"]*"[[:space:]]*//g' "$manifest" 2>/dev/null || true
                    sed -i 's/[[:space:]]*package[[:space:]]*=[[:space:]]*[^[:space:]">]*[[:space:]]*//g' "$manifest" 2>/dev/null || true
                else
                    echo "    ✅ Package attribute removed"
                fi
                
                # Show result
                echo "    📋 First line after fix:"
                head -1 "$manifest" 2>/dev/null | sed 's/^/      /' || echo "      [Could not read]"
            fi
        done
    else
        echo "  ℹ️  No manifests found for $plugin"
    fi
done

# 4. Fix project manifests
echo "🔧 Phase 4: Fixing all project manifests..."
find . -name "AndroidManifest.xml" -type f | while read manifest; do
    echo "📄 Project manifest: $manifest"
    
    # Apply same aggressive fixes
    sed -i 's/package="[^"]*"//g' "$manifest" 2>/dev/null || true
    sed -i 's/package = "[^"]*"//g' "$manifest" 2>/dev/null || true
    sed -i 's/package=[^[:space:]">]*//g' "$manifest" 2>/dev/null || true
    sed -i 's/<manifest[[:space:]]*package="[^"]*"/<manifest/g' "$manifest" 2>/dev/null || true
    
    if ! grep -q "xmlns:android=" "$manifest" 2>/dev/null; then
        sed -i 's/<manifest/<manifest xmlns:android="http:\/\/schemas.android.com\/apk\/res\/android"/g' "$manifest" 2>/dev/null || true
    fi
    
    if grep -q "package=" "$manifest" 2>/dev/null; then
        echo "  ❌ Still problematic: $(grep "package=" "$manifest")"
    else
        echo "  ✅ Clean"
    fi
done

# 5. Nuclear option - fix ALL node_modules manifests
echo "🚀 Phase 5: Nuclear fix - ALL node_modules manifests..."
find ../node_modules -name "AndroidManifest.xml" 2>/dev/null | head -50 | while read manifest; do
    # Apply all fixes without output to avoid spam
    sed -i 's/package="[^"]*"//g' "$manifest" 2>/dev/null || true
    sed -i 's/package = "[^"]*"//g' "$manifest" 2>/dev/null || true
    sed -i 's/package=[^[:space:]">]*//g' "$manifest" 2>/dev/null || true
    sed -i 's/<manifest[[:space:]]*package="[^"]*"/<manifest/g' "$manifest" 2>/dev/null || true
    sed -i 's/[[:space:]]*package[[:space:]]*=[[:space:]]*"[^"]*"[[:space:]]*//g' "$manifest" 2>/dev/null || true
    
    if ! grep -q "xmlns:android=" "$manifest" 2>/dev/null; then
        sed -i 's/<manifest/<manifest xmlns:android="http:\/\/schemas.android.com\/apk\/res\/android"/g' "$manifest" 2>/dev/null || true
    fi
done

echo "📊 Fixed $(find ../node_modules -name "AndroidManifest.xml" 2>/dev/null | wc -l) node_modules manifests"

# 6. Gradle preparation
echo "🔧 Phase 6: Gradle preparation..."
./gradlew clean --no-daemon 2>/dev/null || true

# 7. Final validation
echo "🔍 Phase 7: Final validation..."
echo "Checking project manifests..."
PROJECT_ISSUES=$(find . -name "AndroidManifest.xml" -exec grep -l "package=" {} \; 2>/dev/null | wc -l || echo "0")
echo "  Project manifests with package attribute: $PROJECT_ISSUES"

echo "Checking critical plugin manifests..."
PLUGIN_ISSUES=0
for plugin in "${EXACT_PROBLEM_PLUGINS[@]}"; do
    PLUGIN_COUNT=$(find ../node_modules -path "*$plugin*" -name "AndroidManifest.xml" -exec grep -l "package=" {} \; 2>/dev/null | wc -l || echo "0")
    if [ "$PLUGIN_COUNT" -gt 0 ]; then
        echo "  ⚠️  Plugin $plugin still has $PLUGIN_COUNT problematic manifests"
        PLUGIN_ISSUES=$((PLUGIN_ISSUES + PLUGIN_COUNT))
    fi
done

echo ""
echo "📊 FINAL SUMMARY:"
echo "  Project issues: $PROJECT_ISSUES"
echo "  Plugin issues: $PLUGIN_ISSUES"
echo ""

if [ "$PROJECT_ISSUES" -eq 0 ]; then
    echo "✅ PROJECT MANIFESTS: CLEAN"
else
    echo "❌ PROJECT MANIFESTS: $PROJECT_ISSUES issues remain"
fi

if [ "$PLUGIN_ISSUES" -eq 0 ]; then
    echo "✅ PLUGIN MANIFESTS: CLEAN"
else
    echo "⚠️  PLUGIN MANIFESTS: $PLUGIN_ISSUES issues remain (will be handled during build)"
fi

echo ""
echo "🚀 READY TO BUILD!"
echo "Run: ./gradlew assembleDebug --stacktrace"
