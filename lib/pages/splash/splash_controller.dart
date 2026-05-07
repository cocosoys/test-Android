// 中文：本文件承载启动页逻辑，负责启动延迟、用户协议确认、登录态判断和首屏路由跳转。
// English: This file owns the Splash page logic for startup delay, agreement confirmation, auth-state checks, and first-route navigation.
//
// 中文：本文件的注释统一采用“上中文、下英文”的双语顺序，不能使用 ASCII 转码代替中文。
// English: Comments in this file keep Chinese above English and use real Chinese characters instead of ASCII escapes.

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:soys_app/app/routes/app_routes.dart';
import 'package:soys_app/app/theme/app_theme.dart';
import 'package:soys_app/core/constants/app_constants.dart';
import 'package:soys_app/services/auth/auth_service.dart';
import 'package:soys_app/services/storage/storage_service.dart';

/// 中文：管理 SplashController 对应页面或功能的状态、数据加载和用户交互。
/// English: SplashController manages state, data loading, and user interactions for its related page or feature.
class SplashController extends GetxController {
  final StorageService _storage = Get.find<StorageService>();
  final AuthService _auth = Get.find<AuthService>();
  bool _started = false;

  /// 中文：完成当前对象的初始化流程，确保依赖、监听器或初始数据在使用前准备好。
  /// English: Initializes the current object so dependencies, listeners, or initial data are ready before use.
  @override
  void onInit() {
    super.onInit();
    start();
  }

  /// 中文：执行 start 对应的业务步骤，并把内部细节封装在当前模块内。
  /// English: Executes the start business step while keeping internal details encapsulated in this module.
  void start() {
    if (_started) return;
    _started = true;
    _init();
  }

  /// 中文：完成当前对象的初始化流程，确保依赖、监听器或初始数据在使用前准备好。
  /// English: Initializes the current object so dependencies, listeners, or initial data are ready before use.
  Future<void> _init() async {
    await Future.delayed(const Duration(seconds: 2));

    // 检查协议是否同意
    if (!_storage.isAgreementAccepted) {
      _showAgreementDialog();
      return;
    }

    _navigateToNext();
  }

  /// 中文：执行 navigateToNext 对应的业务步骤，并把内部细节封装在当前模块内。
  /// English: Executes the navigateToNext business step while keeping internal details encapsulated in this module.
  void _navigateToNext() {
    if (_auth.isLoggedIn) {
      Get.offAllNamed(AppRoutes.main);
    } else {
      Get.offAllNamed(AppRoutes.login);
    }
  }

  /// 中文：执行 showAgreementDialog 对应的业务步骤，并把内部细节封装在当前模块内。
  /// English: Executes the showAgreementDialog business step while keeping internal details encapsulated in this module.
  void _showAgreementDialog() {
    Get.dialog(
      PopScope(
        canPop: false,
        child: AlertDialog(
          title: Text('agreement_title'.tr),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('agreement_content'.tr),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => _openAgreementPage('用户协议', AppConstants.termsUrl),
                child: Text(
                  'terms'.tr,
                  style: const TextStyle(color: AppTheme.primaryColor),
                ),
              ),
              Text('agreement_and'.tr),
              GestureDetector(
                onTap: () =>
                    _openAgreementPage('隐私协议', AppConstants.privacyUrl),
                child: Text(
                  'privacy'.tr,
                  style: const TextStyle(color: AppTheme.primaryColor),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text('agreement_disagree'.tr),
            ),
            ElevatedButton(
              onPressed: () async {
                await _storage.setAgreementAccepted(true);
                Get.back();
                _navigateToNext();
              },
              child: Text('agreement_accept'.tr),
            ),
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }

  /// 中文：处理导航、桥接或事件分发动作，统一外部交互入口。
  /// English: Handles navigation, bridge, or event-dispatch actions through a single interaction entry point.
  void _openAgreementPage(String title, String url) {
    Get.toNamed(
      '${AppRoutes.webview}?title=${Uri.encodeComponent(title)}'
      '&url=${Uri.encodeComponent(url)}',
    );
  }
}
