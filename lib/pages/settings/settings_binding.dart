// 中文：本文件承载设置页面逻辑，负责主题切换、语言切换和缓存清理。
// English: This file owns the Settings page logic for theme switching, language switching, and cache clearing.
//
// 中文：本文件的注释统一采用“上中文、下英文”的双语顺序，不能使用 ASCII 转码代替中文。
// English: Comments in this file keep Chinese above English and use real Chinese characters instead of ASCII escapes.

import 'package:get/get.dart';
import 'package:soys_app/pages/settings/settings_page.dart';

/// 中文：注册 SettingsBinding 对应路由需要的控制器或服务依赖。
/// English: SettingsBinding registers the controllers or services required by its route.
class SettingsBinding extends Bindings {
  /// 中文：注册当前路由或模块需要的 GetX 依赖，保证页面创建前控制器已经可用。
  /// English: Registers the GetX dependencies required by the current route or module before the page is created.
  @override
  void dependencies() {
    Get.lazyPut<SettingsController>(() => SettingsController());
  }
}
