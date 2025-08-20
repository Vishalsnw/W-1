
#!/bin/bash

echo "🔧 Creating missing debug source directories for Capacitor plugins..."

# Find all main java directories in node_modules
find ../node_modules -type d -path "*/android/src/main/java" | while read main_java_dir; do
    # Convert main to debug path
    debug_java_dir="${main_java_dir/main/debug}"
    
    if [ ! -d "$debug_java_dir" ]; then
        echo "Creating $debug_java_dir"
        mkdir -p "$debug_java_dir"
        echo "// Debug source directory placeholder" > "$debug_java_dir/.gitkeep"
    else
        echo "✓ $debug_java_dir already exists"
    fi
done

echo "✅ Debug directories check complete!"
