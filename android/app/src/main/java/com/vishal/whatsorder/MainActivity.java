
package com.vishal.whatsorder;

import android.os.Bundle;
import com.getcapacitor.BridgeActivity;
import com.getcapacitor.Plugin;

import java.util.ArrayList;

import com.codetrixstudio.capacitor.GoogleAuth.GoogleAuth;
import com.getcapacitor.community.admob.AdMob;
import com.getcapacitor.plugin.camera.CameraPlugin;
import com.getcapacitor.plugin.filesystem.FilesystemPlugin;
import io.capawesome.capacitorjs.plugins.firebase.crashlytics.FirebaseCrashlytics;

public class MainActivity extends BridgeActivity {
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        
        // Initialize plugins
        this.init(savedInstanceState, new ArrayList<Class<? extends Plugin>>() {{
            add(GoogleAuth.class);
            add(AdMob.class);
            add(CameraPlugin.class);
            add(FilesystemPlugin.class);
            add(FirebaseCrashlytics.class);
        }});
    }
}
