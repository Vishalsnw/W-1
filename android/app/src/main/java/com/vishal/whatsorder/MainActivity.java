
package com.vishal.whatsorder;

import android.os.Bundle;
import com.getcapacitor.BridgeActivity;
import com.getcapacitor.community.admob.AdMob;
import com.capacitorjs.plugins.camera.CameraPlugin;
import com.capacitorjs.plugins.filesystem.FilesystemPlugin;
import com.codetrixstudio.capacitor.GoogleAuth.GoogleAuth;

public class MainActivity extends BridgeActivity {
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        
        // Register all plugins
        registerPlugin(AdMob.class);
        registerPlugin(CameraPlugin.class);
        registerPlugin(FilesystemPlugin.class);
        registerPlugin(GoogleAuth.class);
    }
}
