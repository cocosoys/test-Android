// 中文：本文件集中维护应用名称、版本、测试账号、存储键和协议地址等全局常量。
// English: This file centralizes global constants such as app identity, test credentials, storage keys, and agreement URLs.
//
// 中文：本文件的注释统一采用“上中文、下英文”的双语顺序，不能使用 ASCII 转码代替中文。
// English: Comments in this file keep Chinese above English and use real Chinese characters instead of ASCII escapes.

/// 全局常量
/// 中文：集中声明 AppConstants 常量，避免魔法值分散在业务代码中。
/// English: AppConstants centralizes constants to keep magic values out of feature code.
class AppConstants {
  AppConstants._();

  static const String appName = 'SOYS App';
  static const String appNameCn = 'SOYS应用';

  // H5 页面
  static const String siteUrl = 'https://soys.app';
  static const String termsUrl = '$siteUrl/terms';
  static const String privacyUrl = '$siteUrl/privacy';
  static const String forgotPasswordUrl = '$siteUrl/forgot-password';

  // 存储 Key
  static const String storageToken = 'token';
  static const String storageRefreshToken = 'refresh_token';
  static const String storageUserInfo = 'user_info';
  static const String storageThemeMode = 'theme_mode';
  static const String storageLocale = 'locale';
  static const String storageFirstLaunch = 'first_launch';
  static const String storageAgreementAccepted = 'agreement_accepted';
  static const String storageEnvironment = 'environment';

  // 默认值
  static const int defaultPage = 1;
  static const int defaultPageSize = 20;

  // 正则
  static const String phoneRegex = r'^1[3-9]\d{9}$';
  static const String emailRegex = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  static const String passwordRegex =
      r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*#?&]{8,20}$';

  // 超时
  static const int connectTimeout = 15000;
  static const int receiveTimeout = 15000;
  static const int smsCountdown = 60;

  // 测试账号
  static const String testAccount = 'test001';
  static const String testPassword = 'test123456';
}
