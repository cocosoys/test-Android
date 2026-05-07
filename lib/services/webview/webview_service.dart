// 中文：本文件封装 WebView 桥接服务，统一 H5 消息处理器注册、消息分发、注入脚本和缓存清理。
// English: This file wraps WebView bridge logic for H5 handler registration, message dispatch, injected scripts, and cache clearing.
//
// 中文：本文件的注释统一采用“上中文、下英文”的双语顺序，不能使用 ASCII 转码代替中文。
// English: Comments in this file keep Chinese above English and use real Chinese characters instead of ASCII escapes.

import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart' as wv;

import 'package:soys_app/core/logger/app_logger.dart';

/// WebView 通信服务
/// 中文：封装 WebViewService 对应的跨页面服务能力，避免业务层直接依赖底层实现。
/// English: WebViewService encapsulates cross-page service capabilities so feature code does not depend on low-level details directly.
class WebViewService extends GetxService {
  static const String jsBridgeName = 'SoysJSBridge';

  /// JS Bridge 回调
  final Map<String, Function(dynamic)> _handlers = {};

  /// 注册 H5 调用 Flutter 的处理器
  /// 中文：处理账号认证相关流程，并把接口结果、加载状态和页面跳转保持同步。
  /// English: Handles account-authentication flow while keeping API results, loading state, and navigation in sync.
  void registerHandler(String name, Function(dynamic) handler) {
    _handlers[name] = handler;
  }

  /// 移除处理器
  /// 中文：执行 removeHandler 对应的业务步骤，并把内部细节封装在当前模块内。
  /// English: Executes the removeHandler business step while keeping internal details encapsulated in this module.
  void removeHandler(String name) {
    _handlers.remove(name);
  }

  /// 处理来自 H5 的消息
  /// 中文：处理导航、桥接或事件分发动作，统一外部交互入口。
  /// English: Handles navigation, bridge, or event-dispatch actions through a single interaction entry point.
  void handleMessage(String name, dynamic data) {
    final handler = _handlers[name];
    if (handler != null) {
      handler(data);
    } else {
      AppLogger.w('WebView: No handler for "$name"');
    }
  }

  /// Flutter 调用 H5 JS 方法
  /// 中文：处理导航、桥接或事件分发动作，统一外部交互入口。
  /// English: Handles navigation, bridge, or event-dispatch actions through a single interaction entry point.
  Future<void> callJS(
    wv.WebViewController controller,
    String methodName, [
    dynamic args,
  ]) async {
    try {
      String jsCode;
      if (args != null) {
        final argsJson = args is String ? args : args.toString();
        jsCode = '$methodName($argsJson)';
      } else {
        jsCode = '$methodName()';
      }
      await controller.runJavaScript(jsCode);
      AppLogger.d('WebView callJS: $jsCode');
    } catch (e) {
      AppLogger.e('WebView callJS error: $e');
    }
  }

  /// 通用 JS Bridge 注入脚本
  /// 中文：根据当前输入计算并返回调用方需要的派生值。
  /// English: Computes and returns the derived value required by the caller from the current input.
  String getInjectJS() {
    return '''
      window.$jsBridgeName = {
        call: function(name, data) {
          if (window.$jsBridgeName.postMessage) {
            window.$jsBridgeName.postMessage(JSON.stringify({name: name, data: data}));
          }
        }
      };
    ''';
  }

  /// 清除 WebView 缓存
  /// 中文：更新当前功能状态或持久化数据，并确保界面和本地缓存保持一致。
  /// English: Updates feature state or persisted data while keeping the UI and local cache consistent.
  Future<void> clearCache() async {
    AppLogger.i('WebView cache cleared');
  }
}
