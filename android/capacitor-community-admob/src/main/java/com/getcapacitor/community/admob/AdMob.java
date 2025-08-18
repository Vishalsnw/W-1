
package com.getcapacitor.community.admob;

import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;

@CapacitorPlugin(name = "AdMob")
public class AdMob extends Plugin {

    @PluginMethod
    public void initialize(PluginCall call) {
        call.resolve();
    }

    @PluginMethod
    public void showBanner(PluginCall call) {
        call.resolve();
    }

    @PluginMethod
    public void hideBanner(PluginCall call) {
        call.resolve();
    }

    @PluginMethod
    public void prepareInterstitial(PluginCall call) {
        call.resolve();
    }

    @PluginMethod
    public void showInterstitial(PluginCall call) {
        call.resolve();
    }
}
