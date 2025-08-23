
import { FirebaseCrashlytics } from '@capacitor-firebase/crashlytics';
import { Capacitor } from '@capacitor/core';

// Initialize Crashlytics
export async function initializeCrashlytics() {
  try {
    // Only initialize on native platforms
    if (Capacitor.isNativePlatform()) {
      await FirebaseCrashlytics.setEnabled({ enabled: true });
      console.log('Crashlytics initialized successfully');
      
      // Test crashlytics is working
      await FirebaseCrashlytics.log({ message: 'Crashlytics initialized' });
    } else {
      console.log('Crashlytics skipped - not on native platform');
    }
  } catch (error) {
    console.error('Failed to initialize Crashlytics:', error);
  }
}

// Log custom events
export async function logEvent(message) {
  try {
    if (Capacitor.isNativePlatform()) {
      await FirebaseCrashlytics.log({ message });
    }
  } catch (error) {
    console.error('Failed to log event:', error);
  }
}

// Set user identifier
export async function setUserId(userId) {
  try {
    if (Capacitor.isNativePlatform()) {
      await FirebaseCrashlytics.setUserId({ userId });
    }
  } catch (error) {
    console.error('Failed to set user ID:', error);
  }
}

// Set custom attributes
export async function setCustomKey(key, value) {
  try {
    if (Capacitor.isNativePlatform()) {
      await FirebaseCrashlytics.setCustomKey({ key, value: String(value) });
    }
  } catch (error) {
    console.error('Failed to set custom key:', error);
  }
}

// Record non-fatal errors
export async function recordException(error, isFatal = false) {
  try {
    if (Capacitor.isNativePlatform()) {
      await FirebaseCrashlytics.recordException({
        message: error.message || 'Unknown error',
        stacktrace: error.stack || 'No stack trace available'
      });
    }
    console.error('Exception recorded:', error);
  } catch (crashlyticsError) {
    console.error('Failed to record exception:', crashlyticsError);
  }
}

// Crash the app intentionally (for testing only)
export async function crash() {
  try {
    if (Capacitor.isNativePlatform()) {
      await FirebaseCrashlytics.crash();
    }
  } catch (error) {
    console.error('Failed to crash app:', error);
  }
}
