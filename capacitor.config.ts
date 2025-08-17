import { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  appId: 'com.vishal.whatsorder',
  appName: 'WhatsOrder',
  webDir: 'www',
  server: {
    androidScheme: 'https',
    allowNavigation: ['https://whats-order-osr3.vercel.app', 'https://whats-order-osr3.vercel.app/*'],
    cleartext: true
  },
  android: {
    allowMixedContent: true,
    captureInput: true,
    webContentsDebuggingEnabled: true
  }
};

export default config;
