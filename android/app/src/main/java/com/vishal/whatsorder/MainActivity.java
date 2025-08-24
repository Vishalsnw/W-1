package com.vishal.whatsorder;

import android.os.Bundle;
import com.getcapacitor.BridgeActivity;
import com.getcapacitor.Plugin;
import com.getcapacitor.community.admob.AdMob;
import com.codetrixstudio.capacitor.GoogleAuth.GoogleAuth;

import java.util.ArrayList;

public class MainActivity extends BridgeActivity {
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // Initializes the Bridge and plugins to be used locally
        this.init(savedInstanceState, new ArrayList<Class<? extends Plugin>>() {{
            add(GoogleAuth.class);
            add(AdMob.class);
        }});
    }
}
