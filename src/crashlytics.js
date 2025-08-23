
import { FirebaseCrashlytics } from '@capacitor-firebase/crashlytics';

// Initialize Crashlytics
export async function initializeCrashlytics() {
  try {
    await FirebaseCrashlytics.setEnabled({ enabled: true });
    console.log('Crashlytics initialized successfully');
  } catch (error) {
    console.error('Failed to initialize Crashlytics:', error);
  }
}

// Log custom events
export async function logEvent(message) {
  try {
    await FirebaseCrashlytics.log({ message });
  } catch (error) {
    console.error('Failed to log event:', error);
  }
}

// Set user identifier
export async function setUserId(userId) {
  try {
    await FirebaseCrashlytics.setUserId({ userId });
  } catch (error) {
    console.error('Failed to set user ID:', error);
  }
}

// Set custom attributes
export async function setCustomKey(key, value) {
  try {
    await FirebaseCrashlytics.setCustomKey({ key, value: String(value) });
  } catch (error) {
    console.error('Failed to set custom key:', error);
  }
}

// Record non-fatal errors
export async function recordException(error, isFatal = false) {
  try {
    await FirebaseCrashlytics.recordException({
      message: error.message || 'Unknown error',
      stacktrace: error.stack || 'No stack trace available'
    });
  } catch (crashlyticsError) {
    console.error('Failed to record exception:', crashlyticsError);
  }
}

// Crash the app intentionally (for testing only)
export async function crash() {
  try {
    await FirebaseCrashlytics.crash();
  } catch (error) {
    console.error('Failed to crash app:', error);
  }
}
