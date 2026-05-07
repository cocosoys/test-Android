// 中文：本文件承载注册页面逻辑，负责手机号注册、邮箱注册、验证码倒计时、协议勾选和表单校验。
// English: This file owns the Register page logic for phone signup, email signup, SMS countdown, agreement checks, and form validation.
//
// 中文：本文件的注释统一采用“上中文、下英文”的双语顺序，不能使用 ASCII 转码代替中文。
// English: Comments in this file keep Chinese above English and use real Chinese characters instead of ASCII escapes.

import 'package:get/get.dart';
import 'package:soys_app/pages/register/register_page.dart';

/// 中文：注册 RegisterBinding 对应路由需要的控制器或服务依赖。
/// English: RegisterBinding registers the controllers or services required by its route.
class RegisterBinding extends Bindings {
  /// 中文：注册当前路由或模块需要的 GetX 依赖，保证页面创建前控制器已经可用。
  /// English: Registers the GetX dependencies required by the current route or module before the page is created.
  @override
  void dependencies() {
    Get.lazyPut<RegisterController>(() => RegisterController());
  }
}
