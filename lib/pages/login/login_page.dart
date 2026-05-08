// 中文：本文件承载登录页面逻辑，负责账号、手机、邮箱、测试账号和第三方登录入口。
// English: This file owns the Login page logic for account, phone, email, test-account, and third-party login paths.
//
// 中文：本文件的注释统一采用“上中文、下英文”的双语顺序，不能使用 ASCII 转码代替中文。
// English: Comments in this file keep Chinese above English and use real Chinese characters instead of ASCII escapes.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:soys_app/app/routes/app_routes.dart';
import 'package:soys_app/app/theme/app_theme.dart';
import 'package:soys_app/core/constants/env_config.dart';
import 'package:soys_app/pages/login/login_controller.dart';

/// 中文：构建 LoginPage 对应的页面界面，并把用户操作转交给控制器处理。
/// English: LoginPage builds its page UI and delegates user actions to the controller.
class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  /// 中文：构建当前组件的界面树，并根据响应式状态刷新可见内容。
  /// English: Builds the widget tree for this component and refreshes visible content from reactive state.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              SizedBox(height: 60.h),
              _buildLogo(),
              SizedBox(height: 40.h),
              _buildTabBar(),
              SizedBox(height: 20.h),
              SizedBox(
                height: 280.h,
                child: TabBarView(
                  controller: controller.tabController,
                  children: [
                    _buildAccountLogin(),
                    _buildPhoneLogin(),
                    _buildEmailLogin(),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              _buildLoginButton(),
              if (Environments.current.allowLocalTestLogin) ...[
                SizedBox(height: 16.h),
                _buildTestAccountButton(),
              ],
              SizedBox(height: 24.h),
              _buildThirdPartyLogin(),
              SizedBox(height: 16.h),
              _buildBottomLinks(),
            ],
          ),
        ),
      ),
    );
  }

  /// 中文：构建当前页面中的局部 UI 片段，保持主构建方法结构清晰。
  /// English: Builds a focused UI section in the page so the main build method stays readable.
  Widget _buildLogo() {
    return Column(
      children: [
        Icon(Icons.rocket_launch, size: 64.sp, color: AppTheme.primaryColor),
        SizedBox(height: 12.h),
        Text(
          'app_name'.tr,
          style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  /// 中文：构建当前页面中的局部 UI 片段，保持主构建方法结构清晰。
  /// English: Builds a focused UI section in the page so the main build method stays readable.
  Widget _buildTabBar() {
    return AnimatedBuilder(
      animation: controller.tabController,
      builder: (context, child) => Row(
        children: [
          _buildTabItem('account'.tr, 0),
          _buildTabItem('phone'.tr, 1),
          _buildTabItem('email'.tr, 2),
        ],
      ),
    );
  }

  /// 中文：构建当前页面中的局部 UI 片段，保持主构建方法结构清晰。
  /// English: Builds a focused UI section in the page so the main build method stays readable.
  Widget _buildTabItem(String text, int index) {
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.tabController.animateTo(index),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: controller.tabController.index == index
                    ? AppTheme.primaryColor
                    : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15.sp,
              color: controller.tabController.index == index
                  ? AppTheme.primaryColor
                  : AppTheme.textHint,
              fontWeight: controller.tabController.index == index
                  ? FontWeight.w600
                  : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  /// 中文：构建当前页面中的局部 UI 片段，保持主构建方法结构清晰。
  /// English: Builds a focused UI section in the page so the main build method stays readable.
  Widget _buildAccountLogin() {
    return Column(
      children: [
        TextField(
          controller: controller.accountController,
          decoration: InputDecoration(
            hintText: 'account_hint'.tr,
            prefixIcon: const Icon(Icons.person_outline),
          ),
        ),
        SizedBox(height: 16.h),
        Obx(
          () => TextField(
            controller: controller.passwordController,
            obscureText: !controller.isPasswordVisible,
            decoration: InputDecoration(
              hintText: 'password_hint'.tr,
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  controller.isPasswordVisible
                      ? Icons.visibility_off
                      : Icons.visibility,
                ),
                onPressed: controller.togglePasswordVisibility,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// 中文：构建当前页面中的局部 UI 片段，保持主构建方法结构清晰。
  /// English: Builds a focused UI section in the page so the main build method stays readable.
  Widget _buildPhoneLogin() {
    return Column(
      children: [
        TextField(
          controller: controller.phoneController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            hintText: 'phone_hint'.tr,
            prefixIcon: const Icon(Icons.phone_android),
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller.smsCodeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'sms_code_hint'.tr,
                  prefixIcon: const Icon(Icons.sms_outlined),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Obx(
              () => SizedBox(
                width: 120.w,
                child: ElevatedButton(
                  onPressed: controller.canSendSms
                      ? controller.sendSmsCode
                      : null,
                  child: Text(
                    controller.canSendSms
                        ? 'get_sms_code'.tr
                        : '${controller.smsCountdown}s',
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// 中文：构建当前页面中的局部 UI 片段，保持主构建方法结构清晰。
  /// English: Builds a focused UI section in the page so the main build method stays readable.
  Widget _buildEmailLogin() {
    return Column(
      children: [
        TextField(
          controller: controller.emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: 'email_hint'.tr,
            prefixIcon: const Icon(Icons.email_outlined),
          ),
        ),
        SizedBox(height: 16.h),
        Obx(
          () => TextField(
            controller: controller.emailPasswordController,
            obscureText: !controller.isEmailPasswordVisible,
            decoration: InputDecoration(
              hintText: 'password_hint'.tr,
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  controller.isEmailPasswordVisible
                      ? Icons.visibility_off
                      : Icons.visibility,
                ),
                onPressed: controller.toggleEmailPasswordVisibility,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// 中文：构建当前页面中的局部 UI 片段，保持主构建方法结构清晰。
  /// English: Builds a focused UI section in the page so the main build method stays readable.
  Widget _buildLoginButton() {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        height: 48.h,
        child: ElevatedButton(
          onPressed: controller.isLoading ? null : _onLogin,
          child: controller.isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Text('login'.tr, style: TextStyle(fontSize: 16.sp)),
        ),
      ),
    );
  }

  /// 中文：执行 onLogin 对应的业务步骤，并把内部细节封装在当前模块内。
  /// English: Executes the onLogin business step while keeping internal details encapsulated in this module.
  void _onLogin() {
    final index = controller.tabController.index;
    switch (index) {
      case 0:
        controller.loginWithAccount();
        break;
      case 1:
        controller.loginWithPhone();
        break;
      case 2:
        controller.loginWithEmail();
        break;
    }
  }

  /// 中文：构建当前页面中的局部 UI 片段，保持主构建方法结构清晰。
  /// English: Builds a focused UI section in the page so the main build method stays readable.
  Widget _buildTestAccountButton() {
    return SizedBox(
      width: double.infinity,
      height: 48.h,
      child: OutlinedButton(
        onPressed: controller.loginWithTestAccount,
        child: Text('test_account'.tr, style: TextStyle(fontSize: 16.sp)),
      ),
    );
  }

  /// 中文：构建当前页面中的局部 UI 片段，保持主构建方法结构清晰。
  /// English: Builds a focused UI section in the page so the main build method stays readable.
  Widget _buildThirdPartyLogin() {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(child: Divider()),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                'other_login'.tr,
                style: TextStyle(color: AppTheme.textHint, fontSize: 13.sp),
              ),
            ),
            const Expanded(child: Divider()),
          ],
        ),
        SizedBox(height: 20.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSocialButton(
              Icons.wechat,
              Colors.green,
              controller.loginWithWeChat,
            ),
            SizedBox(width: 40.w),
            _buildSocialButton(
              Icons.chat_bubble,
              Colors.lightBlue,
              controller.loginWithQQ,
            ),
            SizedBox(width: 40.w),
            _buildSocialButton(
              Icons.apple,
              Colors.black,
              controller.loginWithApple,
            ),
          ],
        ),
      ],
    );
  }

  /// 中文：构建当前页面中的局部 UI 片段，保持主构建方法结构清晰。
  /// English: Builds a focused UI section in the page so the main build method stays readable.
  Widget _buildSocialButton(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48.w,
        height: 48.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppTheme.borderColor),
        ),
        child: Icon(icon, color: color, size: 24.sp),
      ),
    );
  }

  /// 中文：构建当前页面中的局部 UI 片段，保持主构建方法结构清晰。
  /// English: Builds a focused UI section in the page so the main build method stays readable.
  Widget _buildBottomLinks() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () => Get.toNamed(AppRoutes.register),
          child: Text('register'.tr),
        ),
        TextButton(
          onPressed: controller.forgotPassword,
          child: Text('forgot_password'.tr),
        ),
      ],
    );
  }
}
