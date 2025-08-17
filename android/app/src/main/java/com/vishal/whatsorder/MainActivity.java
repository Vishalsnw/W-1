
package com.vishal.whatsorder;

import android.os.Bundle;
import com.getcapacitor.BridgeActivity;
import com.getcapacitor.community.admob.AdMob;

public class MainActivity extends BridgeActivity {
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        
        // Register AdMob plugin
        registerPlugin(AdMob.class);
    }
}
