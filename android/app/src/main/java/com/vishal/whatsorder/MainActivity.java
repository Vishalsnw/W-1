package com.vishal.whatsorder;

import com.getcapacitor.BridgeActivity;
import com.getcapacitor.community.admob.AdMob;
import com.codetrixstudio.capacitor.GoogleAuth.GoogleAuth;
import io.capawesome.capacitorjs.plugins.firebase.crashlytics.FirebaseCrashlyticsPlugin;

public class MainActivity extends BridgeActivity {
    @Override
    public void onCreate(android.os.Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        try {
            // Register plugins
            registerPlugin(AdMob.class);
            registerPlugin(GoogleAuth.class);
            registerPlugin(FirebaseCrashlyticsPlugin.class);
        } catch (Exception e) {
            // Log error but don't crash the app
            android.util.Log.e("MainActivity", "Error registering plugins", e);
        }
    }
}