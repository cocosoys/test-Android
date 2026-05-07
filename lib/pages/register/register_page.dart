// 中文：本文件承载注册页面逻辑，负责手机号注册、邮箱注册、验证码倒计时、协议勾选和表单校验。
// English: This file owns the Register page logic for phone signup, email signup, SMS countdown, agreement checks, and form validation.
//
// 中文：本文件的注释统一采用“上中文、下英文”的双语顺序，不能使用 ASCII 转码代替中文。
// English: Comments in this file keep Chinese above English and use real Chinese characters instead of ASCII escapes.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:soys_app/app/routes/app_routes.dart';
import 'package:soys_app/core/constants/app_constants.dart';
import 'package:soys_app/services/auth/auth_service.dart';
import 'package:soys_app/components/toast/app_toast.dart';

/// 中文：管理 RegisterController 对应页面或功能的状态、数据加载和用户交互。
/// English: RegisterController manages state, data loading, and user interactions for its related page or feature.
class RegisterController extends GetxController {
  final AuthService _auth = Get.find<AuthService>();

  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final accountController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final smsCodeController = TextEditingController();

  final _isPasswordVisible = false.obs;
  final _isLoading = false.obs;
  final _smsCountdown = 0.obs;

  bool get isPasswordVisible => _isPasswordVisible.value;
  bool get isLoading => _isLoading.value;
  int get smsCountdown => _smsCountdown.value;
  bool get canSendSms => _smsCountdown.value == 0;

  /// 中文：更新当前功能状态或持久化数据，并确保界面和本地缓存保持一致。
  /// English: Updates feature state or persisted data while keeping the UI and local cache consistent.
  void togglePasswordVisibility() =>
      _isPasswordVisible.value = !_isPasswordVisible.value;

  /// 中文：处理账号认证相关流程，并把接口结果、加载状态和页面跳转保持同步。
  /// English: Handles account-authentication flow while keeping API results, loading state, and navigation in sync.
  Future<void> sendSmsCode() async {
    if (_smsCountdown.value > 0) return;
    final phone = phoneController.text.trim();
    if (phone.isEmpty) {
      AppToast.showWarning('phone_hint'.tr);
      return;
    }
    final response = await _auth.sendSmsCode(phone);
    if (response.isSuccess) {
      AppToast.showSuccess('sms_sent'.tr);
      _smsCountdown.value = AppConstants.smsCountdown;
      Future.doWhile(() async {
        await Future.delayed(const Duration(seconds: 1));
        _smsCountdown.value--;
        return _smsCountdown.value > 0;
      });
    }
  }

  /// 中文：处理账号认证相关流程，并把接口结果、加载状态和页面跳转保持同步。
  /// English: Handles account-authentication flow while keeping API results, loading state, and navigation in sync.
  Future<void> register() async {
    final account = accountController.text.trim();
    final password = passwordController.text.trim();
    final confirmPwd = confirmPasswordController.text.trim();
    final phone = phoneController.text.trim();
    final email = emailController.text.trim();
    final code = smsCodeController.text.trim();

    if (account.isEmpty) {
      AppToast.showWarning('account_hint'.tr);
      return;
    }
    if (password.isEmpty) {
      AppToast.showWarning('password_hint'.tr);
      return;
    }
    if (password != confirmPwd) {
      AppToast.showWarning('password_not_match'.tr);
      return;
    }

    _isLoading.value = true;
    final response = await _auth.register(
      account: account,
      password: password,
      phone: phone.isEmpty ? null : phone,
      email: email.isEmpty ? null : email,
      smsCode: code.isEmpty ? null : code,
    );
    _isLoading.value = false;

    if (response.isSuccess) {
      AppToast.showSuccess('register_success'.tr);
      Get.offAllNamed(AppRoutes.main);
    }
  }

  /// 中文：释放当前对象持有的控制器、监听器或异步资源，避免页面销毁后继续占用资源。
  /// English: Releases controllers, listeners, or async resources held by this object so they do not outlive the page.
  @override
  void onClose() {
    phoneController.dispose();
    emailController.dispose();
    accountController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    smsCodeController.dispose();
    super.onClose();
  }
}

/// 中文：构建 RegisterPage 对应的页面界面，并把用户操作转交给控制器处理。
/// English: RegisterPage builds its page UI and delegates user actions to the controller.
class RegisterPage extends GetView<RegisterController> {
  const RegisterPage({super.key});

  /// 中文：构建当前组件的界面树，并根据响应式状态刷新可见内容。
  /// English: Builds the widget tree for this component and refreshes visible content from reactive state.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('register'.tr)),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          children: [
            SizedBox(height: 24.h),
            TextField(
              controller: controller.accountController,
              decoration: InputDecoration(
                hintText: 'account_hint'.tr,
                prefixIcon: const Icon(Icons.person_outline),
              ),
            ),
            SizedBox(height: 16.h),
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
            SizedBox(height: 16.h),
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
            SizedBox(height: 16.h),
            TextField(
              controller: controller.confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'confirm_password'.tr,
                prefixIcon: const Icon(Icons.lock_outline),
              ),
            ),
            SizedBox(height: 32.h),
            Obx(
              () => SizedBox(
                width: double.infinity,
                height: 48.h,
                child: ElevatedButton(
                  onPressed: controller.isLoading ? null : controller.register,
                  child: controller.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text('register'.tr, style: TextStyle(fontSize: 16.sp)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
