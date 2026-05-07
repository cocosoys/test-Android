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
flutter build apk --debug --flavor qa
flutter build apk --debug --flavor staging
flutter build apk --debug --flavor prod
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
- 开发环境中“测试账号登录”支持本地兜底，便于没有后端服务时进入首页检查 UI。
- 生产环境不会启用本地测试账号兜底。
- 首页会优先请求 `/home/config`，接口不可用时使用本地兜底内容显示 Banner、功能入口和推荐列表。

## 配置说明

环境配置位于：

```text
lib/core/constants/env_config.dart
```

主要环境：

- `dev`
- `test`
- `staging`
- `prod`

Android 签名配置读取 `android/local.properties` 中的可选字段：

```properties
storeFile=...
storePassword=...
keyAlias=...
keyPassword=...
```

未配置 release 签名时，release 构建会回退到 debug 签名，便于本地验证。

## 注意事项

- 当前首页兜底数据用于开发/离线验证，接入真实后端后应由接口返回正式内容。
- JPush 需要配置真实 `jPushAppKey` 后才会启用完整推送能力。
- Firebase 相关能力需要对应平台配置文件后才能在目标环境启用。
- `qa` 是 Gradle flavor 名；不要改回 `test`，Gradle 不允许 flavor 名以 `test` 开头。
