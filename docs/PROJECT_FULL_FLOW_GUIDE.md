# SOYS App 全流程教程：部署、开发、打包与 Web 热更新

本文面向第一次接手本项目的开发者，覆盖从本地部署、日常开发、模拟器调试、WebView/H5 混合开发、Web 热更新、Android 打包到发布前验证的完整流程。

## 1. 项目定位

SOYS App 是一个 Flutter 原生壳工程，核心定位是：

- Flutter 负责 App 壳、登录注册、主导航、原生能力、权限、推送、扫码、分享、本地存储、崩溃采集和版本更新。
- H5/Web 页面负责活动页、协议页、运营页、帮助页、表单页等可快速迭代的界面。
- WebView 作为 Flutter 与 H5 的桥接层，让部分界面可以按 Web 的方式上线和热更新。

需要先明确一个边界：Web 热更新只适用于 WebView 中加载的 H5 页面。Flutter 原生页面、原生权限、Android/iOS 配置、SDK 接入、App 图标、启动页、包名、签名、原生插件能力等内容仍然需要重新打包发布。

## 2. 推荐目录认知

```text
lib/
  app/                 路由、主题、多语言、全局绑定
  components/          通用 UI 组件
  core/                常量、网络、日志、权限、工具、异常
  models/              数据模型
  pages/               Flutter 原生页面
  services/            全局服务：认证、存储、WebView、推送、更新等
assets/
  html/                可放置内置 H5 静态页或兜底页
android/               Android 工程、渠道、签名、Manifest、原生入口
ios/                   iOS 工程
test/                  Flutter 测试
docs/                  项目教程和开发文档
```

关键文件：

| 文件 | 作用 |
| --- | --- |
| `lib/main.dart` | App 启动入口，初始化服务、主题、本地化和路由 |
| `lib/app/routes/app_routes.dart` | GetX 路由表，包含 `/webview` |
| `lib/pages/webview/webview_page.dart` | WebView 页面控制器和 UI |
| `lib/pages/webview/webview_binding.dart` | WebView 路由参数解析，读取 `title` 和 `url` |
| `lib/services/webview/webview_service.dart` | H5 与 Flutter 的 JS Bridge 服务 |
| `lib/core/constants/env_config.dart` | API 域名、日志、缓存、埋点等环境配置 |
| `android/app/build.gradle.kts` | Android flavor、签名、混淆和打包配置 |
| `pubspec.yaml` | Flutter 依赖和资源声明 |

## 3. 环境准备

### 3.1 必要工具

建议准备以下工具：

- Flutter SDK
- Dart SDK，随 Flutter 一起安装
- Android SDK
- JDK 17
- MuMu 模拟器或 Android 真机
- Git
- Node.js，开发 H5 页面时使用
- VS Code 或 Android Studio

本项目当前 `pubspec.yaml` 中声明的 Dart SDK 约束为：

```yaml
environment:
  sdk: ^3.11.5
```

如果本机 `flutter` 包装命令在 Windows 下异常，可以直接调用 Flutter tools snapshot：

```powershell
$env:ANDROID_HOME='D:\WorkTools\AndroidSDK'
$env:ANDROID_SDK_ROOT='D:\WorkTools\AndroidSDK'
C:\flutter\bin\cache\dart-sdk\bin\dart.exe C:\flutter\bin\cache\flutter_tools.snapshot doctor
```

后文为了简洁主要写 `flutter` 命令。如果你的本机 `flutter` 命令不可用，就把命令替换为：

```powershell
C:\flutter\bin\cache\dart-sdk\bin\dart.exe C:\flutter\bin\cache\flutter_tools.snapshot <subcommand>
```

例如：

```powershell
C:\flutter\bin\cache\dart-sdk\bin\dart.exe C:\flutter\bin\cache\flutter_tools.snapshot analyze
```

### 3.2 检查 Flutter 环境

```bash
flutter doctor
flutter --version
dart --version
```

如果 `flutter doctor` 报 Android SDK 或 JDK 问题，先修复环境，不要直接进入业务开发。构建失败很多时候不是代码问题，而是 SDK、JDK、Gradle 缓存或环境变量未配置。

### 3.3 安装依赖

在项目根目录执行：

```bash
flutter pub get
```

依赖安装成功后，应生成或更新：

```text
.dart_tool/
pubspec.lock
.flutter-plugins-dependencies
```

这些文件中 `.dart_tool/` 是本地工具缓存，不需要手工改。

## 4. 本地部署到 MuMu 模拟器

### 4.1 确认 MuMu adb 设备

MuMu 模拟器常见 adb 路径如下，具体以本机安装路径为准：

```powershell
& 'C:\Program Files\Netease\MuMu\nx_device\12.0\shell\adb.exe' devices -l
```

看到类似下面的设备即表示模拟器已连接：

```text
emulator-5554 device
```

如果 Flutter 能识别设备：

```bash
flutter devices
```

### 4.2 直接运行开发包

```bash
flutter run --flavor dev -d emulator-5554
```

如果设备 ID 不同，先用 `flutter devices` 或 MuMu adb 查询，再替换 `emulator-5554`。

### 4.3 构建 APK 后手动安装

构建 dev 调试包：

```bash
flutter build apk --debug --flavor dev
```

常见输出路径：

```text
build/app/outputs/flutter-apk/app-dev-debug.apk
```

安装到 MuMu：

```powershell
& 'C:\Program Files\Netease\MuMu\nx_device\12.0\shell\adb.exe' -s emulator-5554 install -r build\app\outputs\flutter-apk\app-dev-debug.apk
```

启动 App：

```powershell
& 'C:\Program Files\Netease\MuMu\nx_device\12.0\shell\adb.exe' -s emulator-5554 shell monkey -p com.soys.app.test.dev -c android.intent.category.LAUNCHER 1
```

dev 包名来自 `android/app/build.gradle.kts`：

```text
default applicationId: com.soys.app.test
dev suffix: .dev
dev package: com.soys.app.test.dev
```

## 5. 日常 Flutter 开发流程

### 5.1 启动开发

常规流程：

```bash
flutter pub get
flutter analyze
flutter test
flutter run --flavor dev
```

开发时使用 Flutter 热重载：

- 保存代码后按 `r`：Hot reload，适合 UI 和大多数 Dart 逻辑调整。
- 按 `R`：Hot restart，适合重新跑初始化流程。
- 停止后重跑：适合改了依赖、资源、原生配置、Manifest、Gradle、iOS/Android 原生代码。

### 5.2 新增 Flutter 页面

推荐按现有 GetX 结构新增页面：

```text
lib/pages/example/
  example_page.dart
  example_controller.dart
  example_binding.dart
```

然后在 `lib/app/routes/app_routes.dart` 中注册：

```dart
static const example = '/example';
```

并添加页面：

```dart
GetPage(
  name: AppRoutes.example,
  page: () => const ExamplePage(),
  binding: ExampleBinding(),
),
```

跳转方式：

```dart
Get.toNamed(AppRoutes.example);
```

如果页面需要登录态保护，可以复用或扩展 `AuthMiddleware`。

### 5.3 新增通用组件

通用 UI 放到 `lib/components/`，按用途拆分目录，例如：

```text
lib/components/cards/
lib/components/forms/
lib/components/nav/
```

原则：

- 页面内只放页面专属 UI。
- 多页面复用的按钮、输入框、弹窗、空状态、加载态应放入 `components/`。
- 不要为了一个页面过早抽象全局组件。

### 5.4 接口开发

网络层入口是：

```text
lib/core/network/http_service.dart
```

常见调用方式：

```dart
final response = await _http.get<UserModel>(
  '/user/profile',
  fromJson: (json) => UserModel.fromJson(json as Map<String, dynamic>),
);
```

接口模型放在：

```text
lib/models/
```

建议：

- 接口响应统一使用 `ApiResponse<T>`。
- 页面不要直接依赖 Dio。
- 页面控制器只关心业务结果，不处理底层网络错误细节。
- 需要兜底数据时，在 Controller 中明确写清楚 fallback 场景。

### 5.5 多语言开发

多语言入口：

```text
lib/app/translations/app_translations.dart
```

页面中使用：

```dart
Text('login'.tr)
```

新增文案时，要同步中文和英文键值。不要在页面中散落大量硬编码文案，除非是临时开发调试内容。

### 5.6 本地存储

本地存储服务：

```text
lib/services/storage/storage_service.dart
```

适合存：

- Token
- Refresh Token
- 用户信息
- 协议确认状态
- 主题模式
- 语言设置
- 少量本地配置

不要把大量业务列表直接塞进 SharedPreferences。需要结构化本地数据时，用 SQLite 或 Hive。

### 5.7 权限与系统能力

权限服务：

```text
lib/core/permission/permission_service.dart
```

扫码、相册、通知、定位、麦克风等能力都应先走权限服务，再调用具体业务能力。

Android 权限声明在：

```text
android/app/src/main/AndroidManifest.xml
```

增加新权限时，需要同时考虑：

- Android Manifest 是否声明。
- 运行时是否申请。
- iOS 是否需要在 `Info.plist` 增加用途说明。
- 是否会影响应用商店审核。

## 6. Android flavor 与环境配置

当前 Android 配置有 4 个 flavor：

| Flavor | 包名 | 说明 |
| --- | --- | --- |
| `dev` | `com.soys.app.test.dev` | 开发环境 |
| `qa` | `com.soys.app.test.test` | 测试环境。Gradle 不允许 flavor 名称使用 `test`，所以用 `qa` |
| `staging` | `com.soys.app.test.staging` | 预发布环境 |
| `prod` | `com.soys.app.test` | 生产环境 |

构建命令：

```bash
flutter build apk --debug --flavor dev
flutter build apk --debug --flavor qa
flutter build apk --debug --flavor staging
flutter build apk --debug --flavor prod
```

release 构建：

```bash
flutter build apk --release --flavor prod
flutter build appbundle --release --flavor prod
```

注意：当前 Android flavor 会影响包名、应用名和 Manifest placeholder，但 Flutter 侧环境配置目前在 `lib/core/constants/env_config.dart` 中通过 `Environments.current = dev` 默认指定。也就是说，如果没有额外接入 `--dart-define`，只切 Android flavor 不一定会自动切换 Flutter API 域名。

当前可用的保守方式：

```dart
static EnvConfig current = dev;
```

打生产包前手动确认它是否应切为：

```dart
static EnvConfig current = prod;
```

更推荐的长期方式是接入 `--dart-define`，例如：

```dart
static const _appEnv = String.fromEnvironment('APP_ENV', defaultValue: 'dev');

static EnvConfig get current {
  switch (_appEnv) {
    case 'prod':
      return prod;
    case 'staging':
      return staging;
    case 'test':
      return test;
    case 'dev':
    default:
      return dev;
  }
}
```

然后构建：

```bash
flutter build apk --release --flavor prod --dart-define=APP_ENV=prod
flutter build apk --debug --flavor qa --dart-define=APP_ENV=test
```

如果以后要做正式多环境发布，建议优先完成这个改造，避免“包名是生产，接口却还是开发环境”的风险。

## 7. WebView/H5 混合开发方式

### 7.1 当前项目的 WebView 入口

当前路由表中已有：

```text
/webview
```

绑定文件：

```text
lib/pages/webview/webview_binding.dart
```

它会读取两个参数：

- `title`：WebView 顶部标题。
- `url`：WebView 要加载的 H5 地址。

Flutter 中打开 H5：

```dart
Get.toNamed(
  '${AppRoutes.webview}?title=${Uri.encodeComponent('活动页')}'
  '&url=${Uri.encodeComponent('https://h5.example.com/activity')}',
);
```

也可以通过 `Get.arguments` 传参：

```dart
Get.toNamed(
  AppRoutes.webview,
  arguments: {
    'title': '活动页',
    'url': 'https://h5.example.com/activity',
  },
);
```

首页当前的功能入口也是通过 URL 打开 WebView。后端 `/home/config` 返回新的 H5 地址后，App 不需要发版就能打开新的运营页。

### 7.2 H5 页面适合承载什么

适合放到 H5 的内容：

- 活动页
- 公告页
- 帮助中心
- 协议页
- 运营配置页
- 轻表单
- 图文详情页
- 可快速调整布局的营销页面

不适合放到 H5 的内容：

- 需要高性能原生交互的复杂页面
- 深度依赖相机、蓝牙、定位、后台服务的页面
- 需要系统级权限或原生 SDK 的核心能力
- 启动页、登录主链路、支付核心链路等强稳定页面
- 对离线和弱网要求极高的核心页面

### 7.3 本地 H5 开发

可以把 H5 项目放在当前仓库外，也可以放在当前仓库下，例如：

```text
h5/
  package.json
  src/
  dist/
```

如果使用 Vite：

```bash
npm create vite@latest h5-demo -- --template vue-ts
cd h5-demo
npm install
npm run dev -- --host 0.0.0.0 --port 5173
```

如果只是静态 HTML：

```bash
npx http-server ./dist -p 5173 -a 0.0.0.0
```

本机浏览器访问：

```text
http://localhost:5173
```

模拟器访问宿主机时，一般尝试：

```text
http://10.0.2.2:5173
```

MuMu 模拟器如果无法访问 `10.0.2.2`，使用 Windows 局域网 IP：

```powershell
ipconfig
```

找到当前网卡 IPv4，例如：

```text
192.168.1.23
```

然后在模拟器 WebView 中访问：

```text
http://192.168.1.23:5173
```

如果本地 HTTP 页面无法加载，优先检查：

- Windows 防火墙是否允许 Node/Vite 端口。
- H5 dev server 是否用了 `--host 0.0.0.0`。
- 模拟器是否能访问宿主机 IP。
- Android 是否禁止明文 HTTP。

当前 `android/app/src/main/AndroidManifest.xml` 没有显式开启 `android:usesCleartextTraffic="true"`。如果只在开发期加载本地 HTTP，可以在 debug Manifest 或开发配置中临时开启。正式环境建议使用 HTTPS。

开发期示例：

```xml
<application
    android:usesCleartextTraffic="true"
    ...>
</application>
```

不要为了生产环境长期打开所有 HTTP 明文流量。

### 7.4 在 App 中打开本地 H5

开发时可以临时把首页兜底入口改为本机地址，例如：

```dart
{
  'title': '本地 H5',
  'icon': 'apps',
  'url': 'http://192.168.1.23:5173',
}
```

也可以在调试按钮中直接打开：

```dart
Get.toNamed(
  '${AppRoutes.webview}?title=${Uri.encodeComponent('本地 H5')}'
  '&url=${Uri.encodeComponent('http://192.168.1.23:5173')}',
);
```

开发阶段的工作流是：

1. 启动 H5 dev server。
2. 启动 Flutter App。
3. App WebView 打开本地 H5 地址。
4. 修改 H5 代码。
5. Vite/Web dev server 自动刷新页面。
6. 如果 WebView 没有自动刷新，点 App 右上角刷新按钮或调用 `controller.reload()`。

这就是“用 Web 的方式更新 App 界面”的开发体验。它不需要重新打 Flutter 包，但只影响 WebView 内的 H5 页面。

## 8. H5 与 Flutter 通信

### 8.1 Flutter 侧已有能力

当前项目中：

```text
lib/services/webview/webview_service.dart
```

定义了 JS Bridge 名称：

```dart
static const String jsBridgeName = 'SoysJSBridge';
```

WebView 页面通过 `addJavaScriptChannel` 接收 H5 消息。H5 发送的消息应包含：

```json
{
  "name": "事件名",
  "data": {}
}
```

Flutter 侧注册处理器：

```dart
final webViewService = Get.find<WebViewService>();

webViewService.registerHandler('openProfile', (data) {
  Get.toNamed(AppRoutes.profile);
});
```

### 8.2 H5 侧推荐封装

H5 中建议封装一个统一调用方法：

```js
export function callApp(name, data = {}) {
  const payload = JSON.stringify({ name, data });

  if (
    window.SoysJSBridge &&
    typeof window.SoysJSBridge.postMessage === 'function'
  ) {
    window.SoysJSBridge.postMessage(payload);
    return true;
  }

  console.warn('SOYS App bridge is not ready:', name, data);
  return false;
}
```

调用：

```js
callApp('openProfile', { from: 'h5-home' });
```

建议 H5 页面在调用 App 能力前判断桥是否存在。这样同一套 H5 页面也可以在普通浏览器中开发和预览，不会因为没有 App Bridge 直接报错。

### 8.3 Flutter 调用 H5

Flutter 控制器已有：

```dart
Future<void> callJS(String methodName, [dynamic args]) async
```

使用示例：

```dart
await controller.callJS('window.onAppResume', {'time': DateTime.now().toIso8601String()});
```

H5 侧定义：

```js
window.onAppResume = function (payload) {
  console.log('app resume:', payload);
};
```

需要注意参数序列化。生产环境建议 Flutter 调 H5 时使用 `jsonEncode` 传参，避免字符串拼接导致 JS 语法错误。

## 9. Web 热更新发布流程

### 9.1 基本原理

Web 热更新不是替换 APK，也不是修改 Flutter 代码。它的本质是：

1. App 内的 WebView 加载一个远程 URL。
2. H5 页面部署在服务器或 CDN 上。
3. 你更新服务器上的 H5 文件。
4. 用户下次打开 WebView 时看到新页面。

因此，只要页面入口 URL 不变，更新 H5 静态资源就可以改变 App 中 WebView 的界面。

### 9.2 推荐 H5 构建命令

以 Vite 项目为例：

```bash
npm install
npm run build
```

输出目录通常是：

```text
dist/
```

发布到服务器或 CDN：

```text
https://h5.example.com/soys/activity/
```

App 中打开：

```text
https://h5.example.com/soys/activity/index.html
```

### 9.3 版本和缓存策略

建议：

- `index.html` 不要强缓存，使用 `Cache-Control: no-cache` 或较短缓存。
- JS/CSS/图片使用带 hash 的文件名，例如 `app.8d31a2.js`。
- 入口 URL 可以加版本参数，例如 `?v=20260507_1`。
- CDN 发布后先灰度验证，再全量切流。

推荐服务器响应策略：

```text
index.html
Cache-Control: no-cache

assets/*.js
Cache-Control: public, max-age=31536000, immutable

assets/*.css
Cache-Control: public, max-age=31536000, immutable
```

入口 URL 示例：

```text
https://h5.example.com/soys/activity/index.html?v=20260507_1
```

如果页面使用 Service Worker，需要格外谨慎。Service Worker 可能让 WebView 长时间使用旧缓存。运营页如果没有离线诉求，通常不建议默认启用 Service Worker。

### 9.4 通过后端配置下发 H5 入口

当前首页会请求：

```text
/home/config
```

建议后端返回类似结构：

```json
{
  "code": 0,
  "message": "success",
  "data": {
    "banners": [
      {
        "title": "春节活动",
        "image": "https://cdn.example.com/banner/spring.png",
        "url": "https://h5.example.com/activity/spring/index.html?v=20260507_1"
      }
    ],
    "entries": [
      {
        "title": "活动专区",
        "icon": "campaign",
        "url": "https://h5.example.com/activity/index.html?v=20260507_1"
      }
    ]
  }
}
```

这样运营人员只要改后端配置中的 URL，就可以让 App 打开新的 H5 页面。

### 9.5 H5 发布前检查

发布 H5 前至少检查：

- 手机 WebView 分辨率下布局是否正常。
- Android 返回键和页面内部返回逻辑是否冲突。
- 首屏加载速度是否可接受。
- JS Bridge 不存在时页面是否仍可在浏览器中正常预览。
- 接口域名是否正确。
- HTTPS 证书是否有效。
- CDN 缓存是否按预期刷新。
- 灰度 URL 和生产 URL 是否区分。
- 埋点、错误日志、页面版本号是否可追踪。

## 10. App 打包流程

### 10.1 Debug 包

开发和本地验证：

```bash
flutter build apk --debug --flavor dev
```

输出：

```text
build/app/outputs/flutter-apk/app-dev-debug.apk
```

### 10.2 Release APK

生产 APK：

```bash
flutter build apk --release --flavor prod
```

输出一般位于：

```text
build/app/outputs/flutter-apk/app-prod-release.apk
```

### 10.3 Android App Bundle

上架 Google Play 通常使用 AAB：

```bash
flutter build appbundle --release --flavor prod
```

输出一般位于：

```text
build/app/outputs/bundle/prodRelease/app-prod-release.aab
```

### 10.4 Release 签名配置

Android 签名读取：

```text
android/local.properties
```

可选字段：

```properties
storeFile=D:\\keys\\soys_app.jks
storePassword=your-store-password
keyAlias=soys_app
keyPassword=your-key-password
```

如果没有配置 release keystore，当前 Gradle 脚本会回退到 debug 签名，方便本地构建验证。但正式发布不能使用 debug 签名。

正式发版前必须确认：

- `storeFile` 指向真实 release keystore。
- 密码不提交到 Git。
- `versionCode` 比线上版本更大。
- `versionName` 符合发布计划。
- 包名和 flavor 是生产包。

版本号在 `pubspec.yaml`：

```yaml
version: 1.0.0+1
```

含义：

- `1.0.0` 是 `versionName`。
- `1` 是 `versionCode`。

发新包时示例：

```yaml
version: 1.0.1+2
```

### 10.5 混淆与资源压缩

release 配置中已启用：

```kotlin
isMinifyEnabled = true
isShrinkResources = true
```

混淆规则：

```text
android/app/proguard-rules.pro
```

如果新增第三方 SDK 后 release 包崩溃，优先检查是否需要补 ProGuard keep 规则。

## 11. App 内更新流程

当前更新服务：

```text
lib/services/update/update_service.dart
```

检查接口：

```text
/app/version/check
```

请求参数：

```text
version=当前版本
platform=android 或 ios
```

后端建议返回：

```json
{
  "code": 0,
  "message": "success",
  "data": {
    "versionName": "1.0.1",
    "versionCode": 2,
    "downloadUrl": "https://download.example.com/soys/app-prod-release.apk",
    "updateContent": "修复已知问题，优化首页体验",
    "forceUpdate": false
  }
}
```

Android 会下载 APK 并调用系统安装入口。iOS 会打开 App Store 地址。

注意：App 内更新是安装新 APK，和 H5 热更新不是一回事。H5 热更新不改变 App 版本号；App 内更新会改变原生包版本。

## 12. 发布前验证清单

### 12.1 Flutter 验证

```bash
flutter analyze
flutter test
flutter build apk --release --flavor prod
```

如果使用直接 snapshot 命令：

```powershell
C:\flutter\bin\cache\dart-sdk\bin\dart.exe C:\flutter\bin\cache\flutter_tools.snapshot analyze
C:\flutter\bin\cache\dart-sdk\bin\dart.exe C:\flutter\bin\cache\flutter_tools.snapshot test
C:\flutter\bin\cache\dart-sdk\bin\dart.exe C:\flutter\bin\cache\flutter_tools.snapshot build apk --release --flavor prod
```

### 12.2 Android 真机或模拟器验证

至少覆盖：

- 首次启动协议弹窗。
- 测试账号登录。
- 首页 Banner 和功能入口。
- WebView 打开远程 H5。
- WebView 刷新。
- H5 调 Flutter Bridge。
- Flutter 调 H5 JS。
- 消息页、我的、资料编辑、设置、关于页。
- 扫码、分享、相册、通知等权限路径。
- 网络断开和接口失败时的兜底状态。
- App 内更新检查。

### 12.3 H5 热更新验证

至少覆盖：

- 本地浏览器预览。
- Android WebView 预览。
- CDN 灰度地址预览。
- 生产入口 URL 预览。
- 清缓存后预览。
- 弱网或断网场景。
- Android 返回键。
- 页面版本号和发布批次可追踪。

## 13. 常见问题

### 13.1 修改 Flutter UI 后没有变化

优先判断改的是哪类内容：

- 普通 Dart UI：按 `r` 热重载。
- 初始化逻辑：按 `R` 热重启。
- 资源、依赖、原生配置：停止后重新运行。
- Gradle、Manifest、原生代码：重新构建安装。

### 13.2 H5 本地页面在 WebView 中打不开

检查：

- H5 dev server 是否使用 `--host 0.0.0.0`。
- 模拟器是否能访问宿主机 IP。
- Windows 防火墙是否放行端口。
- Android 是否禁止 HTTP 明文流量。
- URL 是否写成了 `localhost`。模拟器中的 `localhost` 是模拟器自己，不是宿主机。

### 13.3 H5 已发布但 App 还是旧页面

检查：

- CDN 是否刷新。
- `index.html` 是否被强缓存。
- URL 是否带旧版本参数。
- WebView 是否缓存旧内容。
- 是否启用了 Service Worker。
- 后端 `/home/config` 是否仍然返回旧 URL。

### 13.4 flavor 切了但接口环境没切

这是当前项目需要特别注意的点。Android flavor 只保证 Android 包配置变化，不自动保证 Flutter API 环境变化。打包前检查：

```text
lib/core/constants/env_config.dart
```

长期建议接入 `--dart-define=APP_ENV=...`。

### 13.5 release 包安装失败

常见原因：

- 设备上已有同包名但签名不同的旧包。
- `versionCode` 没有递增。
- release keystore 配置错误。
- ABI 或 minSdk 与设备不兼容。

处理方式：

```powershell
adb uninstall com.soys.app.test
adb install app-prod-release.apk
```

生产用户不能靠卸载解决，所以正式发布前要保证签名连续、版本号递增。

## 14. 推荐团队工作流

开发 Flutter 原生功能：

```text
需求确认 -> 新增/修改页面 -> 接入服务和模型 -> 本地运行 -> analyze/test -> 模拟器验收 -> 打包验证
```

开发 H5 热更新页面：

```text
需求确认 -> H5 本地开发 -> 浏览器预览 -> WebView 预览 -> JS Bridge 验证 -> 构建 dist -> 灰度部署 -> 后端配置 URL -> App 验收 -> CDN 全量
```

发布原生 App：

```text
版本号递增 -> 环境确认 -> 签名确认 -> release 构建 -> 安装验证 -> 回归测试 -> 上传分发平台 -> 监控崩溃和更新反馈
```

发布 H5 热更新：

```text
构建 H5 -> 部署 CDN -> 灰度 URL 验证 -> 更新配置 URL 或刷新资源 -> App WebView 验证 -> 观察错误日志 -> 全量发布
```

## 15. 最小可用命令清单

```bash
flutter pub get
flutter analyze
flutter test
flutter run --flavor dev -d emulator-5554
flutter build apk --debug --flavor dev
flutter build apk --release --flavor prod
flutter build appbundle --release --flavor prod
```

MuMu：

```powershell
& 'C:\Program Files\Netease\MuMu\nx_device\12.0\shell\adb.exe' devices -l
& 'C:\Program Files\Netease\MuMu\nx_device\12.0\shell\adb.exe' -s emulator-5554 install -r build\app\outputs\flutter-apk\app-dev-debug.apk
& 'C:\Program Files\Netease\MuMu\nx_device\12.0\shell\adb.exe' -s emulator-5554 shell monkey -p com.soys.app.test.dev -c android.intent.category.LAUNCHER 1
```

H5 本地开发：

```bash
npm install
npm run dev -- --host 0.0.0.0 --port 5173
npm run build
```

H5 WebView 调试地址示例：

```text
http://10.0.2.2:5173
http://192.168.1.23:5173
https://h5.example.com/soys/activity/index.html?v=20260507_1
```

