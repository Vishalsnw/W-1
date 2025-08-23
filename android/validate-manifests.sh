
#!/bin/bash
echo "🔍 Comprehensive AndroidManifest.xml Validation"
echo "================================================"

ERROR_COUNT=0
WARNING_COUNT=0
TOTAL_MANIFESTS=0

# Function to check a single manifest
check_manifest() {
    local manifest="$1"
    local location="$2"
    
    TOTAL_MANIFESTS=$((TOTAL_MANIFESTS + 1))
    echo "📄 [$location] Checking: $manifest"
    
    local has_errors=false
    
    # Check for package attribute
    if grep -q "package=" "$manifest" 2>/dev/null; then
        echo "  ❌ ERROR: Found package attribute"
        echo "    📍 LINE: $(grep -n "package=" "$manifest" 2>/dev/null | head -1)"
        ERROR_COUNT=$((ERROR_COUNT + 1))
        has_errors=true
    fi
    
    # Check for xmlns declaration
    if ! grep -q "xmlns:android=" "$manifest" 2>/dev/null; then
        echo "  ⚠️  WARNING: Missing xmlns:android declaration"
        WARNING_COUNT=$((WARNING_COUNT + 1))
    fi
    
    # Check XML validity if xmllint is available
    if command -v xmllint >/dev/null 2>&1; then
        if ! xmllint --noout "$manifest" 2>/dev/null; then
            echo "  ❌ ERROR: XML validation failed"
            echo "    📍 ERROR: $(xmllint "$manifest" 2>&1 | head -1)"
            ERROR_COUNT=$((ERROR_COUNT + 1))
            has_errors=true
        fi
    fi
    
    # Check for empty manifest
    if grep -q "<manifest[^>]*></manifest>" "$manifest" 2>/dev/null; then
        echo "  ⚠️  WARNING: Empty manifest tag"
        WARNING_COUNT=$((WARNING_COUNT + 1))
    fi
    
    if [ "$has_errors" = false ]; then
        echo "  ✅ OK"
    fi
    
    echo ""
}

echo "Checking project manifests..."
find . -name "AndroidManifest.xml" -type f | while read manifest; do
    check_manifest "$manifest" "PROJECT"
done

echo "Checking node_modules manifests (sample)..."
find ../node_modules -name "AndroidManifest.xml" 2>/dev/null | head -5 | while read manifest; do
    check_manifest "$manifest" "NODE_MODULES"
done

echo "================================================"
echo "📊 VALIDATION SUMMARY:"
echo "   Total manifests checked: $TOTAL_MANIFESTS"
echo "   Errors: $ERROR_COUNT"
echo "   Warnings: $WARNING_COUNT"
echo "================================================"

if [ "$ERROR_COUNT" -gt 0 ]; then
    echo "❌ Validation failed with $ERROR_COUNT errors"
    echo "🔧 Please run ./fix-all-build-issues.sh to fix these issues"
    exit 1
else
    echo "✅ All manifests passed validation!"
    if [ "$WARNING_COUNT" -gt 0 ]; then
        echo "⚠️  $WARNING_COUNT warnings found but build should proceed"
    fi
    exit 0
fi
