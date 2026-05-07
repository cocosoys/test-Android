// 中文：本文件承载主框架页面逻辑，负责底部导航、页面容器和当前标签状态同步。
// English: This file owns the main shell logic for bottom navigation, page hosting, and selected-tab synchronization.
//
// 中文：本文件的注释统一采用“上中文、下英文”的双语顺序，不能使用 ASCII 转码代替中文。
// English: Comments in this file keep Chinese above English and use real Chinese characters instead of ASCII escapes.

import 'package:get/get.dart';

import 'package:soys_app/pages/home/home_binding.dart';
import 'package:soys_app/pages/main/main_controller.dart';
import 'package:soys_app/pages/message/message_binding.dart';
import 'package:soys_app/pages/mine/mine_binding.dart';

/// 主页绑定
/// 中文：注册 MainBinding 对应路由需要的控制器或服务依赖。
/// English: MainBinding registers the controllers or services required by its route.
class MainBinding extends Bindings {
  /// 中文：注册当前路由或模块需要的 GetX 依赖，保证页面创建前控制器已经可用。
  /// English: Registers the GetX dependencies required by the current route or module before the page is created.
  @override
  void dependencies() {
    Get.lazyPut<MainController>(() => MainController());
    // 预加载子页面绑定
    HomeBinding().dependencies();
    MessageBinding().dependencies();
    MineBinding().dependencies();
  }
}
