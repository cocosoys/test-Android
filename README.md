# SOYS App

[全流程教程：部署、开发、打包与 Web 热更新](docs/PROJECT_FULL_FLOW_GUIDE.md)

[English](README_EN.md) | 中文

SOYS App 是一个基于 Flutter 的移动端应用壳工程，定位为“原生 Flutter 基础能力 + H5 混合页面”的 App 模板。项目已经接入登录、注册、首页、消息、我的、设置、资料编辑、关于页、WebView、扫码、分享、推送、埋点、崩溃采集、应用更新、本地存储和多环境打包等基础能力。

## 当前状态

- Flutter 静态分析通过：`dart analyze`
- Flutter 测试通过：`flutter test`
- Android `dev` 调试包可构建并可在 MuMu 模拟器启动
- 首次启动流程：启动页 -> 用户协议与隐私政策 -> 登录页 -> 测试账号进入首页
- 已验证截图：`screenshots/soys_app_home_after_fix.png`

## 技术栈

- Flutter / Dart
- GetX：路由、依赖注入、状态管理
- Dio：网络请求
- SharedPreferences / SQLite / Hive：本地存储
- WebView：H5 混合页面
- Firebase Analytics / Crashlytics：埋点和崩溃采集
- JPush：推送能力
- Mobile Scanner：扫码
- Share Plus：系统分享

## 目录结构

```text
lib/
  app/                 路由、主题、翻译、全局绑定
  components/          通用 UI 组件
  core/                常量、网络、日志、权限、工具
  models/              数据模型
  pages/               业务页面
  services/            全局服务
assets/
  images/ icons/ lottie/ html/
android/               Android 工程
ios/                   iOS 工程
test/                  Flutter 测试
screenshots/           本地验证截图
```

## 环境要求

- Flutter SDK，项目当前使用 Dart SDK 约束：`^3.11.5`
- Android SDK
- JDK 17
- Android 模拟器或真机；本项目已在 MuMu 模拟器 Android 12 上验证

Windows 本机如果 `flutter` 包装命令不可用，可以使用 Flutter tools snapshot 方式运行：

```powershell
$env:ANDROID_HOME='D:\WorkTools\AndroidSDK'
$env:ANDROID_SDK_ROOT='D:\WorkTools\AndroidSDK'
C:\flutter\bin\cache\dart-sdk\bin\dart.exe C:\flutter\bin\cache\flutter_tools.snapshot <flutter-subcommand>
```

## 安装依赖

```bash
flutter pub get
```

## 运行

```bash
flutter run --flavor dev
```

指定 MuMu 模拟器设备：

```bash
flutter run --flavor dev -d emulator-5554
```

## 构建

```bash
flutter build apk --debug --flavor dev
flutter build apk --release --flavor prod
```

常用输出路径：

```text
build/app/outputs/flutter-apk/app-dev-debug.apk
```

## Android 渠道

| Flavor | 包名 | 说明 |
| --- | --- | --- |
| `dev` | `com.soys.app.test.dev` | 开发环境 |
| `qa` | `com.soys.app.test.test` | 测试环境；Gradle flavor 名不能使用 `test`，因此使用 `qa` |
| `staging` | `com.soys.app.test.staging` | 预发布环境 |
| `prod` | `com.soys.app.test` | 生产环境 |

Android flavor 只负责包名、应用名和 Android Manifest placeholder。Flutter 侧数据来源由 `lib/core/constants/env_config.dart` 中的 `currentEnvironmentName` 控制，默认值是 `local`。

## 验证命令

```bash
dart analyze
flutter test
flutter build apk --debug --flavor dev
```

MuMu 安装和启动示例：

```powershell
& 'C:\Program Files\Netease\MuMu\nx_device\12.0\shell\adb.exe' devices -l
& 'C:\Program Files\Netease\MuMu\nx_device\12.0\shell\adb.exe' -s emulator-5554 install -r build\app\outputs\flutter-apk\app-dev-debug.apk
& 'C:\Program Files\Netease\MuMu\nx_device\12.0\shell\adb.exe' -s emulator-5554 shell monkey -p com.soys.app.test.dev -c android.intent.category.LAUNCHER 1
```

## 登录与首页

- 首次启动会展示“用户协议与隐私政策”弹窗。
- `currentEnvironmentName = 'local'` 时登录、首页、消息、协议页和 H5 内容全部来自本地，不请求服务器。
- `currentEnvironmentName = 'dev'` 时登录、首页、消息、协议页和 H5 内容全部来自开发服务器。
- `currentEnvironmentName = 'prod'` 时登录、首页、消息、协议页和 H5 内容全部来自生产服务器，不再使用本地兜底数据。
- 首页本地内容位于 `lib/core/data/local_app_data.dart` 和 `assets/html/local_page.html`；`dev`/`prod` 首页配置来自 `/home/config`。

## 配置说明

环境配置位于：

```text
lib/core/constants/env_config.dart
```

当前环境字段：

```dart
static const currentEnvironmentName = 'local';
```

主要环境：

- `local`：本地测试环境，所有内容来自本地数据和本地 H5 资源。
- `dev`：开发环境，所有内容来自开发服务器。
- `prod`：生产环境，所有内容来自生产服务器。

兼容别名：`test`、`qa`、`staging` 会解析为 `dev`，`online`、`production` 会解析为 `prod`。

常用命令：

```bash
flutter run --flavor dev
flutter build apk --debug --flavor dev
flutter build apk --release --flavor prod
```

Android 签名配置读取 `android/local.properties` 中的可选字段：

```properties
storeFile=...
storePassword=...
keyAlias=...
keyPassword=...
```

未配置 release 签名时，release 构建会回退到 debug 签名，便于本地验证。

## 注意事项

- 不要在 `dev` 或 `prod` 的链路中添加本地兜底数据，否则会破坏“远程环境只来自服务器”的边界。
- JPush 需要配置真实 `jPushAppKey` 后才会启用完整推送能力。
- Firebase 相关能力需要对应平台配置文件后才能在目标环境启用。
- `qa` 是 Gradle flavor 名；不要改回 `test`，Gradle 不允许 flavor 名以 `test` 开头。
