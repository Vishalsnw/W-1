
import { GoogleAuth } from '@codetrix-studio/capacitor-google-auth';
import { Camera, CameraResultType, CameraSource } from '@capacitor/camera';
import { Filesystem, Directory } from '@capacitor/filesystem';

// Initialize Google Auth
GoogleAuth.initialize({
  clientId: 'YOUR_FIREBASE_WEB_CLIENT_ID',
  scopes: ['profile', 'email'],
  grantOfflineAccess: true,
});

// Google Sign In function
export async function signInWithGoogle() {
  try {
    const result = await GoogleAuth.signIn();
    console.log('Google Sign In Success:', result);
    
    // You can now use result.authentication.idToken for Firebase auth
    return result;
  } catch (error) {
    console.error('Google Sign In Error:', error);
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
    const image = await Camera.getPhoto({
      quality: 90,
      allowEditing: true,
      resultType: CameraResultType.DataUrl,
      source: CameraSource.Camera
    });
    
    return image.dataUrl;
  } catch (error) {
    console.error('Camera Error:', error);
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
