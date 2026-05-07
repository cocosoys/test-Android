// 中文：本文件承载消息页面逻辑，负责消息加载、解析、已读状态和刷新交互。
// English: This file owns the Message page logic for message loading, parsing, read state, and refresh interactions.
//
// 中文：本文件的注释统一采用“上中文、下英文”的双语顺序，不能使用 ASCII 转码代替中文。
// English: Comments in this file keep Chinese above English and use real Chinese characters instead of ASCII escapes.

import 'package:get/get.dart';
import 'package:soys_app/pages/message/message_page.dart';

/// 中文：注册 MessageBinding 对应路由需要的控制器或服务依赖。
/// English: MessageBinding registers the controllers or services required by its route.
class MessageBinding extends Bindings {
  /// 中文：注册当前路由或模块需要的 GetX 依赖，保证页面创建前控制器已经可用。
  /// English: Registers the GetX dependencies required by the current route or module before the page is created.
  @override
  void dependencies() {
    Get.lazyPut<MessageController>(() => MessageController());
  }
}
