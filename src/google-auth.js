
import { GoogleAuth } from '@codetrix-studio/capacitor-google-auth';
import { Camera, CameraResultType, CameraSource } from '@capacitor/camera';
import { Filesystem, Directory } from '@capacitor/filesystem';
import { Capacitor } from '@capacitor/core';
import { initializeCrashlytics, logEvent, recordException, setUserId } from './crashlytics.js';

// Initialize Google Auth with error handling
async function initializeGoogleAuth() {
  try {
    if (Capacitor.isNativePlatform()) {
      await GoogleAuth.initialize({
        clientId: 'AIzaSyDToGbYrUKjqcVDcKuQKW--H2-grVBGJqg',
        scopes: ['profile', 'email'],
        grantOfflineAccess: true,
      });
      console.log('Google Auth initialized successfully');
    }
  } catch (error) {
    console.error('Failed to initialize Google Auth:', error);
    await recordException(error);
  }
}

// Initialize everything
async function initialize() {
  try {
    await initializeCrashlytics();
    await initializeGoogleAuth();
    await logEvent('App initialized successfully');
  } catch (error) {
    console.error('Failed to initialize app:', error);
    await recordException(error);
  }
}

// Call initialize
initialize();

// Google Sign In function
export async function signInWithGoogle() {
  try {
    await logEvent('Attempting Google Sign In');
    
    if (!Capacitor.isNativePlatform()) {
      throw new Error('Google Sign In only available on native platforms');
    }
    
    const result = await GoogleAuth.signIn();
    console.log('Google Sign In Success:', result);
    
    // Set user ID for Crashlytics
    if (result.authentication && result.authentication.accessToken) {
      await setUserId(result.authentication.accessToken.substring(0, 10));
    }
    
    await logEvent('Google Sign In Success');
    return result;
  } catch (error) {
    console.error('Google Sign In Error:', error);
    await recordException(error);
    await logEvent('Google Sign In Failed: ' + error.message);
    throw error;
  }
}

// Google Sign Out function
export async function signOutFromGoogle() {
  try {
    if (Capacitor.isNativePlatform()) {
      await GoogleAuth.signOut();
      console.log('Google Sign Out Success');
      await logEvent('Google Sign Out Success');
    }
  } catch (error) {
    console.error('Google Sign Out Error:', error);
    await recordException(error);
    throw error;
  }
}

// Camera functions with error handling
export async function takePicture() {
  try {
    await logEvent('Taking picture');
    const image = await Camera.getPhoto({
      quality: 90,
      allowEditing: false,
      resultType: CameraResultType.DataUrl,
      source: CameraSource.Camera
    });
    
    await logEvent('Picture taken successfully');
    return image.dataUrl;
  } catch (error) {
    console.error('Camera error:', error);
    await recordException(error);
    throw error;
  }
}

export async function selectFromGallery() {
  try {
    await logEvent('Selecting from gallery');
    const image = await Camera.getPhoto({
      quality: 90,
      allowEditing: false,
      resultType: CameraResultType.DataUrl,
      source: CameraSource.Photos
    });
    
    await logEvent('Gallery selection successful');
    return image.dataUrl;
  } catch (error) {
    console.error('Gallery selection error:', error);
    await recordException(error);
    throw error;
  }
}
