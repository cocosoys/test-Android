// 中文：本文件封装埋点服务，统一页面访问、事件、按钮点击、登录注册和用户属性上报。
// English: This file wraps analytics reporting for page views, events, button clicks, login/signup, and user properties.
//
// 中文：本文件的注释统一采用“上中文、下英文”的双语顺序，不能使用 ASCII 转码代替中文。
// English: Comments in this file keep Chinese above English and use real Chinese characters instead of ASCII escapes.

import 'package:get/get.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:soys_app/core/constants/env_config.dart';
import 'package:soys_app/core/logger/app_logger.dart';

/// 埋点统计服务
/// 中文：封装 AnalyticsService 对应的跨页面服务能力，避免业务层直接依赖底层实现。
/// English: AnalyticsService encapsulates cross-page service capabilities so feature code does not depend on low-level details directly.
class AnalyticsService extends GetxService {
  bool _enabled = false;
  FirebaseAnalytics? _analytics;

  bool get enabled => _enabled;

  /// 中文：完成当前对象的初始化流程，确保依赖、监听器或初始数据在使用前准备好。
  /// English: Initializes the current object so dependencies, listeners, or initial data are ready before use.
  Future<AnalyticsService> init() async {
    _enabled = Environments.current.enableAnalytics;

    if (_enabled) {
      try {
        await Firebase.initializeApp();
        _analytics = FirebaseAnalytics.instance;
        await _analytics!.setAnalyticsCollectionEnabled(true);
      } catch (e) {
        _enabled = false;
        AppLogger.e('AnalyticsService init failed: $e');
      }
    }

    AppLogger.i('AnalyticsService initialized, enabled: $_enabled');
    return this;
  }

  /// 页面浏览
  /// 中文：转发统计、崩溃或推送相关操作，隐藏第三方 SDK 的直接调用细节。
  /// English: Forwards analytics, crash, or push operations while hiding direct third-party SDK calls.
  Future<void> logPageView(
    String pageName, {
    Map<String, dynamic>? params,
  }) async {
    if (!_enabled) return;
    AppLogger.d('Analytics PageView: $pageName, params: $params');
    await _analytics?.logScreenView(screenName: pageName);
    await _analytics?.logEvent(
      name: 'page_view',
      parameters: _toAnalyticsParams({'page_name': pageName, ...?params}),
    );
  }

  /// 事件埋点
  /// 中文：转发统计、崩溃或推送相关操作，隐藏第三方 SDK 的直接调用细节。
  /// English: Forwards analytics, crash, or push operations while hiding direct third-party SDK calls.
  Future<void> logEvent(
    String eventName, {
    Map<String, dynamic>? params,
  }) async {
    if (!_enabled) return;
    AppLogger.d('Analytics Event: $eventName, params: $params');
    await _analytics?.logEvent(
      name: eventName,
      parameters: _toAnalyticsParams(params),
    );
  }

  /// 按钮点击
  /// 中文：转发统计、崩溃或推送相关操作，隐藏第三方 SDK 的直接调用细节。
  /// English: Forwards analytics, crash, or push operations while hiding direct third-party SDK calls.
  Future<void> logButtonClick(String buttonName, {String? pageName}) async {
    if (!_enabled) return;
    AppLogger.d('Analytics ButtonClick: $buttonName, page: $pageName');
  }

  /// 登录
  /// 中文：转发统计、崩溃或推送相关操作，隐藏第三方 SDK 的直接调用细节。
  /// English: Forwards analytics, crash, or push operations while hiding direct third-party SDK calls.
  Future<void> logLogin(String method) async {
    if (!_enabled) return;
    AppLogger.d('Analytics Login: $method');
    await _analytics?.logLogin(loginMethod: method);
  }

  /// 注册
  /// 中文：转发统计、崩溃或推送相关操作，隐藏第三方 SDK 的直接调用细节。
  /// English: Forwards analytics, crash, or push operations while hiding direct third-party SDK calls.
  Future<void> logSignUp(String method) async {
    if (!_enabled) return;
    AppLogger.d('Analytics SignUp: $method');
    await _analytics?.logSignUp(signUpMethod: method);
  }

  /// 设置用户属性
  /// 中文：更新当前功能状态或持久化数据，并确保界面和本地缓存保持一致。
  /// English: Updates feature state or persisted data while keeping the UI and local cache consistent.
  Future<void> setUserProperty(String name, String value) async {
    if (!_enabled) return;
    AppLogger.d('Analytics UserProperty: $name = $value');
    await _analytics?.setUserProperty(name: name, value: value);
  }

  /// 设置用户ID
  /// 中文：更新当前功能状态或持久化数据，并确保界面和本地缓存保持一致。
  /// English: Updates feature state or persisted data while keeping the UI and local cache consistent.
  Future<void> setUserId(String id) async {
    if (!_enabled) return;
    AppLogger.d('Analytics UserId: $id');
    await _analytics?.setUserId(id: id);
  }

  /// 中文：执行 toAnalyticsParams 对应的业务步骤，并把内部细节封装在当前模块内。
  /// English: Executes the toAnalyticsParams business step while keeping internal details encapsulated in this module.
  Map<String, Object>? _toAnalyticsParams(Map<String, dynamic>? params) {
    if (params == null || params.isEmpty) return null;
    return params.map((key, value) {
      if (value is Object) return MapEntry(key, value);
      return MapEntry(key, value.toString());
    });
  }
}
