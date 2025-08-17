import { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  appId: 'com.vishal.whatsorder',
  appName: 'WhatsOrder',
  webDir: 'www',
  server: {
    androidScheme: 'https',
    allowNavigation: ['https://whats-order-osr3.vercel.app']
  },
  android: {
    allowMixedContent: true,
    captureInput: true
  }
};

export default config;
