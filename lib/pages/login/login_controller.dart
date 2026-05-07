// 中文：本文件承载登录页面逻辑，负责账号、手机、邮箱、测试账号和第三方登录入口。
// English: This file owns the Login page logic for account, phone, email, test-account, and third-party login paths.
//
// 中文：本文件的注释统一采用“上中文、下英文”的双语顺序，不能使用 ASCII 转码代替中文。
// English: Comments in this file keep Chinese above English and use real Chinese characters instead of ASCII escapes.

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:soys_app/app/routes/app_routes.dart';
import 'package:soys_app/core/constants/app_constants.dart';
import 'package:soys_app/services/auth/auth_service.dart';
import 'package:soys_app/components/toast/app_toast.dart';

/// 中文：管理 LoginController 对应页面或功能的状态、数据加载和用户交互。
/// English: LoginController manages state, data loading, and user interactions for its related page or feature.
class LoginController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final AuthService _auth = Get.find<AuthService>();

  late final TabController tabController;
  final accountController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final smsCodeController = TextEditingController();
  final emailController = TextEditingController();
  final emailPasswordController = TextEditingController();

  final _isPasswordVisible = false.obs;
  final _isEmailPasswordVisible = false.obs;
  final _isLoading = false.obs;
  final _smsCountdown = 0.obs;

  bool get isPasswordVisible => _isPasswordVisible.value;
  bool get isEmailPasswordVisible => _isEmailPasswordVisible.value;
  bool get isLoading => _isLoading.value;
  int get smsCountdown => _smsCountdown.value;
  bool get canSendSms => _smsCountdown.value == 0;

  /// 中文：完成当前对象的初始化流程，确保依赖、监听器或初始数据在使用前准备好。
  /// English: Initializes the current object so dependencies, listeners, or initial data are ready before use.
  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 3, vsync: this);
  }

  /// 中文：更新当前功能状态或持久化数据，并确保界面和本地缓存保持一致。
  /// English: Updates feature state or persisted data while keeping the UI and local cache consistent.
  void togglePasswordVisibility() =>
      _isPasswordVisible.value = !_isPasswordVisible.value;

  /// 中文：更新当前功能状态或持久化数据，并确保界面和本地缓存保持一致。
  /// English: Updates feature state or persisted data while keeping the UI and local cache consistent.
  void toggleEmailPasswordVisibility() =>
      _isEmailPasswordVisible.value = !_isEmailPasswordVisible.value;

  /// 账号密码登录
  /// 中文：处理账号认证相关流程，并把接口结果、加载状态和页面跳转保持同步。
  /// English: Handles account-authentication flow while keeping API results, loading state, and navigation in sync.
  Future<void> loginWithAccount() async {
    final account = accountController.text.trim();
    final password = passwordController.text.trim();

    if (account.isEmpty || password.isEmpty) {
      AppToast.showWarning('请输入账号和密码');
      return;
    }

    _isLoading.value = true;
    final response = await _auth.loginWithAccount(account, password);
    _isLoading.value = false;

    if (response.isSuccess) {
      AppToast.showSuccess('login_success'.tr);
      Get.offAllNamed(AppRoutes.main);
    }
  }

  /// 手机号登录
  /// 中文：处理账号认证相关流程，并把接口结果、加载状态和页面跳转保持同步。
  /// English: Handles account-authentication flow while keeping API results, loading state, and navigation in sync.
  Future<void> loginWithPhone() async {
    final phone = phoneController.text.trim();
    final code = smsCodeController.text.trim();

    if (phone.isEmpty || code.isEmpty) {
      AppToast.showWarning('请输入手机号和验证码');
      return;
    }

    _isLoading.value = true;
    final response = await _auth.loginWithPhone(phone, code);
    _isLoading.value = false;

    if (response.isSuccess) {
      AppToast.showSuccess('login_success'.tr);
      Get.offAllNamed(AppRoutes.main);
    }
  }

  /// 邮箱登录
  /// 中文：处理账号认证相关流程，并把接口结果、加载状态和页面跳转保持同步。
  /// English: Handles account-authentication flow while keeping API results, loading state, and navigation in sync.
  Future<void> loginWithEmail() async {
    final email = emailController.text.trim();
    final password = emailPasswordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      AppToast.showWarning('请输入邮箱和密码');
      return;
    }

    _isLoading.value = true;
    final response = await _auth.loginWithEmail(email, password);
    _isLoading.value = false;

    if (response.isSuccess) {
      AppToast.showSuccess('login_success'.tr);
      Get.offAllNamed(AppRoutes.main);
    }
  }

  /// 发送验证码
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
      _startCountdown();
    }
  }

  /// 中文：执行 startCountdown 对应的业务步骤，并把内部细节封装在当前模块内。
  /// English: Executes the startCountdown business step while keeping internal details encapsulated in this module.
  void _startCountdown() {
    _smsCountdown.value = AppConstants.smsCountdown;
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      _smsCountdown.value--;
      return _smsCountdown.value > 0;
    });
  }

  /// 测试账号登录
  /// 中文：处理账号认证相关流程，并把接口结果、加载状态和页面跳转保持同步。
  /// English: Handles account-authentication flow while keeping API results, loading state, and navigation in sync.
  Future<void> loginWithTestAccount() async {
    _isLoading.value = true;
    final response = await _auth.loginWithTestAccount();
    _isLoading.value = false;

    if (response.isSuccess) {
      AppToast.showSuccess('login_success'.tr);
      Get.offAllNamed(AppRoutes.main);
    }
  }

  /// 微信登录
  /// 中文：处理账号认证相关流程，并把接口结果、加载状态和页面跳转保持同步。
  /// English: Handles account-authentication flow while keeping API results, loading state, and navigation in sync.
  Future<void> loginWithWeChat() async {
    _openOAuthPage('wechat_login'.tr, '/auth/wechat/authorize');
  }

  /// QQ登录
  /// 中文：处理账号认证相关流程，并把接口结果、加载状态和页面跳转保持同步。
  /// English: Handles account-authentication flow while keeping API results, loading state, and navigation in sync.
  Future<void> loginWithQQ() async {
    _openOAuthPage('qq_login'.tr, '/auth/qq/authorize');
  }

  /// Apple登录
  /// 中文：处理账号认证相关流程，并把接口结果、加载状态和页面跳转保持同步。
  /// English: Handles account-authentication flow while keeping API results, loading state, and navigation in sync.
  Future<void> loginWithApple() async {
    _openOAuthPage('apple_login'.tr, '/auth/apple/authorize');
  }

  /// 中文：处理账号认证相关流程，并把接口结果、加载状态和页面跳转保持同步。
  /// English: Handles account-authentication flow while keeping API results, loading state, and navigation in sync.
  void forgotPassword() {
    _openWebPage('forgot_password'.tr, AppConstants.forgotPasswordUrl);
  }

  /// 中文：处理导航、桥接或事件分发动作，统一外部交互入口。
  /// English: Handles navigation, bridge, or event-dispatch actions through a single interaction entry point.
  void _openOAuthPage(String title, String path) {
    final url = '${AppConstants.siteUrl}$path';
    _openWebPage(title, url);
  }

  /// 中文：处理导航、桥接或事件分发动作，统一外部交互入口。
  /// English: Handles navigation, bridge, or event-dispatch actions through a single interaction entry point.
  void _openWebPage(String title, String url) {
    Get.toNamed(
      '${AppRoutes.webview}?title=${Uri.encodeComponent(title)}'
      '&url=${Uri.encodeComponent(url)}',
    );
  }

  /// 中文：释放当前对象持有的控制器、监听器或异步资源，避免页面销毁后继续占用资源。
  /// English: Releases controllers, listeners, or async resources held by this object so they do not outlive the page.
  @override
  void onClose() {
    tabController.dispose();
    accountController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    smsCodeController.dispose();
    emailController.dispose();
    emailPasswordController.dispose();
    super.onClose();
  }
}
