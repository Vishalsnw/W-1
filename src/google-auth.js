
import { GoogleAuth } from '@codetrix-studio/capacitor-google-auth';
import { Camera, CameraResultType, CameraSource } from '@capacitor/camera';
import { Filesystem, Directory } from '@capacitor/filesystem';
import { initializeCrashlytics, logEvent, recordException, setUserId } from './crashlytics.js';

// Initialize Google Auth
GoogleAuth.initialize({
  clientId: 'AIzaSyDToGbYrUKjqcVDcKuQKW--H2-grVBGJqg',
  scopes: ['profile', 'email'],
  grantOfflineAccess: true,
});

// Initialize Crashlytics
initializeCrashlytics();

// Google Sign In function
export async function signInWithGoogle() {
  try {
    await logEvent('Attempting Google Sign In');
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
    await GoogleAuth.signOut();
    console.log('Google Sign Out Success');
  } catch (error) {
    console.error('Google Sign Out Error:', error);
    throw error;
  }
}

// Camera/File Upload functions
export async function takePicture() {
  try {
    await logEvent('Attempting to take picture');
    const image = await Camera.getPhoto({
      quality: 90,
      allowEditing: true,
      resultType: CameraResultType.DataUrl,
      source: CameraSource.Camera
    });
    
    await logEvent('Picture taken successfully');
    return image.dataUrl;
  } catch (error) {
    console.error('Camera Error:', error);
    await recordException(error);
    await logEvent('Camera failed: ' + error.message);
    throw error;
  }
}

export async function selectFromGallery() {
  try {
    const image = await Camera.getPhoto({
      quality: 90,
      allowEditing: true,
      resultType: CameraResultType.DataUrl,
      source: CameraSource.Photos
    });
    
    return image.dataUrl;
  } catch (error) {
    console.error('Gallery Error:', error);
    throw error;
  }
}

// Example usage in your web app:
/*
// Add this to your existing web app JavaScript
document.addEventListener('DOMContentLoaded', function() {
  // Google Sign In button
  const googleSignInBtn = document.getElementById('google-signin-btn');
  if (googleSignInBtn) {
    googleSignInBtn.addEventListener('click', async () => {
      try {
        const result = await signInWithGoogle();
        // Handle successful sign in
        console.log('User signed in:', result.user);
      } catch (error) {
        console.error('Sign in failed:', error);
      }
    });
  }
  
  // Camera button
  const cameraBtn = document.getElementById('camera-btn');
  if (cameraBtn) {
    cameraBtn.addEventListener('click', async () => {
      try {
        const imageData = await takePicture();
        // Use the image data
        const imgElement = document.getElementById('captured-image');
        imgElement.src = imageData;
      } catch (error) {
        console.error('Camera failed:', error);
      }
    });
  }
});
*/
