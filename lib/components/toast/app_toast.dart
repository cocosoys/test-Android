// 中文：本文件封装全局轻提示，统一成功、错误、警告、信息和加载提示的调用入口。
// English: This file wraps global toast notifications and standardizes success, error, warning, info, and loading prompts.
//
// 中文：本文件的注释统一采用“上中文、下英文”的双语顺序，不能使用 ASCII 转码代替中文。
// English: Comments in this file keep Chinese above English and use real Chinese characters instead of ASCII escapes.

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

/// Toast 工具
/// 中文：承载 AppToast 的核心职责，配合当前文件完成对应业务或界面逻辑。
/// English: AppToast carries its core responsibility and supports the business or UI logic in this file.
class AppToast {
  AppToast._();

  /// 成功提示
  static void showSuccess(String message) {
    SmartDialog.showNotify(
      msg: message,
      notifyType: NotifyType.success,
      displayTime: const Duration(seconds: 2),
    );
  }

  /// 错误提示
  static void showError(String message) {
    SmartDialog.showNotify(
      msg: message,
      notifyType: NotifyType.error,
      displayTime: const Duration(seconds: 2),
    );
  }

  /// 警告提示
  static void showWarning(String message) {
    SmartDialog.showNotify(
      msg: message,
      notifyType: NotifyType.warning,
      displayTime: const Duration(seconds: 2),
    );
  }

  /// 普通提示
  static void showInfo(String message) {
    SmartDialog.showNotify(
      msg: message,
      notifyType: NotifyType.alert,
      displayTime: const Duration(seconds: 2),
    );
  }

  /// 加载中
  static void showLoading({String? message}) {
    SmartDialog.showLoading(msg: message ?? 'loading'.tr);
  }

  /// 关闭加载
  static void dismissLoading() {
    SmartDialog.dismiss(status: SmartStatus.loading);
  }

  /// 关闭所有
  static void dismissAll() {
    SmartDialog.dismiss();
  }

  /// 确认弹窗
  static Future<bool> showConfirm({
    required String title,
    required String message,
    String confirmText = 'confirm',
    String cancelText = 'cancel',
    bool isDanger = false,
  }) async {
    var result = false;
    await SmartDialog.show(
      clickMaskDismiss: false,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              result = false;
              SmartDialog.dismiss();
            },
            child: Text(cancelText.tr),
          ),
          TextButton(
            onPressed: () {
              result = true;
              SmartDialog.dismiss();
            },
            style: isDanger
                ? TextButton.styleFrom(foregroundColor: Colors.red)
                : null,
            child: Text(confirmText.tr),
          ),
        ],
      ),
    );
    return result;
  }
}
