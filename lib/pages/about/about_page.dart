// 中文：本文件承载关于页面逻辑，负责版本信息、隐私协议、用户协议和更新检查入口。
// English: This file owns the About page logic for version info, privacy policy, terms, and update checks.
//
// 中文：本文件的注释统一采用“上中文、下英文”的双语顺序，不能使用 ASCII 转码代替中文。
// English: Comments in this file keep Chinese above English and use real Chinese characters instead of ASCII escapes.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:soys_app/app/routes/app_routes.dart';
import 'package:soys_app/app/theme/app_theme.dart';
import 'package:soys_app/core/constants/app_constants.dart';
import 'package:soys_app/services/device/device_service.dart';
import 'package:soys_app/services/update/update_service.dart';

/// 中文：管理 AboutController 对应页面或功能的状态、数据加载和用户交互。
/// English: AboutController manages state, data loading, and user interactions for its related page or feature.
class AboutController extends GetxController {
  final DeviceService _device = Get.find<DeviceService>();
  final UpdateService _update = Get.find<UpdateService>();

  final _version = ''.obs;
  final _buildNumber = ''.obs;
  final _isCheckingUpdate = false.obs;

  String get version => _version.value;
  String get buildNumber => _buildNumber.value;
  bool get isCheckingUpdate => _isCheckingUpdate.value;

  /// 中文：完成当前对象的初始化流程，确保依赖、监听器或初始数据在使用前准备好。
  /// English: Initializes the current object so dependencies, listeners, or initial data are ready before use.
  @override
  void onInit() {
    super.onInit();
    _loadAppInfo();
  }

  /// 中文：加载或刷新当前功能所需数据，并在失败时保留可用的兜底状态。
  /// English: Loads or refreshes data required by this feature and keeps usable fallback state when requests fail.
  void _loadAppInfo() async {
    _version.value = await _device.getVersion();
    _buildNumber.value = await _device.getBuildNumber();
  }

  /// 中文：加载或刷新当前功能所需数据，并在失败时保留可用的兜底状态。
  /// English: Loads or refreshes data required by this feature and keeps usable fallback state when requests fail.
  Future<void> checkUpdate() async {
    _isCheckingUpdate.value = true;
    final updateInfo = await _update.checkUpdate();
    _isCheckingUpdate.value = false;

    if (updateInfo != null) {
      await _update.showUpdateDialog(updateInfo);
    } else {
      Get.snackbar(
        'check_update'.tr,
        'no_update'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.successColor,
        colorText: Colors.white,
      );
    }
  }

  /// 中文：处理导航、桥接或事件分发动作，统一外部交互入口。
  /// English: Handles navigation, bridge, or event-dispatch actions through a single interaction entry point.
  void openPrivacy() {
    _openAgreementPage('隐私协议', AppConstants.privacyUrl);
  }

  /// 中文：处理导航、桥接或事件分发动作，统一外部交互入口。
  /// English: Handles navigation, bridge, or event-dispatch actions through a single interaction entry point.
  void openTerms() {
    _openAgreementPage('用户协议', AppConstants.termsUrl);
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

/// 中文：构建 AboutPage 对应的页面界面，并把用户操作转交给控制器处理。
/// English: AboutPage builds its page UI and delegates user actions to the controller.
class AboutPage extends GetView<AboutController> {
  const AboutPage({super.key});

  /// 中文：构建当前组件的界面树，并根据响应式状态刷新可见内容。
  /// English: Builds the widget tree for this component and refreshes visible content from reactive state.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('about'.tr)),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            SizedBox(height: 40.h),
            Icon(
              Icons.rocket_launch,
              size: 72.sp,
              color: AppTheme.primaryColor,
            ),
            SizedBox(height: 16.h),
            Text(
              'SOYS App',
              style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.h),
            Obx(
              () => Text(
                'v${controller.version} (${controller.buildNumber})',
                style: TextStyle(fontSize: 14.sp, color: AppTheme.textHint),
              ),
            ),
            SizedBox(height: 40.h),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                children: [
                  Obx(
                    () => ListTile(
                      leading: const Icon(
                        Icons.system_update_outlined,
                        color: AppTheme.textSecondary,
                      ),
                      title: Text(
                        'check_update'.tr,
                        style: TextStyle(fontSize: 15.sp),
                      ),
                      trailing: controller.isCheckingUpdate
                          ? SizedBox(
                              width: 16.w,
                              height: 16.w,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : Icon(
                              Icons.arrow_forward_ios,
                              size: 14.sp,
                              color: AppTheme.textHint,
                            ),
                      onTap: controller.isCheckingUpdate
                          ? null
                          : controller.checkUpdate,
                    ),
                  ),
                  Divider(height: 1.h, indent: 56.w),
                  ListTile(
                    leading: const Icon(
                      Icons.privacy_tip_outlined,
                      color: AppTheme.textSecondary,
                    ),
                    title: Text(
                      'privacy'.tr,
                      style: TextStyle(fontSize: 15.sp),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 14.sp,
                      color: AppTheme.textHint,
                    ),
                    onTap: controller.openPrivacy,
                  ),
                  Divider(height: 1.h, indent: 56.w),
                  ListTile(
                    leading: const Icon(
                      Icons.description_outlined,
                      color: AppTheme.textSecondary,
                    ),
                    title: Text('terms'.tr, style: TextStyle(fontSize: 15.sp)),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 14.sp,
                      color: AppTheme.textHint,
                    ),
                    onTap: controller.openTerms,
                  ),
                ],
              ),
            ),
            SizedBox(height: 40.h),
            Text(
              '© 2026 SOYS. All rights reserved.',
              style: TextStyle(fontSize: 12.sp, color: AppTheme.textHint),
            ),
          ],
        ),
      ),
    );
  }
}
