// 中文：本文件维护应用路由表、页面绑定关系和登录态守卫，保证页面跳转入口统一。
// English: This file maintains route names, page bindings, and auth guards so navigation remains centralized.
//
// 中文：本文件的注释统一采用“上中文、下英文”的双语顺序，不能使用 ASCII 转码代替中文。
// English: Comments in this file keep Chinese above English and use real Chinese characters instead of ASCII escapes.

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:soys_app/services/auth/auth_service.dart';
import 'package:soys_app/pages/splash/splash_page.dart';
import 'package:soys_app/pages/splash/splash_binding.dart';
import 'package:soys_app/pages/login/login_page.dart';
import 'package:soys_app/pages/login/login_binding.dart';
import 'package:soys_app/pages/register/register_page.dart';
import 'package:soys_app/pages/register/register_binding.dart';
import 'package:soys_app/pages/main/main_page.dart';
import 'package:soys_app/pages/main/main_binding.dart';
import 'package:soys_app/pages/home/home_page.dart';
import 'package:soys_app/pages/home/home_binding.dart';
import 'package:soys_app/pages/message/message_page.dart';
import 'package:soys_app/pages/message/message_binding.dart';
import 'package:soys_app/pages/mine/mine_page.dart';
import 'package:soys_app/pages/mine/mine_binding.dart';
import 'package:soys_app/pages/settings/settings_page.dart';
import 'package:soys_app/pages/settings/settings_binding.dart';
import 'package:soys_app/pages/about/about_page.dart';
import 'package:soys_app/pages/about/about_binding.dart';
import 'package:soys_app/pages/profile/profile_page.dart';
import 'package:soys_app/pages/profile/profile_binding.dart';
import 'package:soys_app/pages/webview/webview_page.dart';
import 'package:soys_app/pages/webview/webview_binding.dart';

/// 路由名称
/// 中文：维护 AppRoutes 路由相关职责，保证页面注册、跳转和访问控制集中管理。
/// English: AppRoutes owns routing responsibilities so page registration, navigation, and access control remain centralized.
class AppRoutes {
  AppRoutes._();

  static const splash = '/splash';
  static const login = '/login';
  static const register = '/register';
  static const main = '/main';
  static const home = '/home';
  static const message = '/message';
  static const mine = '/mine';
  static const settings = '/settings';
  static const about = '/about';
  static const profile = '/profile';
  static const webview = '/webview';
}

/// 路由页面
/// 中文：维护 AppPages 路由相关职责，保证页面注册、跳转和访问控制集中管理。
/// English: AppPages owns routing responsibilities so page registration, navigation, and access control remain centralized.
class AppPages {
  AppPages._();

  static final pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashPage(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginPage(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterPage(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: AppRoutes.main,
      page: () => const MainPage(),
      binding: MainBinding(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.message,
      page: () => const MessagePage(),
      binding: MessageBinding(),
    ),
    GetPage(
      name: AppRoutes.mine,
      page: () => const MinePage(),
      binding: MineBinding(),
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsPage(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: AppRoutes.about,
      page: () => const AboutPage(),
      binding: AboutBinding(),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfilePage(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.webview,
      page: () => const WebViewPage(),
      binding: WebViewBinding(),
    ),
  ];
}

/// 路由中间件 - 登录拦截
/// 中文：维护 AuthMiddleware 路由相关职责，保证页面注册、跳转和访问控制集中管理。
/// English: AuthMiddleware owns routing responsibilities so page registration, navigation, and access control remain centralized.
class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final authService = Get.find<AuthService>();
    if (!authService.isLoggedIn) {
      return const RouteSettings(name: AppRoutes.login);
    }
    return null;
  }
}
