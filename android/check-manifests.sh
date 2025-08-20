
#!/bin/bash
echo "🔍 Checking all AndroidManifest.xml files for issues..."

# Find all manifest files
find . -name "AndroidManifest.xml" -type f | while read manifest; do
    echo "📄 Checking: $manifest"
    
    # Check for package attribute (should not exist in AGP 8+)
    if grep -q "package=" "$manifest"; then
        echo "  ❌ Found package attribute: $(grep "package=" "$manifest")"
    else
        echo "  ✅ No package attribute found"
    fi
    
    # Check for basic XML validity
    if xmllint --noout "$manifest" 2>/dev/null; then
        echo "  ✅ XML is valid"
    else
        echo "  ❌ XML validation failed"
        xmllint "$manifest" 2>&1 | head -5
    fi
    
    echo "  📝 First 5 lines:"
    head -5 "$manifest" | sed 's/^/    /'
    echo ""
done
