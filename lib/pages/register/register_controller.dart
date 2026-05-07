// 中文：本文件承载注册页面逻辑，负责手机号注册、邮箱注册、验证码倒计时、协议勾选和表单校验。
// English: This file owns the Register page logic for phone signup, email signup, SMS countdown, agreement checks, and form validation.
//
// 中文：本文件的注释统一采用“上中文、下英文”的双语顺序，不能使用 ASCII 转码代替中文。
// English: Comments in this file keep Chinese above English and use real Chinese characters instead of ASCII escapes.

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:soys_app/app/routes/app_routes.dart';
import 'package:soys_app/components/toast/app_toast.dart';
import 'package:soys_app/core/constants/app_constants.dart';
import 'package:soys_app/services/auth/auth_service.dart';

/// 注册控制器
/// 中文：管理 RegisterController 对应页面或功能的状态、数据加载和用户交互。
/// English: RegisterController manages state, data loading, and user interactions for its related page or feature.
class RegisterController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  // 注册方式：0-手机号, 1-邮箱
  final _registerType = 0.obs;
  int get registerType => _registerType.value;

  // 手机号注册表单
  final phoneController = TextEditingController();
  final smsCodeController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // 邮箱注册表单
  final emailController = TextEditingController();
  final emailPasswordController = TextEditingController();
  final emailConfirmPasswordController = TextEditingController();

  // 焦点
  final phoneFocus = FocusNode();
  final smsCodeFocus = FocusNode();
  final passwordFocus = FocusNode();
  final confirmPasswordFocus = FocusNode();
  final emailFocus = FocusNode();
  final emailPasswordFocus = FocusNode();
  final emailConfirmPasswordFocus = FocusNode();

  // 密码可见性
  final _obscurePassword = true.obs;
  bool get obscurePassword => _obscurePassword.value;
  final _obscureConfirmPassword = true.obs;
  bool get obscureConfirmPassword => _obscureConfirmPassword.value;

  // 验证码倒计时
  final _smsCountdown = 0.obs;
  int get smsCountdown => _smsCountdown.value;
  bool get canSendSms => _smsCountdown.value == 0;

  // 加载状态
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  // 协议勾选
  final _agreementAccepted = false.obs;
  bool get agreementAccepted => _agreementAccepted.value;

  /// 中文：释放当前对象持有的控制器、监听器或异步资源，避免页面销毁后继续占用资源。
  /// English: Releases controllers, listeners, or async resources held by this object so they do not outlive the page.
  @override
  void onClose() {
    phoneController.dispose();
    smsCodeController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    emailController.dispose();
    emailPasswordController.dispose();
    emailConfirmPasswordController.dispose();
    phoneFocus.dispose();
    smsCodeFocus.dispose();
    passwordFocus.dispose();
    confirmPasswordFocus.dispose();
    emailFocus.dispose();
    emailPasswordFocus.dispose();
    emailConfirmPasswordFocus.dispose();
    super.onClose();
  }

  // ========== 切换注册方式 ==========

  /// 中文：更新当前功能状态或持久化数据，并确保界面和本地缓存保持一致。
  /// English: Updates feature state or persisted data while keeping the UI and local cache consistent.
  void setRegisterType(int type) {
    _registerType.value = type;
  }

  // ========== 密码可见性 ==========

  /// 中文：更新当前功能状态或持久化数据，并确保界面和本地缓存保持一致。
  /// English: Updates feature state or persisted data while keeping the UI and local cache consistent.
  void togglePasswordVisibility() {
    _obscurePassword.value = !_obscurePassword.value;
  }

  /// 中文：更新当前功能状态或持久化数据，并确保界面和本地缓存保持一致。
  /// English: Updates feature state or persisted data while keeping the UI and local cache consistent.
  void toggleConfirmPasswordVisibility() {
    _obscureConfirmPassword.value = !_obscureConfirmPassword.value;
  }

  // ========== 协议勾选 ==========

  /// 中文：更新当前功能状态或持久化数据，并确保界面和本地缓存保持一致。
  /// English: Updates feature state or persisted data while keeping the UI and local cache consistent.
  void toggleAgreement() {
    _agreementAccepted.value = !_agreementAccepted.value;
  }

  // ========== 发送验证码 ==========

  /// 中文：处理账号认证相关流程，并把接口结果、加载状态和页面跳转保持同步。
  /// English: Handles account-authentication flow while keeping API results, loading state, and navigation in sync.
  Future<void> sendSmsCode() async {
    final phone = phoneController.text.trim();
    final regex = RegExp(AppConstants.phoneRegex);
    if (phone.isEmpty || !regex.hasMatch(phone)) {
      AppToast.showWarning('phone_invalid'.tr);
      return;
    }

    AppToast.showLoading();
    final response = await _authService.sendSmsCode(phone);
    AppToast.dismissLoading();

    if (response.isSuccess) {
      AppToast.showSuccess('sms_sent'.tr);
      _startCountdown();
    } else {
      AppToast.showError(response.message);
    }
  }

  /// 中文：执行 startCountdown 对应的业务步骤，并把内部细节封装在当前模块内。
  /// English: Executes the startCountdown business step while keeping internal details encapsulated in this module.
  void _startCountdown() {
    _smsCountdown.value = AppConstants.smsCountdown;
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (_smsCountdown.value <= 1) {
        _smsCountdown.value = 0;
        return false;
      }
      _smsCountdown.value--;
      return true;
    });
  }

  // ========== 注册 ==========

  /// 中文：处理账号认证相关流程，并把接口结果、加载状态和页面跳转保持同步。
  /// English: Handles account-authentication flow while keeping API results, loading state, and navigation in sync.
  Future<void> register() async {
    if (!_agreementAccepted.value) {
      AppToast.showWarning('agreement_title'.tr);
      return;
    }

    if (registerType == 0) {
      await _registerWithPhone();
    } else {
      await _registerWithEmail();
    }
  }

  /// 中文：处理账号认证相关流程，并把接口结果、加载状态和页面跳转保持同步。
  /// English: Handles account-authentication flow while keeping API results, loading state, and navigation in sync.
  Future<void> _registerWithPhone() async {
    final phone = phoneController.text.trim();
    final code = smsCodeController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    // 校验
    final phoneRegex = RegExp(AppConstants.phoneRegex);
    if (phone.isEmpty || !phoneRegex.hasMatch(phone)) {
      AppToast.showWarning('phone_invalid'.tr);
      return;
    }
    if (code.isEmpty || code.length < 4) {
      AppToast.showWarning('sms_code_hint'.tr);
      return;
    }
    final passwordRegex = RegExp(AppConstants.passwordRegex);
    if (password.isEmpty || !passwordRegex.hasMatch(password)) {
      AppToast.showWarning('password_invalid'.tr);
      return;
    }
    if (password != confirmPassword) {
      AppToast.showWarning('password_not_match'.tr);
      return;
    }

    _isLoading.value = true;
    AppToast.showLoading();

    final response = await _authService.register(
      account: phone,
      password: password,
      phone: phone,
      smsCode: code,
    );

    AppToast.dismissLoading();
    _isLoading.value = false;

    if (response.isSuccess) {
      AppToast.showSuccess('register_success'.tr);
      Get.offAllNamed(AppRoutes.main);
    } else {
      AppToast.showError(response.message);
    }
  }

  /// 中文：处理账号认证相关流程，并把接口结果、加载状态和页面跳转保持同步。
  /// English: Handles account-authentication flow while keeping API results, loading state, and navigation in sync.
  Future<void> _registerWithEmail() async {
    final email = emailController.text.trim();
    final password = emailPasswordController.text.trim();
    final confirmPassword = emailConfirmPasswordController.text.trim();

    // 校验
    final emailRegex = RegExp(AppConstants.emailRegex);
    if (email.isEmpty || !emailRegex.hasMatch(email)) {
      AppToast.showWarning('email_invalid'.tr);
      return;
    }
    final passwordRegex = RegExp(AppConstants.passwordRegex);
    if (password.isEmpty || !passwordRegex.hasMatch(password)) {
      AppToast.showWarning('password_invalid'.tr);
      return;
    }
    if (password != confirmPassword) {
      AppToast.showWarning('password_not_match'.tr);
      return;
    }

    _isLoading.value = true;
    AppToast.showLoading();

    final response = await _authService.register(
      account: email,
      password: password,
      email: email,
    );

    AppToast.dismissLoading();
    _isLoading.value = false;

    if (response.isSuccess) {
      AppToast.showSuccess('register_success'.tr);
      Get.offAllNamed(AppRoutes.main);
    } else {
      AppToast.showError(response.message);
    }
  }

  /// 返回登录
  /// 中文：处理导航、桥接或事件分发动作，统一外部交互入口。
  /// English: Handles navigation, bridge, or event-dispatch actions through a single interaction entry point.
  void goToLogin() {
    Get.back();
  }
}
