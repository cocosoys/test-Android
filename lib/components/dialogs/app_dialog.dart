// 中文：本文件封装确认框、输入框、底部弹层和更新弹窗，统一全局弹窗交互。
// English: This file wraps confirm dialogs, input dialogs, bottom sheets, and update prompts to standardize modal interactions.
//
// 中文：本文件的注释统一采用“上中文、下英文”的双语顺序，不能使用 ASCII 转码代替中文。
// English: Comments in this file keep Chinese above English and use real Chinese characters instead of ASCII escapes.

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:soys_app/app/theme/app_theme.dart';
import 'package:soys_app/components/buttons/app_button.dart';

/// 通用弹窗
/// 中文：承载 AppDialog 的核心职责，配合当前文件完成对应业务或界面逻辑。
/// English: AppDialog carries its core responsibility and supports the business or UI logic in this file.
class AppDialog {
  AppDialog._();

  /// 显示确认弹窗
  static Future<bool> showConfirm({
    required String title,
    required String message,
    String? confirmText,
    String? cancelText,
    bool isDanger = false,
    Color? confirmColor,
  }) async {
    final result = await Get.dialog<bool>(
      _AppConfirmDialog(
        title: title,
        message: message,
        confirmText: confirmText ?? 'confirm'.tr,
        cancelText: cancelText ?? 'cancel'.tr,
        isDanger: isDanger,
        confirmColor: confirmColor,
      ),
      barrierDismissible: false,
    );
    return result ?? false;
  }

  /// 显示自定义内容弹窗
  static Future<T?> showCustom<T>({
    required Widget child,
    bool barrierDismissible = true,
    Color? barrierColor,
  }) {
    return Get.dialog<T>(
      child,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor ?? Colors.black.withValues(alpha: 0.5),
    );
  }

  /// 显示输入弹窗
  static Future<String?> showInput({
    required String title,
    String? hintText,
    String? defaultValue,
    String? confirmText,
    String? cancelText,
    int maxLength = 100,
  }) async {
    final controller = TextEditingController(text: defaultValue ?? '');
    final result = await Get.dialog<bool>(
      _AppInputDialog(
        title: title,
        hintText: hintText,
        controller: controller,
        confirmText: confirmText ?? 'confirm'.tr,
        cancelText: cancelText ?? 'cancel'.tr,
        maxLength: maxLength,
      ),
      barrierDismissible: false,
    );
    if (result == true) {
      final text = controller.text.trim();
      controller.dispose();
      return text;
    }
    controller.dispose();
    return null;
  }
}

/// 确认弹窗内部组件
/// 中文：承载 AppConfirmDialog 的核心职责，配合当前文件完成对应业务或界面逻辑。
/// English: AppConfirmDialog carries its core responsibility and supports the business or UI logic in this file.
class _AppConfirmDialog extends StatelessWidget {
  const _AppConfirmDialog({
    required this.title,
    required this.message,
    required this.confirmText,
    required this.cancelText,
    this.isDanger = false,
    this.confirmColor,
  });

  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final bool isDanger;
  final Color? confirmColor;

  /// 中文：构建当前组件的界面树，并根据响应式状态刷新可见内容。
  /// English: Builds the widget tree for this component and refreshes visible content from reactive state.
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 280.w,
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: AppTheme.bgPrimary,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Material(
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 标题
              Text(
                title,
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12.h),
              // 内容
              Text(
                message,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppTheme.textSecondary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.h),
              // 按钮
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      text: cancelText,
                      type: AppButtonType.secondary,
                      size: AppButtonSize.medium,
                      onPressed: () => Get.back(result: false),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: AppButton(
                      text: confirmText,
                      size: AppButtonSize.medium,
                      backgroundColor: isDanger
                          ? AppTheme.errorColor
                          : confirmColor ?? AppTheme.primaryColor,
                      onPressed: () => Get.back(result: true),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 输入弹窗内部组件
/// 中文：承载 AppInputDialog 的核心职责，配合当前文件完成对应业务或界面逻辑。
/// English: AppInputDialog carries its core responsibility and supports the business or UI logic in this file.
class _AppInputDialog extends StatelessWidget {
  const _AppInputDialog({
    required this.title,
    this.hintText,
    required this.controller,
    required this.confirmText,
    required this.cancelText,
    required this.maxLength,
  });

  final String title;
  final String? hintText;
  final TextEditingController controller;
  final String confirmText;
  final String cancelText;
  final int maxLength;

  /// 中文：构建当前组件的界面树，并根据响应式状态刷新可见内容。
  /// English: Builds the widget tree for this component and refreshes visible content from reactive state.
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 280.w,
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: AppTheme.bgPrimary,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Material(
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.h),
              TextField(
                controller: controller,
                maxLength: maxLength,
                autofocus: true,
                style: TextStyle(fontSize: 15.sp, color: AppTheme.textPrimary),
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: TextStyle(
                    fontSize: 14.sp,
                    color: AppTheme.textHint,
                  ),
                  filled: true,
                  fillColor: AppTheme.bgSecondary,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(
                      color: AppTheme.primaryColor,
                      width: 1.5.w,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  counterText: '',
                  isDense: true,
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      text: cancelText,
                      type: AppButtonType.secondary,
                      size: AppButtonSize.medium,
                      onPressed: () => Get.back(result: false),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: AppButton(
                      text: confirmText,
                      size: AppButtonSize.medium,
                      onPressed: () => Get.back(result: true),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 底部弹窗
/// 中文：承载 AppBottomSheet 的核心职责，配合当前文件完成对应业务或界面逻辑。
/// English: AppBottomSheet carries its core responsibility and supports the business or UI logic in this file.
class AppBottomSheet {
  AppBottomSheet._();

  /// 显示底部弹窗
  static Future<T?> show<T>({
    required Widget child,
    String? title,
    bool showClose = false,
    bool showHandle = true,
    double? maxHeight,
    bool isScrollControlled = false,
    bool enableDrag = true,
    Color? backgroundColor,
  }) {
    return Get.bottomSheet<T>(
      _AppBottomSheetContainer(
        title: title,
        showClose: showClose,
        showHandle: showHandle,
        maxHeight: maxHeight,
        backgroundColor: backgroundColor,
        child: child,
      ),
      isScrollControlled: isScrollControlled,
      enableDrag: enableDrag,
      isDismissible: enableDrag,
      backgroundColor: Colors.transparent,
    );
  }

  /// 显示操作列表
  static Future<int?> showActionList({
    required List<String> actions,
    String? cancelText,
    String? title,
    bool isDanger = false,
    int? dangerIndex,
  }) async {
    final result = await Get.bottomSheet<int>(
      _AppActionListSheet(
        title: title,
        actions: actions,
        cancelText: cancelText ?? 'cancel'.tr,
        dangerIndex: dangerIndex,
      ),
      backgroundColor: Colors.transparent,
    );
    return result;
  }
}

/// 底部弹窗容器
/// 中文：承载 AppBottomSheetContainer 的核心职责，配合当前文件完成对应业务或界面逻辑。
/// English: AppBottomSheetContainer carries its core responsibility and supports the business or UI logic in this file.
class _AppBottomSheetContainer extends StatelessWidget {
  const _AppBottomSheetContainer({
    this.title,
    this.showClose = false,
    this.showHandle = true,
    this.maxHeight,
    this.backgroundColor,
    required this.child,
  });

  final String? title;
  final bool showClose;
  final bool showHandle;
  final double? maxHeight;
  final Color? backgroundColor;
  final Widget child;

  /// 中文：构建当前组件的界面树，并根据响应式状态刷新可见内容。
  /// English: Builds the widget tree for this component and refreshes visible content from reactive state.
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: maxHeight != null
          ? BoxConstraints(maxHeight: maxHeight!)
          : null,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppTheme.bgPrimary,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 顶部拖拽指示条
          if (showHandle)
            Padding(
              padding: EdgeInsets.only(top: 8.h, bottom: 4.h),
              child: Container(
                width: 36.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppTheme.borderColor,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
          // 标题栏
          if (title != null || showClose)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Row(
                children: [
                  Expanded(
                    child: title != null
                        ? Text(
                            title!,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimary,
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                  if (showClose)
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Icon(
                        Icons.close,
                        size: 22.w,
                        color: AppTheme.textHint,
                      ),
                    ),
                ],
              ),
            ),
          // 内容
          Flexible(child: child),
          // 底部安全区
          SizedBox(
            height: MediaQuery.of(Get.context!).padding.bottom > 0
                ? MediaQuery.of(Get.context!).padding.bottom
                : 0,
          ),
        ],
      ),
    );
  }
}

/// 操作列表底部弹窗
/// 中文：承载 AppActionListSheet 的核心职责，配合当前文件完成对应业务或界面逻辑。
/// English: AppActionListSheet carries its core responsibility and supports the business or UI logic in this file.
class _AppActionListSheet extends StatelessWidget {
  const _AppActionListSheet({
    this.title,
    required this.actions,
    required this.cancelText,
    this.dangerIndex,
  });

  final String? title;
  final List<String> actions;
  final String cancelText;
  final int? dangerIndex;

  /// 中文：构建当前组件的界面树，并根据响应式状态刷新可见内容。
  /// English: Builds the widget tree for this component and refreshes visible content from reactive state.
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 操作列表容器
          Container(
            margin: EdgeInsets.symmetric(horizontal: 8.w),
            decoration: BoxDecoration(
              color: AppTheme.bgPrimary,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (title != null)
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 14.h,
                    ),
                    child: Text(
                      title!,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: AppTheme.textHint,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                if (title != null)
                  Divider(
                    height: 0.5.h,
                    thickness: 0.5,
                    color: AppTheme.dividerColor,
                  ),
                ...List.generate(actions.length, (index) {
                  final isDanger = index == dangerIndex;
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => Get.back(result: index),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 14.h,
                          ),
                          child: Text(
                            actions[index],
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: isDanger
                                  ? AppTheme.errorColor
                                  : AppTheme.primaryColor,
                              fontWeight: isDanger
                                  ? FontWeight.w500
                                  : FontWeight.normal,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      if (index < actions.length - 1)
                        Divider(
                          height: 0.5.h,
                          thickness: 0.5,
                          indent: 16.w,
                          endIndent: 16.w,
                          color: AppTheme.dividerColor,
                        ),
                    ],
                  );
                }),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          // 取消按钮
          Container(
            margin: EdgeInsets.symmetric(horizontal: 8.w),
            decoration: BoxDecoration(
              color: AppTheme.bgPrimary,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Get.back(result: -1),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                child: Text(
                  cancelText,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 应用更新弹窗
/// 中文：承载 AppUpdateDialog 的核心职责，配合当前文件完成对应业务或界面逻辑。
/// English: AppUpdateDialog carries its core responsibility and supports the business or UI logic in this file.
class AppUpdateDialog extends StatelessWidget {
  const AppUpdateDialog({
    super.key,
    required this.versionName,
    required this.updateContent,
    this.isForce = false,
    this.onUpdate,
    this.onLater,
  });

  /// 新版本号
  final String versionName;

  /// 更新内容
  final String updateContent;

  /// 是否强制更新
  final bool isForce;

  /// 立即更新回调
  final VoidCallback? onUpdate;

  /// 稍后更新回调
  final VoidCallback? onLater;

  /// 显示更新弹窗
  static void show({
    required String versionName,
    required String updateContent,
    bool isForce = false,
    VoidCallback? onUpdate,
    VoidCallback? onLater,
  }) {
    Get.dialog(
      AppUpdateDialog(
        versionName: versionName,
        updateContent: updateContent,
        isForce: isForce,
        onUpdate: onUpdate,
        onLater: onLater,
      ),
      barrierDismissible: !isForce,
    );
  }

  /// 中文：构建当前组件的界面树，并根据响应式状态刷新可见内容。
  /// English: Builds the widget tree for this component and refreshes visible content from reactive state.
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 280.w,
        decoration: BoxDecoration(
          color: AppTheme.bgPrimary,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Material(
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 顶部装饰
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 24.h),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16.r),
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.system_update_outlined,
                      size: 40.w,
                      color: Colors.white,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'has_update'.tr,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'v$versionName',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
              // 更新内容
              Padding(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'update_content'.tr,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: 200.h),
                      child: SingleChildScrollView(
                        child: Text(
                          updateContent,
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: AppTheme.textSecondary,
                            height: 1.6,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    // 按钮
                    AppButton(
                      text: 'update_now'.tr,
                      onPressed: onUpdate ?? () => Get.back(),
                    ),
                    if (!isForce) ...[
                      SizedBox(height: 12.h),
                      Center(
                        child: GestureDetector(
                          onTap: onLater ?? () => Get.back(),
                          child: Text(
                            'update_later'.tr,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppTheme.textHint,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
