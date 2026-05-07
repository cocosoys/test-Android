// 中文：本文件封装空状态、错误状态和网络错误状态页面，统一异常场景的展示方式。
// English: This file wraps empty, error, and network-error states so exceptional UI states remain consistent.
//
// 中文：本文件的注释统一采用“上中文、下英文”的双语顺序，不能使用 ASCII 转码代替中文。
// English: Comments in this file keep Chinese above English and use real Chinese characters instead of ASCII escapes.

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:soys_app/app/theme/app_theme.dart';
import 'package:soys_app/components/buttons/app_button.dart';

/// 空状态页面
/// 中文：构建 AppEmptyPage 对应的页面界面，并把用户操作转交给控制器处理。
/// English: AppEmptyPage builds its page UI and delegates user actions to the controller.
class AppEmptyPage extends StatelessWidget {
  const AppEmptyPage({
    super.key,
    this.icon,
    this.iconData,
    this.title,
    this.subtitle,
    this.actionText,
    this.onAction,
    this.iconColor,
    this.iconSize = 80,
  });

  /// 自定义图标组件
  final Widget? icon;

  /// 图标数据（与 icon 互斥）
  final IconData? iconData;

  /// 标题
  final String? title;

  /// 副标题
  final String? subtitle;

  /// 操作按钮文字
  final String? actionText;

  /// 操作按钮回调
  final VoidCallback? onAction;

  /// 图标颜色
  final Color? iconColor;

  /// 图标大小
  final double iconSize;

  /// 中文：构建当前组件的界面树，并根据响应式状态刷新可见内容。
  /// English: Builds the widget tree for this component and refreshes visible content from reactive state.
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 图标
            if (icon != null)
              icon!
            else
              Icon(
                iconData ?? Icons.inbox_outlined,
                size: iconSize.w,
                color: iconColor ?? AppTheme.textDisabled,
              ),
            SizedBox(height: 16.h),
            // 标题
            if (title != null)
              Text(
                title!,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            if (subtitle != null) ...[
              SizedBox(height: 8.h),
              Text(
                subtitle!,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: AppTheme.textHint,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            // 操作按钮
            if (actionText != null && onAction != null) ...[
              SizedBox(height: 24.h),
              SizedBox(
                width: 160.w,
                child: AppButton(
                  text: actionText!,
                  onPressed: onAction,
                  type: AppButtonType.outline,
                  size: AppButtonSize.medium,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// 错误状态页面
/// 中文：构建 AppErrorPage 对应的页面界面，并把用户操作转交给控制器处理。
/// English: AppErrorPage builds its page UI and delegates user actions to the controller.
class AppErrorPage extends StatelessWidget {
  const AppErrorPage({
    super.key,
    this.icon,
    this.title,
    this.subtitle,
    this.retryText,
    this.onRetry,
    this.errorColor,
  });

  /// 自定义图标
  final Widget? icon;

  /// 标题
  final String? title;

  /// 副标题
  final String? subtitle;

  /// 重试按钮文字
  final String? retryText;

  /// 重试回调
  final VoidCallback? onRetry;

  /// 错误图标颜色
  final Color? errorColor;

  /// 中文：构建当前组件的界面树，并根据响应式状态刷新可见内容。
  /// English: Builds the widget tree for this component and refreshes visible content from reactive state.
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null)
              icon!
            else
              Icon(
                Icons.error_outline,
                size: 80.w,
                color: errorColor ?? AppTheme.errorColor.withValues(alpha: 0.7),
              ),
            SizedBox(height: 16.h),
            Text(
              title ?? 'error'.tr,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              SizedBox(height: 8.h),
              Text(
                subtitle!,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: AppTheme.textHint,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (onRetry != null) ...[
              SizedBox(height: 24.h),
              SizedBox(
                width: 160.w,
                child: AppButton(
                  text: retryText ?? 'retry'.tr,
                  onPressed: onRetry,
                  type: AppButtonType.outline,
                  size: AppButtonSize.medium,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// 网络错误状态
/// 中文：承载 AppNetworkError 的核心职责，配合当前文件完成对应业务或界面逻辑。
/// English: AppNetworkError carries its core responsibility and supports the business or UI logic in this file.
class AppNetworkError extends StatelessWidget {
  const AppNetworkError({super.key, this.onRetry, this.message});

  /// 重试回调
  final VoidCallback? onRetry;

  /// 自定义错误消息
  final String? message;

  /// 中文：构建当前组件的界面树，并根据响应式状态刷新可见内容。
  /// English: Builds the widget tree for this component and refreshes visible content from reactive state.
  @override
  Widget build(BuildContext context) {
    return AppErrorPage(
      icon: Icon(
        Icons.wifi_off_outlined,
        size: 80.w,
        color: AppTheme.textDisabled,
      ),
      title: 'network_error'.tr,
      subtitle: message,
      onRetry: onRetry,
    );
  }
}
