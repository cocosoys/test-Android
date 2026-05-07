// 中文：本文件封装权限申请和权限失败提示，统一相机、相册、定位、通知、存储和麦克风权限逻辑。
// English: This file wraps permission requests and denied prompts for camera, gallery, location, notification, storage, and microphone access.
//
// 中文：本文件的注释统一采用“上中文、下英文”的双语顺序，不能使用 ASCII 转码代替中文。
// English: Comments in this file keep Chinese above English and use real Chinese characters instead of ASCII escapes.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

/// 权限服务
/// 中文：封装 PermissionService 对应的跨页面服务能力，避免业务层直接依赖底层实现。
/// English: PermissionService encapsulates cross-page service capabilities so feature code does not depend on low-level details directly.
class PermissionService extends GetxService {
  /// 请求权限
  /// 中文：调用系统、文件或平台能力，并向业务层返回统一的处理结果。
  /// English: Invokes system, file, or platform capabilities and returns normalized results to feature code.
  Future<bool> requestPermission(Permission permission) async {
    final status = await permission.request();
    return status.isGranted;
  }

  /// 请求相机权限
  /// 中文：调用系统、文件或平台能力，并向业务层返回统一的处理结果。
  /// English: Invokes system, file, or platform capabilities and returns normalized results to feature code.
  Future<bool> requestCamera() async {
    final granted = await requestPermission(Permission.camera);
    if (!granted) {
      _showPermissionDeniedDialog(Permission.camera);
    }
    return granted;
  }

  /// 请求相册权限
  /// 中文：调用系统、文件或平台能力，并向业务层返回统一的处理结果。
  /// English: Invokes system, file, or platform capabilities and returns normalized results to feature code.
  Future<bool> requestGallery() async {
    final granted = await requestPermission(Permission.photos);
    if (!granted) {
      _showPermissionDeniedDialog(Permission.photos);
    }
    return granted;
  }

  /// 请求定位权限
  /// 中文：调用系统、文件或平台能力，并向业务层返回统一的处理结果。
  /// English: Invokes system, file, or platform capabilities and returns normalized results to feature code.
  Future<bool> requestLocation() async {
    final granted = await requestPermission(Permission.location);
    if (!granted) {
      _showPermissionDeniedDialog(Permission.location);
    }
    return granted;
  }

  /// 请求通知权限
  /// 中文：调用系统、文件或平台能力，并向业务层返回统一的处理结果。
  /// English: Invokes system, file, or platform capabilities and returns normalized results to feature code.
  Future<bool> requestNotification() async {
    final granted = await requestPermission(Permission.notification);
    if (!granted) {
      _showPermissionDeniedDialog(Permission.notification);
    }
    return granted;
  }

  /// 请求存储权限
  /// 中文：调用系统、文件或平台能力，并向业务层返回统一的处理结果。
  /// English: Invokes system, file, or platform capabilities and returns normalized results to feature code.
  Future<bool> requestStorage() async {
    final granted = await requestPermission(Permission.storage);
    if (!granted) {
      _showPermissionDeniedDialog(Permission.storage);
    }
    return granted;
  }

  /// 请求麦克风权限
  /// 中文：调用系统、文件或平台能力，并向业务层返回统一的处理结果。
  /// English: Invokes system, file, or platform capabilities and returns normalized results to feature code.
  Future<bool> requestMicrophone() async {
    final granted = await requestPermission(Permission.microphone);
    if (!granted) {
      _showPermissionDeniedDialog(Permission.microphone);
    }
    return granted;
  }

  /// 检查权限状态
  /// 中文：加载或刷新当前功能所需数据，并在失败时保留可用的兜底状态。
  /// English: Loads or refreshes data required by this feature and keeps usable fallback state when requests fail.
  Future<bool> checkPermission(Permission permission) async {
    final status = await permission.status;
    return status.isGranted;
  }

  /// 权限被拒绝时弹窗
  /// 中文：执行 showPermissionDeniedDialog 对应的业务步骤，并把内部细节封装在当前模块内。
  /// English: Executes the showPermissionDeniedDialog business step while keeping internal details encapsulated in this module.
  void _showPermissionDeniedDialog(Permission permission) {
    final permissionName = _getPermissionName(permission);
    Get.dialog(
      AlertDialog(
        title: Text('permission_denied'.tr),
        content: Text('$permissionName\n${'permission_rationale'.tr}'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('cancel'.tr)),
          TextButton(
            onPressed: () {
              Get.back();
              openAppSettings();
            },
            child: Text('permission_go_settings'.tr),
          ),
        ],
      ),
    );
  }

  /// 中文：根据当前输入计算并返回调用方需要的派生值。
  /// English: Computes and returns the derived value required by the caller from the current input.
  String _getPermissionName(Permission permission) {
    switch (permission) {
      case Permission.camera:
        return 'permission_camera'.tr;
      case Permission.photos:
        return 'permission_gallery'.tr;
      case Permission.location:
      case Permission.locationAlways:
      case Permission.locationWhenInUse:
        return 'permission_location'.tr;
      case Permission.notification:
        return 'permission_notification'.tr;
      case Permission.storage:
        return 'permission_storage'.tr;
      case Permission.microphone:
        return 'Microphone';
      default:
        return permission.toString();
    }
  }
}
