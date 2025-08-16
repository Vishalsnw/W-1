
import { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  appId: 'com.vishal.whatsorder',
  appName: 'WhatsOrder',
  webDir: 'dist',
  server: {
    url: 'https://whats-order-osr3.vercel.app',
    cleartext: false
  },
  android: {
    scheme: 'https'
  },
  plugins: {
    GoogleAuth: {
      scopes: ['profile', 'email'],
      serverClientId: 'AIzaSyDToGbYrUKjqcVDcKuQKW--H2-grVBGJqg',
      forceCodeForRefreshToken: true
    },
    Camera: {
      permissions: ['camera', 'photos']
    }
  }
};

export default config;
