
#!/bin/bash
echo "🔍 Checking all AndroidManifest.xml files for issues..."
echo "========================================="

ERROR_COUNT=0
WARNING_COUNT=0

# Find all manifest files
find . -name "AndroidManifest.xml" -type f | while read manifest; do
    echo "📄 Checking: $manifest"
    
    # Check for package attribute (should not exist in AGP 8+)
    if grep -q "package=" "$manifest"; then
        echo "  ❌ ERROR: Found package attribute: $(grep "package=" "$manifest")"
        echo "    📍 EXACT LINE: $(grep -n "package=" "$manifest")"
        echo "    🔧 FIX: Remove package attribute from manifest tag"
        ERROR_COUNT=$((ERROR_COUNT + 1))
    else
        echo "  ✅ No package attribute found"
    fi
    
    # Check for basic XML validity (skip if xmllint not available)
    if command -v xmllint >/dev/null 2>&1; then
        if xmllint --noout "$manifest" 2>/dev/null; then
            echo "  ✅ XML is valid"
        else
            echo "  ❌ ERROR: XML validation failed"
            echo "    📍 EXACT ERROR:"
            xmllint "$manifest" 2>&1 | head -5 | sed 's/^/      /'
            ERROR_COUNT=$((ERROR_COUNT + 1))
        fi
    else
        echo "  ✅ XML validation skipped (xmllint not available)"
    fi
    
    # Check for missing xmlns declaration
    if ! grep -q "xmlns:android" "$manifest"; then
        echo "  ⚠️  WARNING: Missing xmlns:android declaration"
        WARNING_COUNT=$((WARNING_COUNT + 1))
    else
        echo "  ✅ xmlns:android declaration found"
    fi
    
    # Check for empty manifest tags
    if grep -q "<manifest[^>]*></manifest>" "$manifest"; then
        echo "  ⚠️  WARNING: Empty manifest tag found"
        WARNING_COUNT=$((WARNING_COUNT + 1))
    fi
    
    echo "  📝 First 5 lines:"
    head -5 "$manifest" | sed 's/^/    /'
    echo ""
done

echo "========================================="
echo "📊 MANIFEST CHECK SUMMARY:"
echo "   Errors: $ERROR_COUNT"
echo "   Warnings: $WARNING_COUNT"
echo "========================================="

if [ "$ERROR_COUNT" -gt 0 ]; then
    echo "❌ Manifest validation failed with $ERROR_COUNT errors"
    echo "🔧 Please fix the above errors before building"
    exit 1
else
    echo "✅ All manifests are valid"
    exit 0
fiT=0

# Find all manifest files
find . -name "AndroidManifest.xml" -type f | while read manifest; do
    echo "📄 Checking: $manifest"
    
    # Check for package attribute (should not exist in AGP 8+)
    if grep -q "package=" "$manifest"; then
        echo "  ❌ ERROR: Found package attribute: $(grep "package=" "$manifest")"
        echo "    📍 EXACT LINE: $(grep -n "package=" "$manifest")"
        echo "    🔧 FIX: Remove package attribute from manifest tag"
        ERROR_COUNT=$((ERROR_COUNT + 1))
    else
        echo "  ✅ No package attribute found"
    fi
    
    # Check for basic XML validity (skip if xmllint not available)
    if command -v xmllint >/dev/null 2>&1; then
        if xmllint --noout "$manifest" 2>/dev/null; then
            echo "  ✅ XML is valid"
        else
            echo "  ❌ ERROR: XML validation failed"
            echo "    📍 EXACT ERROR:"
            xmllint "$manifest" 2>&1 | head -5 | sed 's/^/      /'
            ERROR_COUNT=$((ERROR_COUNT + 1))
        fi
    else
        echo "  ✅ XML validation skipped (xmllint not available)"
    fi
    
    # Check for missing xmlns declaration
    if ! grep -q "xmlns:android" "$manifest"; then
        echo "  ⚠️  WARNING: Missing xmlns:android declaration"
        WARNING_COUNT=$((WARNING_COUNT + 1))
    else
        echo "  ✅ xmlns:android declaration found"
    fi
    
    # Check for empty manifest tags
    if grep -q "<manifest[^>]*></manifest>" "$manifest"; then
        echo "  ⚠️  WARNING: Empty manifest tag found"
        WARNING_COUNT=$((WARNING_COUNT + 1))
    fi
    
    echo "  📝 First 5 lines:"
    head -5 "$manifest" | sed 's/^/    /'
    echo ""
done

echo "========================================="
echo "📊 MANIFEST CHECK SUMMARY:"
echo "   Errors: $ERROR_COUNT"
echo "   Warnings: $WARNING_COUNT"
echo "========================================="

if [ "$ERROR_COUNT" -gt 0 ]; then
    echo "❌ Manifest validation failed with $ERROR_COUNT errors"
    echo "🔧 Please fix the above errors before building"
    exit 1
else
    echo "✅ All manifest files are valid"
fi
