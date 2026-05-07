// 中文：本文件承载我的页面逻辑，负责用户卡片、个人入口、设置入口和退出登录操作。
// English: This file owns the Mine page logic for the user card, profile entry, settings entry, and logout action.
//
// 中文：本文件的注释统一采用“上中文、下英文”的双语顺序，不能使用 ASCII 转码代替中文。
// English: Comments in this file keep Chinese above English and use real Chinese characters instead of ASCII escapes.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:soys_app/app/routes/app_routes.dart';
import 'package:soys_app/app/theme/app_theme.dart';
import 'package:soys_app/models/user/user_model.dart';
import 'package:soys_app/services/auth/auth_service.dart';
import 'package:soys_app/core/utils/app_utils.dart';
import 'package:soys_app/components/toast/app_toast.dart';

/// 中文：管理 MineController 对应页面或功能的状态、数据加载和用户交互。
/// English: MineController manages state, data loading, and user interactions for its related page or feature.
class MineController extends GetxController {
  final AuthService _auth = Get.find<AuthService>();

  UserModel? get user => _auth.user;
  bool get isLoggedIn => _auth.isLoggedIn;

  /// 中文：处理导航、桥接或事件分发动作，统一外部交互入口。
  /// English: Handles navigation, bridge, or event-dispatch actions through a single interaction entry point.
  void goToProfile() => Get.toNamed(AppRoutes.profile);

  /// 中文：处理导航、桥接或事件分发动作，统一外部交互入口。
  /// English: Handles navigation, bridge, or event-dispatch actions through a single interaction entry point.
  void goToSettings() => Get.toNamed(AppRoutes.settings);

  /// 中文：处理导航、桥接或事件分发动作，统一外部交互入口。
  /// English: Handles navigation, bridge, or event-dispatch actions through a single interaction entry point.
  void goToAbout() => Get.toNamed(AppRoutes.about);

  /// 中文：处理账号认证相关流程，并把接口结果、加载状态和页面跳转保持同步。
  /// English: Handles account-authentication flow while keeping API results, loading state, and navigation in sync.
  Future<void> logout() async {
    final confirmed = await AppToast.showConfirm(
      title: 'logout'.tr,
      message: 'logout_confirm'.tr,
      isDanger: true,
    );
    if (confirmed) {
      await _auth.logout();
    }
  }
}

/// 中文：构建 MinePage 对应的页面界面，并把用户操作转交给控制器处理。
/// English: MinePage builds its page UI and delegates user actions to the controller.
class MinePage extends GetView<MineController> {
  const MinePage({super.key});

  /// 中文：构建当前组件的界面树，并根据响应式状态刷新可见内容。
  /// English: Builds the widget tree for this component and refreshes visible content from reactive state.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('tab_mine'.tr)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildUserCard(),
            SizedBox(height: 12.h),
            _buildMenuList(),
          ],
        ),
      ),
    );
  }

  /// 中文：构建当前页面中的局部 UI 片段，保持主构建方法结构清晰。
  /// English: Builds a focused UI section in the page so the main build method stays readable.
  Widget _buildUserCard() {
    return Obx(
      () => Container(
        margin: EdgeInsets.all(16.w),
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppTheme.primaryColor,
              AppTheme.primaryColor.withValues(alpha: 0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 36.r,
              backgroundColor: Colors.white.withValues(alpha: 0.3),
              backgroundImage: controller.user?.avatar != null
                  ? NetworkImage(controller.user!.avatar!)
                  : null,
              child: controller.user?.avatar == null
                  ? Icon(Icons.person, size: 36.sp, color: Colors.white)
                  : null,
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.isLoggedIn
                        ? (controller.user?.nickname ??
                              controller.user?.username ??
                              '用户')
                        : '未登录',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  if (controller.isLoggedIn && controller.user?.phone != null)
                    Text(
                      AppUtils.phoneMask(controller.user!.phone!),
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 13.sp,
                      ),
                    ),
                ],
              ),
            ),
            Icon(
              Icons.qr_code,
              color: Colors.white.withValues(alpha: 0.8),
              size: 24.sp,
            ),
          ],
        ),
      ),
    );
  }

  /// 中文：构建当前页面中的局部 UI 片段，保持主构建方法结构清晰。
  /// English: Builds a focused UI section in the page so the main build method stays readable.
  Widget _buildMenuList() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: Theme.of(Get.context!).cardColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          _buildMenuItem(
            Icons.person_outline,
            'profile'.tr,
            controller.goToProfile,
          ),
          _buildDivider(),
          _buildMenuItem(
            Icons.settings_outlined,
            'settings'.tr,
            controller.goToSettings,
          ),
          _buildDivider(),
          _buildMenuItem(Icons.info_outline, 'about'.tr, controller.goToAbout),
          _buildDivider(),
          _buildMenuItem(
            Icons.logout,
            'logout'.tr,
            controller.logout,
            color: AppTheme.errorColor,
          ),
        ],
      ),
    );
  }

  /// 中文：构建当前页面中的局部 UI 片段，保持主构建方法结构清晰。
  /// English: Builds a focused UI section in the page so the main build method stays readable.
  Widget _buildMenuItem(
    IconData icon,
    String title,
    VoidCallback onTap, {
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? AppTheme.textSecondary, size: 22.sp),
      title: Text(
        title,
        style: TextStyle(fontSize: 15.sp, color: color),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 14.sp,
        color: AppTheme.textHint,
      ),
      onTap: onTap,
    );
  }

  /// 中文：构建当前页面中的局部 UI 片段，保持主构建方法结构清晰。
  /// English: Builds a focused UI section in the page so the main build method stays readable.
  Widget _buildDivider() {
    return Padding(
      padding: EdgeInsets.only(left: 56.w),
      child: Divider(height: 1.h, color: AppTheme.dividerColor),
    );
  }
}
