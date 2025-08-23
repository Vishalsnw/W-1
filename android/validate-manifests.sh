
#!/bin/bash
echo "🔍 Validating AndroidManifest.xml files..."

ERROR_COUNT=0

find . -name "AndroidManifest.xml" -type f | while read manifest; do
    echo "📄 Checking: $manifest"
    
    # Check for package attribute
    if grep -q "package=" "$manifest"; then
        echo "  ❌ ERROR: Found package attribute in $manifest"
        grep -n "package=" "$manifest"
        ERROR_COUNT=$((ERROR_COUNT + 1))
    else
        echo "  ✅ No package attribute found"
    fi
    
    # Check XML validity
    if command -v xmllint >/dev/null 2>&1; then
        if xmllint --noout "$manifest" 2>/dev/null; then
            echo "  ✅ XML is valid"
        else
            echo "  ❌ XML validation failed"
            xmllint "$manifest" 2>&1 | head -3
            ERROR_COUNT=$((ERROR_COUNT + 1))
        fi
    fi
done

if [ "$ERROR_COUNT" -gt 0 ]; then
    echo "❌ Found $ERROR_COUNT manifest errors"
    exit 1
else
    echo "✅ All manifests are valid"
    exit 0
fi
