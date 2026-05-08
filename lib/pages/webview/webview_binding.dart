// 中文：本文件承载 WebView 页面逻辑，负责 H5 加载、JS 桥、导航控制和缓存处理。
// English: This file owns the WebView page logic for H5 loading, JavaScript bridges, navigation controls, and cache handling.
//
// 中文：本文件的注释统一采用“上中文、下英文”的双语顺序，不能使用 ASCII 转码代替中文。
// English: Comments in this file keep Chinese above English and use real Chinese characters instead of ASCII escapes.

import 'package:get/get.dart';
import 'package:soys_app/core/constants/env_config.dart';
import 'package:soys_app/pages/webview/webview_page.dart';

/// 中文：注册 WebViewBinding 对应路由需要的控制器或服务依赖。
/// English: WebViewBinding registers the controllers or services required by its route.
class WebViewBinding extends Bindings {
  /// 中文：注册当前路由或模块需要的 GetX 依赖，保证页面创建前控制器已经可用。
  /// English: Registers the GetX dependencies required by the current route or module before the page is created.
  @override
  void dependencies() {
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    final parameters = Get.parameters;
    final url =
        args['url'] as String? ??
        parameters['url'] ??
        Environments.current.siteUrl;
    final title = args['title'] as String? ?? parameters['title'] ?? '';

    Get.lazyPut<AppWebViewController>(
      () => AppWebViewController(initialUrl: url, initialTitle: title),
    );
  }
}
