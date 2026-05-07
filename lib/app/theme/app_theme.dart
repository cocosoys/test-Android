// 中文：本文件定义主题色、文字风格、组件样式和主题控制器，保证全局视觉风格一致。
// English: This file defines colors, typography, component themes, and the theme controller to keep app visuals consistent.
//
// 中文：本文件的注释统一采用“上中文、下英文”的双语顺序，不能使用 ASCII 转码代替中文。
// English: Comments in this file keep Chinese above English and use real Chinese characters instead of ASCII escapes.

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:soys_app/core/constants/app_constants.dart';
import 'package:soys_app/services/storage/storage_service.dart';

/// 主题配置
/// 中文：集中维护 AppTheme 主题配置，保证视觉样式在全局保持一致。
/// English: AppTheme centralizes theme configuration so visual styling remains consistent across the app.
class AppTheme {
  AppTheme._();

  // ========== 主色 ==========
  static const Color primaryColor = Color(0xFF1677FF);
  static const Color primaryDark = Color(0xFF0958D9);
  static const Color primaryLight = Color(0xFF4096FF);

  // ========== 功能色 ==========
  static const Color successColor = Color(0xFF52C41A);
  static const Color warningColor = Color(0xFFFAAD14);
  static const Color errorColor = Color(0xFFFF4D4F);
  static const Color infoColor = Color(0xFF1677FF);

  // ========== 文本色 ==========
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textHint = Color(0xFF999999);
  static const Color textDisabled = Color(0xFFBFBFBF);

  // ========== 背景色 ==========
  static const Color bgPrimary = Color(0xFFFFFFFF);
  static const Color bgSecondary = Color(0xFFF5F5F5);
  static const Color bgCard = Color(0xFFFFFFFF);

  // ========== 边框色 ==========
  static const Color borderColor = Color(0xFFE8E8E8);
  static const Color dividerColor = Color(0xFFF0F0F0);

  // ========== 浅色主题 ==========
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: primaryColor,
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: primaryLight,
      error: errorColor,
      surface: bgPrimary,
    ),
    scaffoldBackgroundColor: bgSecondary,
    appBarTheme: const AppBarTheme(
      backgroundColor: bgPrimary,
      foregroundColor: textPrimary,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
    cardTheme: const CardThemeData(
      color: bgCard,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColor,
        side: const BorderSide(color: primaryColor),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: bgSecondary,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: primaryColor, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: errorColor),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      hintStyle: const TextStyle(color: textHint, fontSize: 14),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: bgPrimary,
      selectedItemColor: primaryColor,
      unselectedItemColor: textHint,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      unselectedLabelStyle: TextStyle(fontSize: 12),
    ),
    dividerTheme: const DividerThemeData(
      color: dividerColor,
      thickness: 0.5,
      space: 0,
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );

  // ========== 暗色主题 ==========
  static ThemeData get darkTheme {
    const darkBgPrimary = Color(0xFF1A1A1A);
    const darkBgSecondary = Color(0xFF141414);
    const darkBgCard = Color(0xFF2A2A2A);
    const darkTextPrimary = Color(0xFFE8E8E8);
    const darkTextHint = Color(0xFF777777);
    const darkDividerColor = Color(0xFF2E2E2E);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: primaryLight,
        error: errorColor,
        surface: darkBgPrimary,
      ),
      scaffoldBackgroundColor: darkBgSecondary,
      appBarTheme: const AppBarTheme(
        backgroundColor: darkBgPrimary,
        foregroundColor: darkTextPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: darkTextPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: const CardThemeData(
        color: darkBgCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: darkBgPrimary,
        selectedItemColor: primaryColor,
        unselectedItemColor: darkTextHint,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      dividerTheme: const DividerThemeData(
        color: darkDividerColor,
        thickness: 0.5,
        space: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkBgCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryColor, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: errorColor),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        hintStyle: const TextStyle(color: darkTextHint, fontSize: 14),
      ),
    );
  }
}

/// 主题控制器
/// 中文：管理 ThemeController 对应页面或功能的状态、数据加载和用户交互。
/// English: ThemeController manages state, data loading, and user interactions for its related page or feature.
class ThemeController extends GetxController {
  final _themeMode = ThemeMode.system.obs;

  ThemeMode get themeMode => _themeMode.value;

  bool get isDarkMode => _themeMode.value == ThemeMode.dark;

  /// 中文：更新当前功能状态或持久化数据，并确保界面和本地缓存保持一致。
  /// English: Updates feature state or persisted data while keeping the UI and local cache consistent.
  void setThemeMode(ThemeMode mode) {
    _themeMode.value = mode;
    Get.changeThemeMode(mode);
    _saveThemeMode(mode);
  }

  /// 中文：更新当前功能状态或持久化数据，并确保界面和本地缓存保持一致。
  /// English: Updates feature state or persisted data while keeping the UI and local cache consistent.
  void toggleTheme() {
    final newMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    setThemeMode(newMode);
  }

  /// 中文：更新当前功能状态或持久化数据，并确保界面和本地缓存保持一致。
  /// English: Updates feature state or persisted data while keeping the UI and local cache consistent.
  Future<void> _saveThemeMode(ThemeMode mode) async {
    await Get.find<StorageService>().setString(
      AppConstants.storageThemeMode,
      mode.toString(),
    );
  }

  /// 中文：加载或刷新当前功能所需数据，并在失败时保留可用的兜底状态。
  /// English: Loads or refreshes data required by this feature and keeps usable fallback state when requests fail.
  Future<void> loadThemeMode() async {
    final saved = Get.find<StorageService>().getString(
      AppConstants.storageThemeMode,
    );
    if (saved != null) {
      if (saved == ThemeMode.dark.toString()) {
        _themeMode.value = ThemeMode.dark;
      } else if (saved == ThemeMode.light.toString()) {
        _themeMode.value = ThemeMode.light;
      } else {
        _themeMode.value = ThemeMode.system;
      }
    }
  }
}
