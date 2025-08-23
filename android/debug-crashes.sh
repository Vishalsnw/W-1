
#!/bin/bash
echo "🔍 Debugging Android App Crashes..."
echo "==================================="

# Check if ADB is available
if command -v adb >/dev/null 2>&1; then
    echo "📱 Checking connected devices..."
    adb devices
    echo ""
    
    echo "📋 Getting recent crash logs..."
    adb logcat -d | grep -E "(FATAL|AndroidRuntime|CRASH)" | tail -20
    echo ""
    
    echo "🔍 Checking for specific app crashes..."
    adb logcat -d | grep -E "(com.vishal.whatsorder|whatsorder)" | grep -E "(FATAL|ERROR|CRASH)" | tail -10
else
    echo "⚠️  ADB not available - install Android SDK tools to get detailed crash logs"
fi

echo ""
echo "📄 Checking manifest files..."
find . -name "AndroidManifest.xml" -exec grep -l "package=" {} \; | while read file; do
    echo "❌ Found package attribute in: $file"
done

echo ""
echo "🔧 Common crash fixes:"
echo "1. Make sure all plugins are properly initialized"
echo "2. Check Firebase configuration (google-services.json)"
echo "3. Verify all permissions in AndroidManifest.xml"
echo "4. Test on a physical device if using emulator"
echo "5. Check Gradle sync in Android Studio"
echo ""
echo "To get real-time crash logs, run: adb logcat | grep -E '(FATAL|AndroidRuntime|whatsorder)'"
