// 中文：本文件集中维护应用运行环境，明确区分 dev、local、prod 三套环境的数据来源。
// English: This file centralizes app runtime environments and separates data sources for dev, local, and prod.
//
// 中文：当前生效环境也在本文件中配置，保持环境配置只有一个入口。
// English: The active environment is configured in this file too, keeping environment config in one place.

/// 中文：环境类型用于在业务层判断数据应该来自本地还是服务器。
/// English: The environment type lets feature code decide whether data should come from local content or remote servers.
enum AppEnvironmentType { dev, local, prod }

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
  final bool showTestAccountLogin;
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
    required this.showTestAccountLogin,
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

  /// 中文：当前环境是否是开发服务器环境。
  /// English: Whether the current environment is the development-server environment.
  bool get isDev => type == AppEnvironmentType.dev;

  /// 中文：当前环境是否是本地测试环境。
  /// English: Whether the current environment is the local-test environment.
  bool get isLocal => type == AppEnvironmentType.local;

  /// 中文：当前环境是否是生产环境。
  /// English: Whether the current environment is the production environment.
  bool get isProd => type == AppEnvironmentType.prod;

  /// 中文：兼容旧命名；当前等同于生产环境判断。
  /// English: Compatibility alias for older naming; currently equivalent to production.
  bool get isOnline => isProd;

  /// 中文：dev 和 prod 环境才允许业务层访问远程服务器。
  /// English: Only dev and prod environments allow feature code to access remote servers.
  bool get useRemoteContent => !useLocalContent;
}

/// 中文：应用环境集合；修改 currentEnvironmentName 即可切换当前环境。
/// English: App environment registry; change currentEnvironmentName to switch the active environment.
class Environments {
  Environments._();

  /// 中文：当前生效环境，可选值为 dev、local、prod。
  /// English: Active environment; valid values are dev, local, and prod.
  static const currentEnvironmentName = 'local';

  static const dev = EnvConfig(
    type: AppEnvironmentType.dev,
    name: 'dev',
    label: '开发环境',
    baseUrl: 'https://dev-api.soys.app',
    wsUrl: 'wss://dev-ws.soys.app',
    siteUrl: 'https://dev.soys.app',
    termsUrl: 'https://dev.soys.app/terms',
    privacyUrl: 'https://dev.soys.app/privacy',
    forgotPasswordUrl: 'https://dev.soys.app/forgot-password',
    useLocalContent: false,
    showTestAccountLogin: true,
    allowLocalTestLogin: false,
    enableLog: true,
    enableCrashReport: false,
    enableAnalytics: false,
    enableCache: false,
  );

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
    showTestAccountLogin: true,
    allowLocalTestLogin: true,
    enableLog: true,
    enableCrashReport: false,
    enableAnalytics: false,
    enableCache: false,
  );

  static const prod = EnvConfig(
    type: AppEnvironmentType.prod,
    name: 'prod',
    label: '生产环境',
    baseUrl: 'https://api.soys.app',
    wsUrl: 'wss://ws.soys.app',
    siteUrl: 'https://soys.app',
    termsUrl: 'https://soys.app/terms',
    privacyUrl: 'https://soys.app/privacy',
    forgotPasswordUrl: 'https://soys.app/forgot-password',
    useLocalContent: false,
    showTestAccountLogin: false,
    allowLocalTestLogin: false,
    enableLog: false,
    enableCrashReport: true,
    enableAnalytics: true,
    enableCache: true,
  );

  static EnvConfig _current = resolve(currentEnvironmentName);

  /// 中文：当前生效环境。
  /// English: The currently active environment.
  static EnvConfig get current => _current;

  /// 中文：运行时切换环境，主要用于测试和调试工具。
  /// English: Switches environment at runtime, mainly for tests and debugging tools.
  static void switchTo(EnvConfig env) {
    _current = env;
  }

  /// 中文：根据字符串解析环境，兼容历史上的 online/test/qa/staging 命名。
  /// English: Resolves an environment from text and keeps compatibility with historical online/test/qa/staging names.
  static EnvConfig resolve(String name) {
    return switch (name.trim().toLowerCase()) {
      'prod' || 'production' || 'online' || 'server' => prod,
      'dev' || 'development' || 'test' || 'qa' || 'staging' => dev,
      'local' || 'local_test' || 'local-test' || 'offline' => local,
      _ => local,
    };
  }
}
