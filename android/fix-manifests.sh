
#!/bin/bash
echo "🔧 Fixing all AndroidManifest.xml files..."
echo "=========================================="

# Make sure we're in the android directory
cd "$(dirname "$0")"

FIXED_COUNT=0

# Find all manifest files and fix them
find . -name "AndroidManifest.xml" -type f | while read manifest; do
    echo "📄 Processing: $manifest"
    
    # Create backup
    cp "$manifest" "$manifest.backup"
    
    # Remove package attributes (AGP 8+ doesn't support them)
    if grep -q "package=" "$manifest"; then
        echo "  🔧 Removing package attribute..."
        sed -i 's/ package="[^"]*"//g' "$manifest"
        sed -i 's/package="[^"]*" //g' "$manifest"
        FIXED_COUNT=$((FIXED_COUNT + 1))
    fi
    
    # Ensure proper xmlns declaration
    if ! grep -q "xmlns:android=" "$manifest"; then
        echo "  🔧 Adding xmlns:android declaration..."
        sed -i 's/<manifest/<manifest xmlns:android="http:\/\/schemas.android.com\/apk\/res\/android"/g' "$manifest"
        FIXED_COUNT=$((FIXED_COUNT + 1))
    fi
    
    # Fix empty manifest tags
    if grep -q "<manifest[^>]*></manifest>" "$manifest"; then
        echo "  🔧 Fixing empty manifest tag..."
        sed -i 's/<manifest\([^>]*\)><\/manifest>/<manifest\1>\n<\/manifest>/g' "$manifest"
    fi
    
    # Validate XML structure
    if command -v xmllint >/dev/null 2>&1; then
        if xmllint --noout "$manifest" 2>/dev/null; then
            echo "  ✅ XML is now valid"
            rm -f "$manifest.backup"
        else
            echo "  ❌ XML still invalid, restoring backup"
            mv "$manifest.backup" "$manifest"
        fi
    else
        echo "  ✅ Fixed (xmllint not available for validation)"
        rm -f "$manifest.backup"
    fi
done

echo ""
echo "🎯 Fixed $FIXED_COUNT manifest files"
echo "✅ All AndroidManifest.xml files have been processed"
