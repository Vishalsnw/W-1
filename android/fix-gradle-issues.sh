
#!/bin/bash
echo "🔧 Fixing Gradle and Firebase issues..."
echo "======================================"

# Make scripts executable
chmod +x *.sh

# Clean all build artifacts
echo "🧹 Cleaning build directories..."
rm -rf .gradle
rm -rf app/build
rm -rf */build
rm -rf build
rm -rf ~/.gradle/caches/

# Fix manifests first
echo "🔧 Fixing AndroidManifest.xml files..."
./fix-all-build-issues.sh

# Refresh Gradle wrapper
echo "🔄 Refreshing Gradle wrapper..."
./gradlew wrapper --gradle-version=8.4 --distribution-type=bin

# Clean and refresh dependencies
echo "🔄 Syncing dependencies..."
./gradlew clean --refresh-dependencies --recompile-scripts

# Validate configuration
echo "🔍 Validating Gradle configuration..."
./gradlew tasks --all > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✅ Gradle configuration is valid"
else
    echo "❌ Gradle configuration has issues"
    echo "Running diagnostic..."
    ./gradlew help --stacktrace
fi

echo "✅ Gradle fix completed!"
echo "Now try: ./gradlew assembleDebug --stacktrace"
