// 中文：本文件集中维护应用运行环境，明确区分本地测试环境和线上环境的数据来源。
// English: This file centralizes app runtime environments and clearly separates local-test data from online server data.
//
// 中文：本地测试环境只读取本地内容，线上环境只读取服务器内容。
// English: The local-test environment reads local content only, while the online environment reads server content only.

/// 中文：环境类型用于在业务层判断数据应该来自本地还是服务器。
/// English: The environment type lets feature code decide whether data should come from local content or remote servers.
enum AppEnvironmentType { local, online }

/// 中文：单个运行环境的完整配置。
/// English: Complete configuration for one runtime environment.
class EnvConfig {
  final AppEnvironmentType type;
  final String name;
  final String label;
  final String baseUrl;
  final String wsUrl;
  final String siteUrl;
  final String termsUrl;
  final String privacyUrl;
  final String forgotPasswordUrl;
  final bool useLocalContent;
  final bool allowLocalTestLogin;
  final bool enableLog;
  final bool enableCrashReport;
  final bool enableAnalytics;
  final bool enableCache;
  final int connectTimeout;
  final int receiveTimeout;
  final String jPushAppKey;
  final String appStoreUrl;

  const EnvConfig({
    required this.type,
    required this.name,
    required this.label,
    required this.baseUrl,
    required this.wsUrl,
    required this.siteUrl,
    required this.termsUrl,
    required this.privacyUrl,
    required this.forgotPasswordUrl,
    required this.useLocalContent,
    required this.allowLocalTestLogin,
    this.enableLog = true,
    this.enableCrashReport = false,
    this.enableAnalytics = false,
    this.enableCache = true,
    this.connectTimeout = 15000,
    this.receiveTimeout = 15000,
    this.jPushAppKey = '',
    this.appStoreUrl = 'https://apps.apple.com/app/soys-app',
  });

  /// 中文：当前环境是否是本地测试环境。
  /// English: Whether the current environment is the local-test environment.
  bool get isLocal => type == AppEnvironmentType.local;

  /// 中文：当前环境是否是线上环境。
  /// English: Whether the current environment is the online environment.
  bool get isOnline => type == AppEnvironmentType.online;

  /// 中文：线上环境才允许业务层访问远程服务器。
  /// English: Only the online environment allows feature code to access remote servers.
  bool get useRemoteContent => !useLocalContent;
}

/// 中文：应用环境集合，默认从 `--dart-define=APP_ENV=...` 读取环境名。
/// English: App environment registry; the default environment is read from `--dart-define=APP_ENV=...`.
class Environments {
  Environments._();

  static const local = EnvConfig(
    type: AppEnvironmentType.local,
    name: 'local',
    label: '本地测试环境',
    baseUrl: '',
    wsUrl: '',
    siteUrl: 'asset://assets/html/local_page.html',
    termsUrl: 'asset://assets/html/local_page.html',
    privacyUrl: 'asset://assets/html/local_page.html',
    forgotPasswordUrl: 'asset://assets/html/local_page.html',
    useLocalContent: true,
    allowLocalTestLogin: true,
    enableLog: true,
    enableCrashReport: false,
    enableAnalytics: false,
    enableCache: false,
  );

  static const online = EnvConfig(
    type: AppEnvironmentType.online,
    name: 'online',
    label: '线上环境',
    baseUrl: 'https://api.soys.app',
    wsUrl: 'wss://ws.soys.app',
    siteUrl: 'https://soys.app',
    termsUrl: 'https://soys.app/terms',
    privacyUrl: 'https://soys.app/privacy',
    forgotPasswordUrl: 'https://soys.app/forgot-password',
    useLocalContent: false,
    allowLocalTestLogin: false,
    enableLog: false,
    enableCrashReport: true,
    enableAnalytics: true,
    enableCache: true,
  );

  static const _defaultName = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'local',
  );

  static EnvConfig _current = resolve(_defaultName);

  /// 中文：当前生效环境。
  /// English: The currently active environment.
  static EnvConfig get current => _current;

  /// 中文：运行时切换环境，主要用于测试和调试工具。
  /// English: Switches environment at runtime, mainly for tests and debugging tools.
  static void switchTo(EnvConfig env) {
    _current = env;
  }

  /// 中文：根据字符串解析环境，兼容历史上的 dev/test/staging/prod 命名。
  /// English: Resolves an environment from text and keeps compatibility with historical dev/test/staging/prod names.
  static EnvConfig resolve(String name) {
    switch (name.trim().toLowerCase()) {
      case 'online':
      case 'prod':
      case 'production':
      case 'server':
        return online;
      case 'local':
      case 'local_test':
      case 'local-test':
      case 'test':
      case 'dev':
      case 'staging':
      default:
        return local;
    }
  }
}
