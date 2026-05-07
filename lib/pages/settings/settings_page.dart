// 中文：本文件承载设置页面逻辑，负责主题切换、语言切换和缓存清理。
// English: This file owns the Settings page logic for theme switching, language switching, and cache clearing.
//
// 中文：本文件的注释统一采用“上中文、下英文”的双语顺序，不能使用 ASCII 转码代替中文。
// English: Comments in this file keep Chinese above English and use real Chinese characters instead of ASCII escapes.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:soys_app/app/theme/app_theme.dart';
import 'package:soys_app/core/utils/app_utils.dart';
import 'package:soys_app/services/storage/storage_service.dart';
import 'package:soys_app/components/toast/app_toast.dart';

/// 中文：管理 SettingsController 对应页面或功能的状态、数据加载和用户交互。
/// English: SettingsController manages state, data loading, and user interactions for its related page or feature.
class SettingsController extends GetxController {
  final StorageService _storage = Get.find<StorageService>();

  final _themeMode = ThemeMode.system.obs;
  final _locale = const Locale('zh', 'CN').obs;
  final _cacheSize = ''.obs;

  ThemeMode get themeMode => _themeMode.value;
  Locale get locale => _locale.value;
  String get cacheSize => _cacheSize.value;

  /// 中文：完成当前对象的初始化流程，确保依赖、监听器或初始数据在使用前准备好。
  /// English: Initializes the current object so dependencies, listeners, or initial data are ready before use.
  @override
  void onInit() {
    super.onInit();
    _loadSettings();
  }

  /// 中文：加载或刷新当前功能所需数据，并在失败时保留可用的兜底状态。
  /// English: Loads or refreshes data required by this feature and keeps usable fallback state when requests fail.
  void _loadSettings() async {
    final savedTheme = _storage.getString('theme_mode');
    if (savedTheme != null) {
      if (savedTheme == 'dark') {
        _themeMode.value = ThemeMode.dark;
      } else if (savedTheme == 'light') {
        _themeMode.value = ThemeMode.light;
      }
    }

    final savedLocale = _storage.getString('locale');
    if (savedLocale != null) {
      if (savedLocale.contains('en')) _locale.value = const Locale('en', 'US');
    }

    _cacheSize.value = await AppUtils.getCacheSize();
  }

  /// 中文：更新当前功能状态或持久化数据，并确保界面和本地缓存保持一致。
  /// English: Updates feature state or persisted data while keeping the UI and local cache consistent.
  void setThemeMode(ThemeMode mode) {
    _themeMode.value = mode;
    Get.changeThemeMode(mode);
    _storage.setString(
      'theme_mode',
      mode == ThemeMode.dark
          ? 'dark'
          : mode == ThemeMode.light
          ? 'light'
          : 'system',
    );
  }

  /// 中文：更新当前功能状态或持久化数据，并确保界面和本地缓存保持一致。
  /// English: Updates feature state or persisted data while keeping the UI and local cache consistent.
  void setLocale(Locale locale) {
    _locale.value = locale;
    Get.updateLocale(locale);
    _storage.setString('locale', locale.toString());
  }

  /// 中文：更新当前功能状态或持久化数据，并确保界面和本地缓存保持一致。
  /// English: Updates feature state or persisted data while keeping the UI and local cache consistent.
  Future<void> clearCache() async {
    final confirmed = await AppToast.showConfirm(
      title: 'cache_clear'.tr,
      message: 'cache_clear_confirm'.tr,
    );
    if (confirmed) {
      await AppUtils.clearCache();
      _cacheSize.value = await AppUtils.getCacheSize();
      AppToast.showSuccess('success'.tr);
    }
  }
}

/// 中文：构建 SettingsPage 对应的页面界面，并把用户操作转交给控制器处理。
/// English: SettingsPage builds its page UI and delegates user actions to the controller.
class SettingsPage extends GetView<SettingsController> {
  const SettingsPage({super.key});

  /// 中文：构建当前组件的界面树，并根据响应式状态刷新可见内容。
  /// English: Builds the widget tree for this component and refreshes visible content from reactive state.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('settings'.tr)),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            _buildThemeSection(),
            SizedBox(height: 12.h),
            _buildLanguageSection(),
            SizedBox(height: 12.h),
            _buildCacheSection(),
          ],
        ),
      ),
    );
  }

  /// 中文：构建当前页面中的局部 UI 片段，保持主构建方法结构清晰。
  /// English: Builds a focused UI section in the page so the main build method stays readable.
  Widget _buildThemeSection() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(Get.context!).cardColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 8.w),
            child: Text(
              'theme_mode'.tr,
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
            ),
          ),
          Obx(
            () => Row(
              children: [
                _buildThemeChip('theme_light'.tr, ThemeMode.light),
                SizedBox(width: 8.w),
                _buildThemeChip('theme_dark'.tr, ThemeMode.dark),
                SizedBox(width: 8.w),
                _buildThemeChip('theme_system'.tr, ThemeMode.system),
              ],
            ),
          ),
          SizedBox(height: 12.h),
        ],
      ),
    );
  }

  /// 中文：构建当前页面中的局部 UI 片段，保持主构建方法结构清晰。
  /// English: Builds a focused UI section in the page so the main build method stays readable.
  Widget _buildThemeChip(String label, ThemeMode mode) {
    final selected = controller.themeMode == mode;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => controller.setThemeMode(mode),
    );
  }

  /// 中文：构建当前页面中的局部 UI 片段，保持主构建方法结构清晰。
  /// English: Builds a focused UI section in the page so the main build method stays readable.
  Widget _buildLanguageSection() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(Get.context!).cardColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 8.w),
            child: Text(
              'language'.tr,
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
            ),
          ),
          Obx(
            () => Row(
              children: [
                ChoiceChip(
                  label: Text('language_zh'.tr),
                  selected: controller.locale == const Locale('zh', 'CN'),
                  onSelected: (_) =>
                      controller.setLocale(const Locale('zh', 'CN')),
                ),
                SizedBox(width: 8.w),
                ChoiceChip(
                  label: Text('language_en'.tr),
                  selected: controller.locale == const Locale('en', 'US'),
                  onSelected: (_) =>
                      controller.setLocale(const Locale('en', 'US')),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
        ],
      ),
    );
  }

  /// 中文：构建当前页面中的局部 UI 片段，保持主构建方法结构清晰。
  /// English: Builds a focused UI section in the page so the main build method stays readable.
  Widget _buildCacheSection() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(Get.context!).cardColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: ListTile(
        leading: const Icon(
          Icons.cleaning_services_outlined,
          color: AppTheme.textSecondary,
        ),
        title: Text('cache_clear'.tr, style: TextStyle(fontSize: 15.sp)),
        trailing: Obx(
          () => Text(
            controller.cacheSize,
            style: TextStyle(fontSize: 13.sp, color: AppTheme.textHint),
          ),
        ),
        onTap: controller.clearCache,
      ),
    );
  }
}
