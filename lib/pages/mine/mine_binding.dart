// 中文：本文件承载我的页面逻辑，负责用户卡片、个人入口、设置入口和退出登录操作。
// English: This file owns the Mine page logic for the user card, profile entry, settings entry, and logout action.
//
// 中文：本文件的注释统一采用“上中文、下英文”的双语顺序，不能使用 ASCII 转码代替中文。
// English: Comments in this file keep Chinese above English and use real Chinese characters instead of ASCII escapes.

import 'package:get/get.dart';
import 'package:soys_app/pages/mine/mine_page.dart';

/// 中文：注册 MineBinding 对应路由需要的控制器或服务依赖。
/// English: MineBinding registers the controllers or services required by its route.
class MineBinding extends Bindings {
  /// 中文：注册当前路由或模块需要的 GetX 依赖，保证页面创建前控制器已经可用。
  /// English: Registers the GetX dependencies required by the current route or module before the page is created.
  @override
  void dependencies() {
    Get.lazyPut<MineController>(() => MineController());
  }
}
