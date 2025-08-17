package com.vishal.whatsorder;

import android.os.Bundle;
import com.getcapacitor.BridgeActivity;
import com.getcapacitor.Bridge;

public class MainActivity extends BridgeActivity {
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        Bridge bridge = this.getBridge();
        bridge.getWebView().getSettings().setAllowFileAccess(true);
        bridge.getWebView().getSettings().setAllowFileAccessFromFileURLs(true);
        bridge.getWebView().getSettings().setAllowUniversalAccessFromFileURLs(true);
    }
}
