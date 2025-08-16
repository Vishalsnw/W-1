
package com.vishal.whatsorder;

import android.os.Bundle;
import com.getcapacitor.BridgeActivity;
import com.codetrixstudio.capacitor.GoogleAuth.GoogleAuth;

public class MainActivity extends BridgeActivity {
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        
        // Initialize plugins
        registerPlugin(GoogleAuth.class);
        
        // Enable file upload support in WebView
        bridge.getWebView().getSettings().setAllowFileAccess(true);
        bridge.getWebView().getSettings().setAllowFileAccessFromFileURLs(true);
        bridge.getWebView().getSettings().setAllowUniversalAccessFromFileURLs(true);
    }
}
