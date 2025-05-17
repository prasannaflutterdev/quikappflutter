# QuikApp Flutter

A cross-platform Flutter mobile application with dynamic configuration and CI/CD using Codemagic.

## Features

- Dynamic configuration via API
- Feature toggles
- Push notifications (Firebase)
- Deep linking
- Pull-to-refresh
- Bottom navigation menu
- Loading indicators
- Permission handling
- Asset management
- Splash screen customization

## Setup

1. Clone the repository

```bash
git clone https://github.com/yourusername/quikappflutter.git
cd quikappflutter
```

2. Install dependencies

```bash
flutter pub get
```

3. Create a `.env` file in the root directory with your configuration:

```
APP_NAME=Your App Name
PKG_NAME=com.example.app
CONFIG_API_URL=https://your-api-endpoint.com/config
```

4. Set up Firebase (if using push notifications):

   - Create a Firebase project
   - Download `google-services.json` for Android
   - Download `GoogleService-Info.plist` for iOS
   - Host these files at publicly accessible URLs
   - Update the configuration API with the URLs

5. Set up signing configurations:
   - Generate keystore for Android
   - Generate certificates and provisioning profiles for iOS
   - Host these files at publicly accessible URLs
   - Update the configuration API with the URLs

## Configuration API

The app expects a JSON configuration from your API endpoint with the following structure:

```json
{
  "appId": "unique-app-id",
  "workflowId": "workflow-name",
  "branch": "main",
  "environment": {
    "variables": {
      "VERSION_NAME": "1.0.0",
      "VERSION_CODE": "1",
      "APP_NAME": "Your App Name",
      "PKG_NAME": "com.example.app",
      "BUNDLE_ID": "com.example.app",

      // Feature Toggles
      "PUSH_NOTIFY": "true",
      "IS_DEEPLINK": "true",
      "IS_SPLASH": "true"
      // ... other variables
    }
  }
}
```

## CI/CD with Codemagic

The project includes five Codemagic workflows:

1. **free-apk**: Builds debug APK
2. **paid-apk**: Builds obfuscated release APK
3. **release-apk-aab**: Builds signed APK and AAB
4. **release-ipa**: Builds signed IPA for iOS
5. **release-all**: Combined release of APK, AAB, and IPA

### Setting up Codemagic

1. Sign up for Codemagic
2. Connect your GitHub repository
3. Configure environment variables in Codemagic:
   - `GITHUB_TOKEN`: For publishing releases
   - Other signing credentials as needed

## Development

### Running the app

```bash
# Debug mode
flutter run

# Release mode
flutter run --release
```

### Building the app

```bash
# Android APK
flutter build apk

# Android App Bundle
flutter build appbundle

# iOS
flutter build ios
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
