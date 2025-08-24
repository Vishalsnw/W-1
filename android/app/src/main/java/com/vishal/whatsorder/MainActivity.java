package com.vishal.whatsorder;

import com.getcapacitor.BridgeActivity;
import android.os.Bundle;
import android.widget.Button;
import android.widget.LinearLayout;

public class MainActivity extends BridgeActivity {

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // Add crash test button for Crashlytics testing
        Button crashButton = new Button(this);
        crashButton.setText("Test Crash");
        crashButton.setOnClickListener(view -> {
            throw new RuntimeException("Test Crash for Crashlytics"); // Force a crash
        });

        // Add button to layout
        LinearLayout layout = new LinearLayout(this);
        layout.addView(crashButton);
        setContentView(layout);
    }
}