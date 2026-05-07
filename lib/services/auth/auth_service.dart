// 中文：本文件封装认证服务，统一登录、注册、测试账号、本地登录态恢复、资料保存和退出登录。
// English: This file wraps authentication logic for login, registration, test accounts, local session restore, profile persistence, and logout.
//
// 中文：本文件的注释统一采用“上中文、下英文”的双语顺序，不能使用 ASCII 转码代替中文。
// English: Comments in this file keep Chinese above English and use real Chinese characters instead of ASCII escapes.

import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;

import 'package:soys_app/core/constants/app_constants.dart';
import 'package:soys_app/core/constants/env_config.dart';
import 'package:soys_app/core/network/http_service.dart';
import 'package:soys_app/models/network/api_response.dart';
import 'package:soys_app/models/user/user_model.dart';
import 'package:soys_app/services/storage/storage_service.dart';

/// 认证服务
/// 中文：封装 AuthService 对应的跨页面服务能力，避免业务层直接依赖底层实现。
/// English: AuthService encapsulates cross-page service capabilities so feature code does not depend on low-level details directly.
class AuthService extends GetxService {
  final StorageService _storage = Get.find<StorageService>();
  final HttpService _http = Get.find<HttpService>();

  final _user = Rxn<UserModel>();
  final _isLoggedIn = false.obs;

  UserModel? get user => _user.value;
  bool get isLoggedIn => _isLoggedIn.value;
  String? get token => _storage.token;

  /// 中文：完成当前对象的初始化流程，确保依赖、监听器或初始数据在使用前准备好。
  /// English: Initializes the current object so dependencies, listeners, or initial data are ready before use.
  Future<AuthService> init() async {
    await _loadUserFromStorage();
    return this;
  }

  /// 从本地存储恢复用户
  /// 中文：加载或刷新当前功能所需数据，并在失败时保留可用的兜底状态。
  /// English: Loads or refreshes data required by this feature and keeps usable fallback state when requests fail.
  Future<void> _loadUserFromStorage() async {
    final user = _storage.getUserInfo();
    final token = _storage.token;
    if (user != null && token != null) {
      _user.value = user;
      _isLoggedIn.value = true;
    }
  }

  /// 账号密码登录
  Future<ApiResponse<UserModel>> loginWithAccount(
    String account,
    String password,
  ) async {
    final response = await _http.post<UserModel>(
      '/auth/login',
      data: {'account': account, 'password': password, 'loginType': 'account'},
      fromJson: (json) => UserModel.fromJson(json as Map<String, dynamic>),
    );

    if (response.isSuccess && response.data != null) {
      await _onLoginSuccess(response.data!);
    }

    return response;
  }

  /// 手机号+验证码登录
  Future<ApiResponse<UserModel>> loginWithPhone(
    String phone,
    String smsCode,
  ) async {
    final response = await _http.post<UserModel>(
      '/auth/login/sms',
      data: {'phone': phone, 'code': smsCode, 'loginType': 'phone'},
      fromJson: (json) => UserModel.fromJson(json as Map<String, dynamic>),
    );

    if (response.isSuccess && response.data != null) {
      await _onLoginSuccess(response.data!);
    }

    return response;
  }

  /// 邮箱登录
  Future<ApiResponse<UserModel>> loginWithEmail(
    String email,
    String password,
  ) async {
    final response = await _http.post<UserModel>(
      '/auth/login/email',
      data: {'email': email, 'password': password, 'loginType': 'email'},
      fromJson: (json) => UserModel.fromJson(json as Map<String, dynamic>),
    );

    if (response.isSuccess && response.data != null) {
      await _onLoginSuccess(response.data!);
    }

    return response;
  }

  /// 微信登录
  Future<ApiResponse<UserModel>> loginWithWeChat(String code) async {
    final response = await _http.post<UserModel>(
      '/auth/login/wechat',
      data: {'code': code, 'loginType': 'wechat'},
      fromJson: (json) => UserModel.fromJson(json as Map<String, dynamic>),
    );

    if (response.isSuccess && response.data != null) {
      await _onLoginSuccess(response.data!);
    }

    return response;
  }

  /// QQ登录
  Future<ApiResponse<UserModel>> loginWithQQ(
    String openId,
    String accessToken,
  ) async {
    final response = await _http.post<UserModel>(
      '/auth/login/qq',
      data: {'openId': openId, 'accessToken': accessToken, 'loginType': 'qq'},
      fromJson: (json) => UserModel.fromJson(json as Map<String, dynamic>),
    );

    if (response.isSuccess && response.data != null) {
      await _onLoginSuccess(response.data!);
    }

    return response;
  }

  /// Apple登录
  Future<ApiResponse<UserModel>> loginWithApple(
    String identityToken,
    String authorizationCode,
  ) async {
    final response = await _http.post<UserModel>(
      '/auth/login/apple',
      data: {
        'identityToken': identityToken,
        'authorizationCode': authorizationCode,
        'loginType': 'apple',
      },
      fromJson: (json) => UserModel.fromJson(json as Map<String, dynamic>),
    );

    if (response.isSuccess && response.data != null) {
      await _onLoginSuccess(response.data!);
    }

    return response;
  }

  /// 测试账号登录
  Future<ApiResponse<UserModel>> loginWithTestAccount() async {
    final response = await _http.post<UserModel>(
      '/auth/login',
      data: {
        'account': AppConstants.testAccount,
        'password': AppConstants.testPassword,
        'loginType': 'account',
      },
      showErrorToast: false,
      fromJson: (json) => UserModel.fromJson(json as Map<String, dynamic>),
    );

    if (response.isSuccess && response.data != null) {
      await _onLoginSuccess(response.data!);
      return response;
    }

    if (Environments.current.name == 'prod') {
      return response;
    }

    final user = UserModel(
      id: 'test-user',
      username: AppConstants.testAccount,
      nickname: '测试用户',
      token: 'local-test-token',
      refreshToken: 'local-test-refresh-token',
    );
    await _onLoginSuccess(user);
    return ApiResponse(code: 0, message: 'local_test_account', data: user);
  }

  /// 注册
  Future<ApiResponse<UserModel>> register({
    required String account,
    required String password,
    String? phone,
    String? email,
    String? smsCode,
  }) async {
    final response = await _http.post<UserModel>(
      '/auth/register',
      data: {
        'account': account,
        'password': password,
        'phone': phone,
        'email': email,
        'code': smsCode,
      },
      fromJson: (json) => UserModel.fromJson(json as Map<String, dynamic>),
    );

    if (response.isSuccess && response.data != null) {
      await _onLoginSuccess(response.data!);
    }

    return response;
  }

  /// 发送验证码
  /// 中文：处理账号认证相关流程，并把接口结果、加载状态和页面跳转保持同步。
  /// English: Handles account-authentication flow while keeping API results, loading state, and navigation in sync.
  Future<ApiResponse> sendSmsCode(String phone) async {
    return _http.post('/auth/sms/send', data: {'phone': phone});
  }

  /// 登录成功处理
  /// 中文：执行 onLoginSuccess 对应的业务步骤，并把内部细节封装在当前模块内。
  /// English: Executes the onLoginSuccess business step while keeping internal details encapsulated in this module.
  Future<void> _onLoginSuccess(UserModel user) async {
    _user.value = user;
    _isLoggedIn.value = true;

    if (user.token != null) {
      await _storage.setToken(user.token!);
    }
    if (user.refreshToken != null) {
      await _storage.setRefreshToken(user.refreshToken!);
    }
    await _storage.setUserInfo(user);
  }

  /// 退出登录
  /// 中文：处理账号认证相关流程，并把接口结果、加载状态和页面跳转保持同步。
  /// English: Handles account-authentication flow while keeping API results, loading state, and navigation in sync.
  Future<void> logout() async {
    _user.value = null;
    _isLoggedIn.value = false;
    await _storage.clearUserData();
    Get.offAllNamed('/login');
  }

  /// 更新用户信息
  /// 中文：更新当前功能状态或持久化数据，并确保界面和本地缓存保持一致。
  /// English: Updates feature state or persisted data while keeping the UI and local cache consistent.
  Future<void> updateUserInfo(UserModel user) async {
    _user.value = user;
    await _storage.setUserInfo(user);
  }

  /// 上传头像
  Future<ApiResponse<String>> uploadAvatar(String imagePath) async {
    final formData = dio.FormData.fromMap({
      'file': await dio.MultipartFile.fromFile(imagePath),
    });

    return _http.upload<String>(
      '/user/avatar',
      formData: formData,
      showErrorToast: false,
      fromJson: (json) {
        if (json is String) return json;
        if (json is Map<String, dynamic>) {
          return (json['url'] ?? json['avatar'] ?? json['path']).toString();
        }
        return '';
      },
    );
  }

  /// 保存用户资料。后端不可用时保留本地乐观更新，避免资料页无法使用。
  Future<ApiResponse<UserModel>> updateProfile(UserModel user) async {
    final response = await _http.put<UserModel>(
      '/user/profile',
      data: {
        'nickname': user.nickname,
        'gender': user.gender,
        'birthday': user.birthday,
        'avatar': user.avatar,
      },
      showErrorToast: false,
      fromJson: (json) => UserModel.fromJson(json as Map<String, dynamic>),
    );

    if (response.isSuccess && response.data != null) {
      await updateUserInfo(response.data!);
      return response;
    }

    await updateUserInfo(user);
    return ApiResponse(code: ErrorCode.success, message: 'success', data: user);
  }
}
