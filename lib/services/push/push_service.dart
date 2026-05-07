// 中文：本文件封装推送服务，统一极光推送初始化、别名、标签、通知点击、开关和角标逻辑。
// English: This file wraps push notification logic for JPush initialization, aliases, tags, click handling, enable/disable, and badges.
//
// 中文：本文件的注释统一采用“上中文、下英文”的双语顺序，不能使用 ASCII 转码代替中文。
// English: Comments in this file keep Chinese above English and use real Chinese characters instead of ASCII escapes.

import 'package:get/get.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:jpush_flutter/jpush_interface.dart';

import 'package:soys_app/core/constants/env_config.dart';
import 'package:soys_app/core/logger/app_logger.dart';

/// 极光推送服务
/// 中文：封装 PushService 对应的跨页面服务能力，避免业务层直接依赖底层实现。
/// English: PushService encapsulates cross-page service capabilities so feature code does not depend on low-level details directly.
class PushService extends GetxService {
  final JPushFlutterInterface _jPush = JPush.newJPush();

  JPushFlutterInterface get jPush => _jPush;

  final _registrationId = ''.obs;
  final _notification = Rxn<Map<String, dynamic>>();

  String get registrationId => _registrationId.value;
  Map<String, dynamic>? get notification => _notification.value;

  /// 中文：完成当前对象的初始化流程，确保依赖、监听器或初始数据在使用前准备好。
  /// English: Initializes the current object so dependencies, listeners, or initial data are ready before use.
  Future<PushService> init() async {
    try {
      _jPush.addEventHandler(
        onReceiveNotification: (message) async {
          AppLogger.i('Push received: $message');
          _notification.value = message;
        },
        onOpenNotification: (message) async {
          AppLogger.i('Push opened: $message');
          _handleNotificationClick(message);
        },
      );

      final appKey = Environments.current.jPushAppKey;
      if (appKey.isEmpty) {
        AppLogger.i('PushService skipped: JPush appKey is not configured');
        return this;
      }

      _jPush.setup(
        appKey: appKey,
        channel: 'developer-default',
        production: Environments.current.name == 'prod',
        debug: Environments.current.enableLog,
      );

      AppLogger.i('PushService initialized with appKey: $appKey');
    } catch (e) {
      AppLogger.e('PushService init failed: $e');
    }

    return this;
  }

  /// 设置别名
  /// 中文：更新当前功能状态或持久化数据，并确保界面和本地缓存保持一致。
  /// English: Updates feature state or persisted data while keeping the UI and local cache consistent.
  void setAlias(String alias) {
    _jPush.setAlias(alias);
  }

  /// 删除别名
  /// 中文：转发统计、崩溃或推送相关操作，隐藏第三方 SDK 的直接调用细节。
  /// English: Forwards analytics, crash, or push operations while hiding direct third-party SDK calls.
  void deleteAlias() {
    _jPush.deleteAlias();
  }

  /// 设置标签
  /// 中文：更新当前功能状态或持久化数据，并确保界面和本地缓存保持一致。
  /// English: Updates feature state or persisted data while keeping the UI and local cache consistent.
  void setTags(Set<String> tags) {
    _jPush.setTags(tags.toList());
  }

  /// 清除标签
  /// 中文：执行 cleanTags 对应的业务步骤，并把内部细节封装在当前模块内。
  /// English: Executes the cleanTags business step while keeping internal details encapsulated in this module.
  void cleanTags() {
    _jPush.cleanTags();
  }

  /// 处理通知点击
  /// 中文：处理导航、桥接或事件分发动作，统一外部交互入口。
  /// English: Handles navigation, bridge, or event-dispatch actions through a single interaction entry point.
  void _handleNotificationClick(Map<String, dynamic>? message) {
    if (message == null) return;
    try {
      final extras = message['extras'] as Map<String, dynamic>?;
      if (extras != null) {
        final route = extras['route'] as String?;
        if (route != null && route.isNotEmpty) {
          Get.toNamed(route, arguments: extras['params']);
        }
      }
    } catch (e) {
      AppLogger.e('Handle notification click error: $e');
    }
  }

  /// 停止推送
  /// 中文：转发统计、崩溃或推送相关操作，隐藏第三方 SDK 的直接调用细节。
  /// English: Forwards analytics, crash, or push operations while hiding direct third-party SDK calls.
  void stopPush() {
    _jPush.stopPush();
  }

  /// 恢复推送
  /// 中文：转发统计、崩溃或推送相关操作，隐藏第三方 SDK 的直接调用细节。
  /// English: Forwards analytics, crash, or push operations while hiding direct third-party SDK calls.
  void resumePush() {
    _jPush.resumePush();
  }

  /// 设置角标
  /// 中文：更新当前功能状态或持久化数据，并确保界面和本地缓存保持一致。
  /// English: Updates feature state or persisted data while keeping the UI and local cache consistent.
  void setBadge(int badge) {
    _jPush.setBadge(badge);
  }
}
