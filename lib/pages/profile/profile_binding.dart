// 中文：本文件承载资料编辑页面逻辑，负责头像、昵称、性别、生日和资料保存。
// English: This file owns the Profile page logic for avatar, nickname, gender, birthday, and profile saving.
//
// 中文：本文件的注释统一采用“上中文、下英文”的双语顺序，不能使用 ASCII 转码代替中文。
// English: Comments in this file keep Chinese above English and use real Chinese characters instead of ASCII escapes.

import 'package:get/get.dart';
import 'package:soys_app/pages/profile/profile_page.dart';

/// 中文：注册 ProfileBinding 对应路由需要的控制器或服务依赖。
/// English: ProfileBinding registers the controllers or services required by its route.
class ProfileBinding extends Bindings {
  /// 中文：注册当前路由或模块需要的 GetX 依赖，保证页面创建前控制器已经可用。
  /// English: Registers the GetX dependencies required by the current route or module before the page is created.
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
