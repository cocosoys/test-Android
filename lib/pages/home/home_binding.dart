// 中文：本文件承载首页逻辑，负责首页配置加载、兜底数据、Banner、功能入口和推荐内容展示。
// English: This file owns the Home page logic for config loading, fallback data, banners, feature entries, and recommendations.
//
// 中文：本文件的注释统一采用“上中文、下英文”的双语顺序，不能使用 ASCII 转码代替中文。
// English: Comments in this file keep Chinese above English and use real Chinese characters instead of ASCII escapes.

import 'package:get/get.dart';
import 'package:soys_app/pages/home/home_page.dart';

/// 中文：注册 HomeBinding 对应路由需要的控制器或服务依赖。
/// English: HomeBinding registers the controllers or services required by its route.
class HomeBinding extends Bindings {
  /// 中文：注册当前路由或模块需要的 GetX 依赖，保证页面创建前控制器已经可用。
  /// English: Registers the GetX dependencies required by the current route or module before the page is created.
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
  }
}
