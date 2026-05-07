// 中文：本文件承载登录页面逻辑，负责账号、手机、邮箱、测试账号和第三方登录入口。
// English: This file owns the Login page logic for account, phone, email, test-account, and third-party login paths.
//
// 中文：本文件的注释统一采用“上中文、下英文”的双语顺序，不能使用 ASCII 转码代替中文。
// English: Comments in this file keep Chinese above English and use real Chinese characters instead of ASCII escapes.

import 'package:get/get.dart';

import 'package:soys_app/pages/login/login_controller.dart';

/// 登录页绑定
/// 中文：注册 LoginBinding 对应路由需要的控制器或服务依赖。
/// English: LoginBinding registers the controllers or services required by its route.
class LoginBinding extends Bindings {
  /// 中文：注册当前路由或模块需要的 GetX 依赖，保证页面创建前控制器已经可用。
  /// English: Registers the GetX dependencies required by the current route or module before the page is created.
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController());
  }
}
