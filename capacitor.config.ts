import { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  appId: 'com.vishal.whatsorder',
  appName: 'WhatsOrder',
  webDir: 'www',
  server: {
    androidScheme: 'https',
    allowNavigation: ['https://whats-order-osr3.vercel.app', 'https://whats-order-osr3.vercel.app/*'],
    cleartext: true,
    allowExternalUrls: true
  },
  android: {
    allowMixedContent: true,
    captureInput: true,
    webContentsDebuggingEnabled: true
  },
  plugins: {
    CapacitorBrowser: {
      presentationStyle: 'popover'
    },
    AdMob: {
      appId: 'ca-app-pub-5538218540896625~5131951256'
    }
  }
};

export default config;
