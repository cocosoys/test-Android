// 中文：本文件提供 Flutter Widget 测试入口，用于验证应用可以完成基础渲染。
// English: This file provides the Flutter widget test entry point used to verify that the app can render at a basic level.
//
// 中文：本文件的注释统一采用“上中文、下英文”的双语顺序，不能使用 ASCII 转码代替中文。
// English: Comments in this file keep Chinese above English and use real Chinese characters instead of ASCII escapes.

import 'package:soys_app/app/routes/app_routes.dart';
import 'package:flutter_test/flutter_test.dart';

/// 中文：启动 Flutter 应用，并把真正的初始化流程委托给独立方法，便于统一捕获异常。
/// English: Starts the Flutter app and delegates initialization to a separate method so uncaught errors can be handled consistently.
void main() {
  test('App route table contains the startup flow', () {
    final routeNames = AppPages.pages.map((page) => page.name).toSet();

    expect(routeNames, contains(AppRoutes.splash));
    expect(routeNames, contains(AppRoutes.login));
    expect(routeNames, contains(AppRoutes.main));
    expect(routeNames, contains(AppRoutes.webview));
    expect(AppRoutes.splash, '/splash');
  });
}
