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
flutter run --flavor dev --dart-define=APP_ENV=local
```

Run on MuMu emulator:

```bash
flutter run --flavor dev -d emulator-5554 --dart-define=APP_ENV=local
```

## Build

```bash
flutter build apk --debug --flavor dev --dart-define=APP_ENV=local
flutter build apk --release --flavor prod --dart-define=APP_ENV=online
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

Android flavors only control package names, app names, and Android Manifest placeholders. Flutter-side data sources are controlled by `APP_ENV`; the default value is `local`.

## Verification

```bash
dart analyze
flutter test
flutter build apk --debug --flavor dev --dart-define=APP_ENV=local
```

MuMu install and launch example:

```powershell
& 'C:\Program Files\Netease\MuMu\nx_device\12.0\shell\adb.exe' devices -l
& 'C:\Program Files\Netease\MuMu\nx_device\12.0\shell\adb.exe' -s emulator-5554 install -r build\app\outputs\flutter-apk\app-dev-debug.apk
& 'C:\Program Files\Netease\MuMu\nx_device\12.0\shell\adb.exe' -s emulator-5554 shell monkey -p com.soys.app.test.dev -c android.intent.category.LAUNCHER 1
```

## Login And Home

- The first launch shows the user agreement and privacy policy dialog.
- With `APP_ENV=local`, login, home, messages, agreement pages, and H5 content all come from local data without server requests.
- With `APP_ENV=online`, login, home, messages, agreement pages, and H5 content all come from servers without local fallback data.
- Local home content lives in `lib/core/data/local_app_data.dart` and `assets/html/local_page.html`; online home configuration comes from `/home/config`.

## Configuration

Environment configuration:

```text
lib/core/constants/env_config.dart
```

Available environments:

- `local`: local-test environment; all content comes from local data and local H5 assets.
- `online`: online environment; all content comes from server APIs and online H5 URLs.

Compatibility aliases: `dev`, `test`, and `staging` resolve to `local`; `prod` and `production` resolve to `online`.

Common commands:

```bash
flutter run --flavor dev --dart-define=APP_ENV=local
flutter run --flavor prod --dart-define=APP_ENV=online
flutter build apk --release --flavor prod --dart-define=APP_ENV=online
```

Android release signing reads optional properties from `android/local.properties`:

```properties
storeFile=...
storePassword=...
keyAlias=...
keyPassword=...
```

If release signing is not configured, release builds fall back to debug signing for local verification.

## Notes

- Do not add local fallback data to the `APP_ENV=online` path, because online content must come only from servers.
- JPush requires a real `jPushAppKey` before full push capability is enabled.
- Firebase features require platform configuration files before they can be enabled in target environments.
- Keep the flavor name `qa`; do not rename it back to `test`, because Gradle disallows flavor names starting with `test`.
