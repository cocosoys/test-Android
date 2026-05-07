# SOYS App

English | [中文](README.md)

SOYS App is a Flutter mobile app shell designed for a hybrid architecture: native Flutter app capabilities plus H5 pages through WebView. It includes common app features such as authentication, registration, home, messages, profile, settings, about, WebView, scanner, share, push, analytics, crash reporting, app update, local storage, and multi-flavor Android packaging.

## Current Status

- Static analysis passes: `dart analyze`
- Flutter tests pass: `flutter test`
- Android `dev` debug APK builds and runs on MuMu emulator
- First-launch flow: splash -> agreement dialog -> login -> test account -> home
- Verified screenshot: `screenshots/soys_app_home_after_fix.png`

## Tech Stack

- Flutter / Dart
- GetX for routing, dependency injection, and state management
- Dio for HTTP requests
- SharedPreferences / SQLite / Hive for local storage
- WebView for H5 hybrid pages
- Firebase Analytics / Crashlytics for analytics and crash reporting
- JPush for push notifications
- Mobile Scanner for scanning
- Share Plus for system sharing

## Project Structure

```text
lib/
  app/                 routes, theme, translations, global bindings
  components/          shared UI components
  core/                constants, network, logging, permissions, utilities
  models/              data models
  pages/               feature pages
  services/            global services
assets/
  images/ icons/ lottie/ html/
android/               Android project
ios/                   iOS project
test/                  Flutter tests
screenshots/           local verification screenshots
```

## Requirements

- Flutter SDK. The Dart SDK constraint is `^3.11.5`
- Android SDK
- JDK 17
- Android emulator or physical device. The project has been verified on MuMu emulator with Android 12.

If the `flutter` wrapper command is unavailable on Windows, you can invoke Flutter tools through the snapshot:

```powershell
$env:ANDROID_HOME='D:\WorkTools\AndroidSDK'
$env:ANDROID_SDK_ROOT='D:\WorkTools\AndroidSDK'
C:\flutter\bin\cache\dart-sdk\bin\dart.exe C:\flutter\bin\cache\flutter_tools.snapshot <flutter-subcommand>
```

## Install Dependencies

```bash
flutter pub get
```

## Run

```bash
flutter run --flavor dev
```

Run on MuMu emulator:

```bash
flutter run --flavor dev -d emulator-5554
```

## Build

```bash
flutter build apk --debug --flavor dev
flutter build apk --debug --flavor qa
flutter build apk --debug --flavor staging
flutter build apk --debug --flavor prod
```

Common output path:

```text
build/app/outputs/flutter-apk/app-dev-debug.apk
```

## Android Flavors

| Flavor | Package name | Purpose |
| --- | --- | --- |
| `dev` | `com.soys.app.test.dev` | Development |
| `qa` | `com.soys.app.test.test` | Test environment. The Gradle flavor is named `qa` because Gradle does not allow flavor names starting with `test`. |
| `staging` | `com.soys.app.test.staging` | Staging |
| `prod` | `com.soys.app.test` | Production |

## Verification

```bash
dart analyze
flutter test
flutter build apk --debug --flavor dev
```

MuMu install and launch example:

```powershell
& 'C:\Program Files\Netease\MuMu\nx_device\12.0\shell\adb.exe' devices -l
& 'C:\Program Files\Netease\MuMu\nx_device\12.0\shell\adb.exe' -s emulator-5554 install -r build\app\outputs\flutter-apk\app-dev-debug.apk
& 'C:\Program Files\Netease\MuMu\nx_device\12.0\shell\adb.exe' -s emulator-5554 shell monkey -p com.soys.app.test.dev -c android.intent.category.LAUNCHER 1
```

## Login And Home

- The first launch shows the user agreement and privacy policy dialog.
- In non-production environments, the test account login has a local fallback so developers can enter the home page without a backend service.
- Production does not use the local test-account fallback.
- The home page first requests `/home/config`; if the API is unavailable, local fallback content is used for banners, entries, and recommendations.

## Configuration

Environment configuration:

```text
lib/core/constants/env_config.dart
```

Available environments:

- `dev`
- `test`
- `staging`
- `prod`

Android release signing reads optional properties from `android/local.properties`:

```properties
storeFile=...
storePassword=...
keyAlias=...
keyPassword=...
```

If release signing is not configured, release builds fall back to debug signing for local verification.

## Notes

- Home fallback data is intended for development and offline verification. Production content should come from backend APIs.
- JPush requires a real `jPushAppKey` before full push capability is enabled.
- Firebase features require platform configuration files before they can be enabled in target environments.
- Keep the flavor name `qa`; do not rename it back to `test`, because Gradle disallows flavor names starting with `test`.
