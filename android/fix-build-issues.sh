
#!/bin/bash

echo "🔧 Fixing Android build issues..."
echo "=================================="

# Make scripts executable
chmod +x check-manifests.sh
chmod +x fix-debug-dirs.sh
chmod +x validate-manifests.sh

# Clean build directories
echo "🧹 Cleaning build directories..."
rm -rf .gradle
rm -rf app/build
rm -rf */build
rm -rf build

# Fix debug directories
echo "🔧 Fixing debug source directories..."
./fix-debug-dirs.sh

# Fix manifests first
echo "🔧 Fixing manifests..."
chmod +x fix-manifests.sh
./fix-manifests.sh

# Validate manifests
echo "🔍 Validating manifests..."
./validate-manifests.sh

# Clean Gradle cache thoroughly  
echo "🧹 Cleaning Gradle cache..."
rm -rf ~/.gradle/caches/
rm -rf .gradle/
./gradlew clean --no-daemon --refresh-dependencies

# Force dependency refresh
echo "🔄 Syncing Gradle dependencies..."
./gradlew --refresh-dependencies --no-daemon --recompile-scripts

echo "✅ Build fix script completed!"
echo "Now try building with: ./gradlew assembleDebug --no-daemon"
