
#!/bin/bash

echo "🔧 Creating missing debug source directories for Capacitor plugins..."

# Create debug directories for all plugins
PLUGINS=(
    "capacitor-android"
    "capacitor-community-admob"
    "capacitor-camera"
    "codetrix-studio-capacitor-google-auth"
    "capacitor-filesystem"
    "capacitor-cordova-android-plugins"
)

for plugin in "${PLUGINS[@]}"; do
    plugin_dir="$plugin"
    
    if [ -d "$plugin_dir" ]; then
        # Create debug java directory
        debug_java_dir="$plugin_dir/src/debug/java"
        if [ ! -d "$debug_java_dir" ]; then
            echo "Creating $debug_java_dir"
            mkdir -p "$debug_java_dir"
            echo "// Debug source directory placeholder" > "$debug_java_dir/.gitkeep"
        else
            echo "✓ $debug_java_dir already exists"
        fi
        
        # Create debug res directory
        debug_res_dir="$plugin_dir/src/debug/res"
        if [ ! -d "$debug_res_dir" ]; then
            echo "Creating $debug_res_dir"
            mkdir -p "$debug_res_dir"
            echo "// Debug resource directory placeholder" > "$debug_res_dir/.gitkeep"
        else
            echo "✓ $debug_res_dir already exists"
        fi
    fi
done

# Also check node_modules if it exists
if [ -d "../node_modules" ]; then
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
fi

echo "✅ Debug directories check complete"plete!"
#!/bin/bash
echo "🔧 Fixing debug source directories..."
echo "====================================="

# Ensure proper debug source directories exist
modules=("app" "capacitor-cordova-android-plugins")

for module in "${modules[@]}"; do
    if [ -d "$module" ]; then
        echo "📁 Processing module: $module"
        
        # Create debug directories if missing
        mkdir -p "$module/src/debug/java"
        mkdir -p "$module/src/debug/res"
        mkdir -p "$module/src/debug/assets"
        
        # Create empty .gitkeep files
        touch "$module/src/debug/java/.gitkeep"
        touch "$module/src/debug/res/.gitkeep" 
        touch "$module/src/debug/assets/.gitkeep"
        
        echo "  ✅ Debug directories created"
    else
        echo "  ⚠️  Module $module not found, skipping"
    fi
done

echo ""
echo "✅ Debug directory fix completed"
