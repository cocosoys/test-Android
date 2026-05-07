// 中文：本文件封装加载状态组件，统一局部加载、遮罩加载和居中加载的展示方式。
// English: This file wraps loading widgets and standardizes inline, overlay, and centered loading presentations.
//
// 中文：本文件的注释统一采用“上中文、下英文”的双语顺序，不能使用 ASCII 转码代替中文。
// English: Comments in this file keep Chinese above English and use real Chinese characters instead of ASCII escapes.

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:soys_app/app/theme/app_theme.dart';

/// 圆形加载指示器
/// 中文：承载 AppLoading 的核心职责，配合当前文件完成对应业务或界面逻辑。
/// English: AppLoading carries its core responsibility and supports the business or UI logic in this file.
class AppLoading extends StatelessWidget {
  const AppLoading({
    super.key,
    this.message,
    this.size = 36,
    this.color,
    this.strokeWidth = 3.0,
  });

  /// 加载提示文字
  final String? message;

  /// 指示器大小
  final double size;

  /// 指示器颜色
  final Color? color;

  /// 线条粗细
  final double strokeWidth;

  /// 中文：构建当前组件的界面树，并根据响应式状态刷新可见内容。
  /// English: Builds the widget tree for this component and refreshes visible content from reactive state.
  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? AppTheme.primaryColor;

    if (message == null) {
      return SizedBox(
        width: size.w,
        height: size.w,
        child: CircularProgressIndicator(
          strokeWidth: strokeWidth.w,
          valueColor: AlwaysStoppedAnimation<Color>(effectiveColor),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: size.w,
          height: size.w,
          child: CircularProgressIndicator(
            strokeWidth: strokeWidth.w,
            valueColor: AlwaysStoppedAnimation<Color>(effectiveColor),
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          message!,
          style: TextStyle(fontSize: 14.sp, color: AppTheme.textSecondary),
        ),
      ],
    );
  }
}

/// 全屏遮罩加载
/// 中文：承载 AppLoadingOverlay 的核心职责，配合当前文件完成对应业务或界面逻辑。
/// English: AppLoadingOverlay carries its core responsibility and supports the business or UI logic in this file.
class AppLoadingOverlay extends StatelessWidget {
  const AppLoadingOverlay({
    super.key,
    this.message,
    this.backgroundColor,
    this.indicatorColor,
    this.dismissible = false,
    this.onDismiss,
  });

  /// 加载提示文字
  final String? message;

  /// 遮罩背景色
  final Color? backgroundColor;

  /// 指示器颜色
  final Color? indicatorColor;

  /// 点击遮罩是否可关闭
  final bool dismissible;

  /// 关闭回调
  final VoidCallback? onDismiss;

  /// 中文：构建当前组件的界面树，并根据响应式状态刷新可见内容。
  /// English: Builds the widget tree for this component and refreshes visible content from reactive state.
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: dismissible,
      child: GestureDetector(
        onTap: dismissible ? onDismiss : null,
        child: Container(
          color: backgroundColor ?? Colors.black.withValues(alpha: 0.3),
          child: Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
              decoration: BoxDecoration(
                color: AppTheme.bgPrimary,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: AppLoading(
                message: message ?? 'loading'.tr,
                color: indicatorColor ?? AppTheme.primaryColor,
                size: 32,
                strokeWidth: 3.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 内联居中加载（用于列表中间等场景）
/// 中文：承载 AppLoadingCenter 的核心职责，配合当前文件完成对应业务或界面逻辑。
/// English: AppLoadingCenter carries its core responsibility and supports the business or UI logic in this file.
class AppLoadingCenter extends StatelessWidget {
  const AppLoadingCenter({super.key, this.message});

  final String? message;

  /// 中文：构建当前组件的界面树，并根据响应式状态刷新可见内容。
  /// English: Builds the widget tree for this component and refreshes visible content from reactive state.
  @override
  Widget build(BuildContext context) {
    return Center(child: AppLoading(message: message));
  }
}
