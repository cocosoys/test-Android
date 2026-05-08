// 中文：本文件承载启动页逻辑，负责启动延迟、用户协议确认、登录态判断和首屏路由跳转。
// English: This file owns the Splash page logic for startup delay, agreement confirmation, auth-state checks, and first-route navigation.
//
// 中文：本文件的注释统一采用“上中文、下英文”的双语顺序，不能使用 ASCII 转码代替中文。
// English: Comments in this file keep Chinese above English and use real Chinese characters instead of ASCII escapes.

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:soys_app/app/routes/app_routes.dart';
import 'package:soys_app/app/theme/app_theme.dart';
import 'package:soys_app/core/constants/env_config.dart';
import 'package:soys_app/services/auth/auth_service.dart';
import 'package:soys_app/services/storage/storage_service.dart';

/// 中文：构建 SplashPage 对应的页面界面，并把用户操作转交给控制器处理。
/// English: SplashPage builds its page UI and delegates user actions to the controller.
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

/// 中文：承载 SplashPageState 的核心职责，配合当前文件完成对应业务或界面逻辑。
/// English: SplashPageState carries its core responsibility and supports the business or UI logic in this file.
class _SplashPageState extends State<SplashPage> {
  final StorageService _storage = Get.find<StorageService>();
  final AuthService _auth = Get.find<AuthService>();

  /// 中文：完成当前对象的初始化流程，确保依赖、监听器或初始数据在使用前准备好。
  /// English: Initializes the current object so dependencies, listeners, or initial data are ready before use.
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _init();
      }
    });
  }

  /// 中文：完成当前对象的初始化流程，确保依赖、监听器或初始数据在使用前准备好。
  /// English: Initializes the current object so dependencies, listeners, or initial data are ready before use.
  Future<void> _init() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    if (!_storage.isAgreementAccepted) {
      await _showAgreementDialog();
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
  Future<void> _showAgreementDialog() async {
    await Get.dialog<void>(
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
                onTap: () =>
                    _openAgreementPage('用户协议', Environments.current.termsUrl),
                child: Text(
                  'terms'.tr,
                  style: const TextStyle(color: AppTheme.primaryColor),
                ),
              ),
              Text('agreement_and'.tr),
              GestureDetector(
                onTap: () =>
                    _openAgreementPage('隐私协议', Environments.current.privacyUrl),
                child: Text(
                  'privacy'.tr,
                  style: const TextStyle(color: AppTheme.primaryColor),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back<void>(),
              child: Text('agreement_disagree'.tr),
            ),
            ElevatedButton(
              onPressed: () async {
                await _storage.setAgreementAccepted(true);
                if (Get.isDialogOpen == true) {
                  Get.back<void>();
                }
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

  /// 中文：构建当前组件的界面树，并根据响应式状态刷新可见内容。
  /// English: Builds the widget tree for this component and refreshes visible content from reactive state.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.rocket_launch,
              size: 80,
              color: Colors.white.withValues(alpha: 0.9),
            ),
            const SizedBox(height: 16),
            const Text(
              'SOYS App',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'loading'.tr,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
