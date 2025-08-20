
package com.codetrixstudio.capacitor.GoogleAuth;

import android.content.Intent;
import com.getcapacitor.JSObject;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;
import com.google.android.gms.auth.api.signin.GoogleSignIn;
import com.google.android.gms.auth.api.signin.GoogleSignInAccount;
import com.google.android.gms.auth.api.signin.GoogleSignInClient;
import com.google.android.gms.auth.api.signin.GoogleSignInOptions;
import com.google.android.gms.common.api.ApiException;
import com.google.android.gms.tasks.Task;

@CapacitorPlugin(name = "GoogleAuth")
public class GoogleAuth extends Plugin {

    private GoogleSignInClient mGoogleSignInClient;
    private static final int RC_SIGN_IN = 9001;

    @Override
    public void load() {
        super.load();
        // Initialize Google Sign-In
        GoogleSignInOptions gso = new GoogleSignInOptions.Builder(GoogleSignInOptions.DEFAULT_SIGN_IN)
                .requestEmail()
                .requestProfile()
                .build();
        
        mGoogleSignInClient = GoogleSignIn.getClient(getActivity(), gso);
    }

    @PluginMethod
    public void signIn(PluginCall call) {
        Intent signInIntent = mGoogleSignInClient.getSignInIntent();
        startActivityForResult(call, signInIntent, RC_SIGN_IN);
    }

    @PluginMethod
    public void signOut(PluginCall call) {
        mGoogleSignInClient.signOut()
                .addOnCompleteListener(getActivity(), task -> {
                    JSObject ret = new JSObject();
                    ret.put("success", true);
                    call.resolve(ret);
                });
    }

    @Override
    protected void handleOnActivityResult(int requestCode, int resultCode, Intent data) {
        super.handleOnActivityResult(requestCode, resultCode, data);
        
        if (requestCode == RC_SIGN_IN) {
            Task<GoogleSignInAccount> task = GoogleSignIn.getSignedInAccountFromIntent(data);
            handleSignInResult(task);
        }
    }

    private void handleSignInResult(Task<GoogleSignInAccount> completedTask) {
        try {
            GoogleSignInAccount account = completedTask.getResult(ApiException.class);
            JSObject ret = new JSObject();
            ret.put("success", true);
            JSObject user = new JSObject();
            user.put("id", account.getId());
            user.put("name", account.getDisplayName());
            user.put("email", account.getEmail());
            ret.put("user", user);
            
            PluginCall savedCall = getSavedCall();
            if (savedCall != null) {
                savedCall.resolve(ret);
            }
        } catch (ApiException e) {
            JSObject ret = new JSObject();
            ret.put("success", false);
            ret.put("error", e.getMessage());
            
            PluginCall savedCall = getSavedCall();
            if (savedCall != null) {
                savedCall.reject(e.getMessage());
            }
        }
    }
}
