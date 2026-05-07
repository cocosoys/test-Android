// 中文：本文件集中维护不同运行环境的接口域名、超时、日志、缓存和第三方能力开关。
// English: This file centralizes API hosts, timeouts, logging, caching, and third-party feature switches for each runtime environment.
//
// 中文：本文件的注释统一采用“上中文、下英文”的双语顺序，不能使用 ASCII 转码代替中文。
// English: Comments in this file keep Chinese above English and use real Chinese characters instead of ASCII escapes.

/// 多环境配置
/// 中文：承载 EnvConfig 的核心职责，配合当前文件完成对应业务或界面逻辑。
/// English: EnvConfig carries its core responsibility and supports the business or UI logic in this file.
class EnvConfig {
  final String name;
  final String baseUrl;
  final String wsUrl;
  final bool enableLog;
  final bool enableCrashReport;
  final bool enableAnalytics;
  final bool enableCache;
  final int connectTimeout;
  final int receiveTimeout;
  final String jPushAppKey;
  final String appStoreUrl;

  const EnvConfig({
    required this.name,
    required this.baseUrl,
    required this.wsUrl,
    this.enableLog = true,
    this.enableCrashReport = false,
    this.enableAnalytics = false,
    this.enableCache = true,
    this.connectTimeout = 15000,
    this.receiveTimeout = 15000,
    this.jPushAppKey = '',
    this.appStoreUrl = 'https://apps.apple.com/app/soys-app',
  });
}

/// 中文：承载 Environments 的核心职责，配合当前文件完成对应业务或界面逻辑。
/// English: Environments carries its core responsibility and supports the business or UI logic in this file.
class Environments {
  static const dev = EnvConfig(
    name: 'dev',
    baseUrl: 'https://dev-api.soys.app',
    wsUrl: 'wss://dev-ws.soys.app',
    enableLog: true,
    enableCrashReport: false,
    enableAnalytics: false,
    enableCache: false,
  );

  static const test = EnvConfig(
    name: 'test',
    baseUrl: 'https://test-api.soys.app',
    wsUrl: 'wss://test-ws.soys.app',
    enableLog: true,
    enableCrashReport: false,
    enableAnalytics: false,
  );

  static const staging = EnvConfig(
    name: 'staging',
    baseUrl: 'https://staging-api.soys.app',
    wsUrl: 'wss://staging-ws.soys.app',
    enableLog: true,
    enableCrashReport: true,
    enableAnalytics: true,
  );

  static const prod = EnvConfig(
    name: 'prod',
    baseUrl: 'https://api.soys.app',
    wsUrl: 'wss://ws.soys.app',
    enableLog: false,
    enableCrashReport: true,
    enableAnalytics: true,
  );

  /// 当前环境（启动时赋值）
  static EnvConfig current = dev;

  /// 切换环境
  static void switchTo(EnvConfig env) {
    current = env;
  }
}
