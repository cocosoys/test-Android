// 中文：本文件封装崩溃采集服务，统一 Firebase Crashlytics 初始化、错误记录和崩溃上报控制。
// English: This file wraps crash reporting for Firebase Crashlytics initialization, error recording, and report controls.
//
// 中文：本文件的注释统一采用“上中文、下英文”的双语顺序，不能使用 ASCII 转码代替中文。
// English: Comments in this file keep Chinese above English and use real Chinese characters instead of ASCII escapes.

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'package:soys_app/core/constants/env_config.dart';
import 'package:soys_app/core/logger/app_logger.dart';

/// 崩溃上报服务
/// 中文：封装 CrashService 对应的跨页面服务能力，避免业务层直接依赖底层实现。
/// English: CrashService encapsulates cross-page service capabilities so feature code does not depend on low-level details directly.
class CrashService extends GetxService {
  static FirebaseCrashlytics? _crashlyticsInstance;

  final _isInitialized = false.obs;
  bool get isInitialized => _isInitialized.value;

  /// 中文：完成当前对象的初始化流程，确保依赖、监听器或初始数据在使用前准备好。
  /// English: Initializes the current object so dependencies, listeners, or initial data are ready before use.
  Future<CrashService> init() async {
    final enabled = Environments.current.enableCrashReport;

    if (!enabled) {
      AppLogger.i('CrashService: disabled in current environment');
      return this;
    }

    try {
      _crashlyticsInstance = FirebaseCrashlytics.instance;

      // 在调试模式下禁用 Crashlytics 上报
      if (kDebugMode) {
        await _crashlyticsInstance!.setCrashlyticsCollectionEnabled(false);
        AppLogger.i('CrashService: disabled in debug mode');
      } else {
        await _crashlyticsInstance!.setCrashlyticsCollectionEnabled(true);

        // 将 Flutter 框架错误转发到 Crashlytics
        FlutterError.onError =
            FirebaseCrashlytics.instance.recordFlutterFatalError;

        // 将异步未捕获错误转发到 Crashlytics
        PlatformDispatcher.instance.onError = (error, stack) {
          FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
          return true;
        };
      }

      _isInitialized.value = true;
      AppLogger.i('CrashService initialized successfully, enabled: $enabled');
    } catch (e) {
      AppLogger.e('CrashService init failed: $e');
    }

    return this;
  }

  /// 记录 Flutter 框架错误（静态方法，可在服务初始化前调用）
  static void recordFlutterError(FlutterErrorDetails details) {
    AppLogger.e(
      'Flutter Error: ${details.exceptionAsString()}',
      details.exception,
      details.stack,
    );

    if (_crashlyticsInstance != null) {
      _crashlyticsInstance!.recordFlutterFatalError(details);
    }
  }

  /// 记录自定义错误（静态方法，可在服务初始化前调用）
  static void recordError(
    dynamic error,
    StackTrace? stack, {
    bool fatal = false,
    Map<String, dynamic>? extra,
  }) {
    AppLogger.e('Recorded Error: $error', error, stack);

    if (_crashlyticsInstance != null) {
      if (extra != null) {
        for (final entry in extra.entries) {
          _crashlyticsInstance!.setCustomKey(entry.key, entry.value);
        }
      }
      _crashlyticsInstance!.recordError(error, stack, fatal: fatal);
    }
  }

  /// 设置用户标识
  /// 中文：更新当前功能状态或持久化数据，并确保界面和本地缓存保持一致。
  /// English: Updates feature state or persisted data while keeping the UI and local cache consistent.
  void setUserIdentifier(String identifier) {
    if (_isInitialized.value && _crashlyticsInstance != null) {
      _crashlyticsInstance!.setUserIdentifier(identifier);
      AppLogger.i('CrashService: user identifier set - $identifier');
    }
  }

  /// 设置自定义键值
  /// 中文：更新当前功能状态或持久化数据，并确保界面和本地缓存保持一致。
  /// English: Updates feature state or persisted data while keeping the UI and local cache consistent.
  void setCustomKey(String key, dynamic value) {
    if (_isInitialized.value && _crashlyticsInstance != null) {
      _crashlyticsInstance!.setCustomKey(key, value);
    }
  }

  /// 记录日志（附加到下一次崩溃报告中）
  /// 中文：转发统计、崩溃或推送相关操作，隐藏第三方 SDK 的直接调用细节。
  /// English: Forwards analytics, crash, or push operations while hiding direct third-party SDK calls.
  void log(String message) {
    if (_isInitialized.value && _crashlyticsInstance != null) {
      _crashlyticsInstance!.log(message);
    }
    AppLogger.d('CrashLog: $message');
  }

  /// 发送未发送的报告
  /// 中文：执行 sendUnsentReports 对应的业务步骤，并把内部细节封装在当前模块内。
  /// English: Executes the sendUnsentReports business step while keeping internal details encapsulated in this module.
  Future<bool> sendUnsentReports() async {
    if (!_isInitialized.value || _crashlyticsInstance == null) return false;
    try {
      await _crashlyticsInstance!.sendUnsentReports();
      return true;
    } catch (e) {
      AppLogger.e('CrashService: send unsent reports failed - $e');
      return false;
    }
  }

  /// 删除未发送的报告
  /// 中文：转发统计、崩溃或推送相关操作，隐藏第三方 SDK 的直接调用细节。
  /// English: Forwards analytics, crash, or push operations while hiding direct third-party SDK calls.
  Future<void> deleteUnsentReports() async {
    if (!_isInitialized.value || _crashlyticsInstance == null) return;
    try {
      await _crashlyticsInstance!.deleteUnsentReports();
    } catch (e) {
      AppLogger.e('CrashService: delete unsent reports failed - $e');
    }
  }

  /// 检查是否有未发送的报告
  /// 中文：加载或刷新当前功能所需数据，并在失败时保留可用的兜底状态。
  /// English: Loads or refreshes data required by this feature and keeps usable fallback state when requests fail.
  Future<bool> checkForUnsentReports() async {
    if (!_isInitialized.value || _crashlyticsInstance == null) return false;
    try {
      return await _crashlyticsInstance!.checkForUnsentReports();
    } catch (e) {
      AppLogger.e('CrashService: check for unsent reports failed - $e');
      return false;
    }
  }

  /// 根据环境切换崩溃上报开关
  /// 中文：更新当前功能状态或持久化数据，并确保界面和本地缓存保持一致。
  /// English: Updates feature state or persisted data while keeping the UI and local cache consistent.
  Future<void> toggleCrashReporting(bool enabled) async {
    if (!_isInitialized.value || _crashlyticsInstance == null) return;
    try {
      await _crashlyticsInstance!.setCrashlyticsCollectionEnabled(enabled);
      AppLogger.i('CrashService: crash reporting enabled = $enabled');
    } catch (e) {
      AppLogger.e('CrashService: toggle crash reporting failed - $e');
    }
  }

  /// 主动触发崩溃（仅调试用，用于验证崩溃上报链路）
  /// 中文：转发统计、崩溃或推送相关操作，隐藏第三方 SDK 的直接调用细节。
  /// English: Forwards analytics, crash, or push operations while hiding direct third-party SDK calls.
  void triggerCrash() {
    if (kDebugMode && _crashlyticsInstance != null) {
      AppLogger.w('CrashService: triggering test crash');
      _crashlyticsInstance!.crash();
    } else {
      AppLogger.w('CrashService: triggerCrash is only available in debug mode');
    }
  }
}
