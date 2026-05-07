// 中文：本文件封装分享服务，统一文本、单图、多图、文件和链接分享能力。
// English: This file wraps sharing features for text, single images, multiple images, files, and links.
//
// 中文：本文件的注释统一采用“上中文、下英文”的双语顺序，不能使用 ASCII 转码代替中文。
// English: Comments in this file keep Chinese above English and use real Chinese characters instead of ASCII escapes.

import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import 'package:soys_app/core/logger/app_logger.dart';

/// 分享服务
/// 中文：封装 ShareService 对应的跨页面服务能力，避免业务层直接依赖底层实现。
/// English: ShareService encapsulates cross-page service capabilities so feature code does not depend on low-level details directly.
class ShareService extends GetxService {
  /// 系统分享 - 文本
  /// 中文：调用系统、文件或平台能力，并向业务层返回统一的处理结果。
  /// English: Invokes system, file, or platform capabilities and returns normalized results to feature code.
  Future<void> shareText(String text, {String? subject}) async {
    try {
      await Share.share(text, subject: subject);
    } catch (e) {
      AppLogger.e('Share text error: $e');
    }
  }

  /// 系统分享 - 图片
  /// 中文：调用系统、文件或平台能力，并向业务层返回统一的处理结果。
  /// English: Invokes system, file, or platform capabilities and returns normalized results to feature code.
  Future<void> shareImage(String imagePath, {String? text}) async {
    try {
      final xFile = XFile(imagePath);
      await Share.shareXFiles([xFile], text: text);
    } catch (e) {
      AppLogger.e('Share image error: $e');
    }
  }

  /// 系统分享 - 多图
  /// 中文：调用系统、文件或平台能力，并向业务层返回统一的处理结果。
  /// English: Invokes system, file, or platform capabilities and returns normalized results to feature code.
  Future<void> shareImages(List<String> imagePaths, {String? text}) async {
    try {
      final xFiles = imagePaths.map((path) => XFile(path)).toList();
      await Share.shareXFiles(xFiles, text: text);
    } catch (e) {
      AppLogger.e('Share images error: $e');
    }
  }

  /// 分享到微信好友。未配置平台 SDK 时走系统分享兜底。
  /// 中文：调用系统、文件或平台能力，并向业务层返回统一的处理结果。
  /// English: Invokes system, file, or platform capabilities and returns normalized results to feature code.
  Future<void> shareToWeChatSession({
    String? title,
    String? description,
    String? webUrl,
    String? imagePath,
  }) async {
    await _sharePlatformFallback(
      title: title,
      description: description,
      webUrl: webUrl,
      imagePath: imagePath,
    );
  }

  /// 分享到微信朋友圈。未配置平台 SDK 时走系统分享兜底。
  /// 中文：调用系统、文件或平台能力，并向业务层返回统一的处理结果。
  /// English: Invokes system, file, or platform capabilities and returns normalized results to feature code.
  Future<void> shareToWeChatMoments({
    String? title,
    String? description,
    String? webUrl,
    String? imagePath,
  }) async {
    await _sharePlatformFallback(
      title: title,
      description: description,
      webUrl: webUrl,
      imagePath: imagePath,
    );
  }

  /// 分享到QQ。未配置平台 SDK 时走系统分享兜底。
  /// 中文：调用系统、文件或平台能力，并向业务层返回统一的处理结果。
  /// English: Invokes system, file, or platform capabilities and returns normalized results to feature code.
  Future<void> shareToQQ({
    String? title,
    String? description,
    String? webUrl,
    String? imagePath,
  }) async {
    await _sharePlatformFallback(
      title: title,
      description: description,
      webUrl: webUrl,
      imagePath: imagePath,
    );
  }

  /// 中文：调用系统、文件或平台能力，并向业务层返回统一的处理结果。
  /// English: Invokes system, file, or platform capabilities and returns normalized results to feature code.
  Future<void> _sharePlatformFallback({
    String? title,
    String? description,
    String? webUrl,
    String? imagePath,
  }) async {
    final text = [
      if (title != null && title.isNotEmpty) title,
      if (description != null && description.isNotEmpty) description,
      if (webUrl != null && webUrl.isNotEmpty) webUrl,
    ].join('\n');

    if (imagePath != null && imagePath.isNotEmpty) {
      await shareImage(imagePath, text: text.isEmpty ? null : text);
    } else if (text.isNotEmpty) {
      await shareText(text, subject: title);
    } else {
      AppLogger.w('Share skipped: empty content');
    }
  }
}
