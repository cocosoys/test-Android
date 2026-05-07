// 中文：本文件封装屏幕适配工具，统一尺寸、字体、圆角和间距在不同设备上的换算入口。
// English: This file wraps screen adaptation helpers and standardizes size, font, radius, and spacing conversion across devices.
//
// 中文：本文件的注释统一采用“上中文、下英文”的双语顺序，不能使用 ASCII 转码代替中文。
// English: Comments in this file keep Chinese above English and use real Chinese characters instead of ASCII escapes.

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// 屏幕适配工具
/// 使用 flutter_screenutil 实现全局适配
/// 设计稿尺寸：375x812 (iPhone X)
/// 中文：承载 ScreenAdapter 的核心职责，配合当前文件完成对应业务或界面逻辑。
/// English: ScreenAdapter carries its core responsibility and supports the business or UI logic in this file.
class ScreenAdapter {
  ScreenAdapter._();

  /// 设计稿宽度
  static const double designWidth = 375;

  /// 设计稿高度
  static const double designHeight = 812;

  /// 初始化适配（在MaterialApp之前调用）
  static void init(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(designWidth, designHeight));
  }

  /// 宽度适配
  static double width(double num) => num.w;

  /// 高度适配
  static double height(double num) => num.h;

  /// 字体适配
  static double fontSize(double num) => num.sp;

  /// 圆角适配
  static double radius(double num) => num.r;

  /// 间距适配
  static double spacing(double num) => num.w;

  /// 获取屏幕宽度
  static double get screenWidth => 1.sw;

  /// 获取屏幕高度
  static double get screenHeight => 1.sh;

  /// 获取状态栏高度
  static double get statusBarHeight =>
      MediaQuery.viewPaddingOf(Get.context!).top;

  /// 获取底部安全区域高度
  static double get bottomBarHeight =>
      MediaQuery.viewPaddingOf(Get.context!).bottom;

  /// 获取导航栏高度
  static double get navigationBarHeight => kToolbarHeight;

  /// 获取底部TabBar高度
  static double get bottomTabBarHeight => kBottomNavigationBarHeight;
}
