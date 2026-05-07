// 中文：本文件封装扫码服务，统一二维码控制器、相机权限、闪光灯切换和摄像头切换。
// English: This file wraps scanner logic for the QR controller, camera permission, torch toggling, and camera switching.
//
// 中文：本文件的注释统一采用“上中文、下英文”的双语顺序，不能使用 ASCII 转码代替中文。
// English: Comments in this file keep Chinese above English and use real Chinese characters instead of ASCII escapes.

import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'package:soys_app/core/permission/permission_service.dart';

/// 扫码服务
/// 中文：封装 ScannerService 对应的跨页面服务能力，避免业务层直接依赖底层实现。
/// English: ScannerService encapsulates cross-page service capabilities so feature code does not depend on low-level details directly.
class ScannerService extends GetxService {
  final PermissionService _permission = Get.find<PermissionService>();

  MobileScannerController? _controller;

  MobileScannerController get controller {
    _controller ??= MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
      torchEnabled: false,
    );
    return _controller!;
  }

  /// 请求相机权限
  /// 中文：调用系统、文件或平台能力，并向业务层返回统一的处理结果。
  /// English: Invokes system, file, or platform capabilities and returns normalized results to feature code.
  Future<bool> requestPermission() async {
    return await _permission.requestCamera();
  }

  /// 切换闪光灯
  /// 中文：更新当前功能状态或持久化数据，并确保界面和本地缓存保持一致。
  /// English: Updates feature state or persisted data while keeping the UI and local cache consistent.
  void toggleTorch() {
    controller.toggleTorch();
  }

  /// 切换前后摄像头
  /// 中文：执行 switchCamera 对应的业务步骤，并把内部细节封装在当前模块内。
  /// English: Executes the switchCamera business step while keeping internal details encapsulated in this module.
  void switchCamera() {
    controller.switchCamera();
  }

  /// 释放资源
  /// 中文：释放当前对象持有的控制器、监听器或异步资源，避免页面销毁后继续占用资源。
  /// English: Releases controllers, listeners, or async resources held by this object so they do not outlive the page.
  void dispose() {
    _controller?.dispose();
    _controller = null;
  }
}
