
#!/bin/bash
echo "🔍 Enhanced AndroidManifest.xml Validation"
echo "==========================================="

ERROR_COUNT=0
WARNING_COUNT=0
TOTAL_MANIFESTS=0

# Function to check a single manifest with detailed output
check_manifest() {
    local manifest="$1"
    local location="$2"
    
    TOTAL_MANIFESTS=$((TOTAL_MANIFESTS + 1))
    echo "📄 [$location] Checking: $manifest"
    
    local has_errors=false
    
    # Check for package attribute with detailed reporting
    if grep -q "package=" "$manifest" 2>/dev/null; then
        echo "  ❌ ERROR: Found package attribute"
        echo "    📍 EXACT LINES:"
        grep -n "package=" "$manifest" 2>/dev/null | head -3 | sed 's/^/      /'
        echo "    🔧 ISSUE: Package attributes not supported in AGP 8+"
        ERROR_COUNT=$((ERROR_COUNT + 1))
        has_errors=true
    fi
    
    # Check for xmlns declaration
    if ! grep -q "xmlns:android=" "$manifest" 2>/dev/null; then
        echo "  ⚠️  WARNING: Missing xmlns:android declaration"
        echo "    🔧 SUGGESTION: Add xmlns:android=\"http://schemas.android.com/apk/res/android\""
        WARNING_COUNT=$((WARNING_COUNT + 1))
    fi
    
    # Check XML validity with detailed error output
    if command -v xmllint >/dev/null 2>&1; then
        if ! xmllint --noout "$manifest" 2>/dev/null; then
            echo "  ❌ ERROR: XML validation failed"
            echo "    📍 XML ERRORS:"
            xmllint "$manifest" 2>&1 | head -3 | sed 's/^/      /'
            ERROR_COUNT=$((ERROR_COUNT + 1))
            has_errors=true
        fi
    fi
    
    # Check for common problematic patterns
    if grep -q "<manifest[[:space:]]*>" "$manifest" 2>/dev/null; then
        echo "  ⚠️  WARNING: Empty manifest tag (missing attributes)"
        WARNING_COUNT=$((WARNING_COUNT + 1))
    fi
    
    # Show first few lines for context
    if [ "$has_errors" = true ]; then
        echo "    📝 CONTEXT (first 3 lines):"
        head -3 "$manifest" 2>/dev/null | sed 's/^/      /' || echo "      [Could not read file]"
    else
        echo "  ✅ OK"
    fi
    
    echo ""
}

echo "Checking project manifests..."
find . -name "AndroidManifest.xml" -type f | while read manifest; do
    check_manifest "$manifest" "PROJECT"
done

echo "Checking critical plugin manifests..."
CRITICAL_PLUGINS=(
    "@capacitor/android"
    "@capacitor-community/admob"
    "@capacitor/camera" 
    "@codetrix-studio/capacitor-google-auth"
    "@capacitor/filesystem"
    "capacitor-cordova-android-plugins"
)

for plugin in "${CRITICAL_PLUGINS[@]}"; do
    echo "🔍 Checking plugin: $plugin"
    find ../node_modules -path "*$plugin*" -name "AndroidManifest.xml" 2>/dev/null | head -3 | while read manifest; do
        check_manifest "$manifest" "PLUGIN:$plugin"
    done
done

echo "Checking sample of other node_modules manifests..."
find ../node_modules -name "AndroidManifest.xml" 2>/dev/null | head -5 | while read manifest; do
    check_manifest "$manifest" "NODE_MODULES"
done

echo "================================================"
echo "📊 DETAILED VALIDATION SUMMARY:"
echo "   Total manifests checked: $TOTAL_MANIFESTS"
echo "   Errors: $ERROR_COUNT"
echo "   Warnings: $WARNING_COUNT"
echo "================================================"

if [ "$ERROR_COUNT" -gt 0 ]; then
    echo "❌ Validation failed with $ERROR_COUNT critical errors"
    echo "🔧 NEXT STEPS:"
    echo "   1. Run ./fix-all-build-issues.sh to fix these issues"
    echo "   2. Check the detailed error output above"
    echo "   3. Re-run this validation after fixes"
    exit 1
else
    echo "✅ All manifests passed validation!"
    if [ "$WARNING_COUNT" -gt 0 ]; then
        echo "⚠️  $WARNING_COUNT warnings found but build should proceed"
    fi
    echo "🚀 Ready to build: ./gradlew assembleDebug --stacktrace"
fi
