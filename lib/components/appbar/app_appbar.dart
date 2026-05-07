// 中文：本文件封装通用顶部导航栏，统一标题、返回按钮、操作区和透明样式的构建方式。
// English: This file wraps the shared app bar and standardizes titles, back actions, trailing actions, and transparent styling.
//
// 中文：本文件的注释统一采用“上中文、下英文”的双语顺序，不能使用 ASCII 转码代替中文。
// English: Comments in this file keep Chinese above English and use real Chinese characters instead of ASCII escapes.

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:soys_app/app/theme/app_theme.dart';

/// 自定义 AppBar 组件
/// 中文：承载 AppAppBar 的核心职责，配合当前文件完成对应业务或界面逻辑。
/// English: AppAppBar carries its core responsibility and supports the business or UI logic in this file.
class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AppAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.leading,
    this.actions,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 0,
    this.centerTitle = true,
    this.showBackButton = true,
    this.backButtonColor,
    this.onBack,
    this.transparent = false,
    this.borderBottom = true,
    this.titleStyle,
    this.toolbarHeight,
    this.bottom,
  });

  /// 标题文字
  final String? title;

  /// 标题组件（与 title 互斥）
  final Widget? titleWidget;

  /// 左侧组件
  final Widget? leading;

  /// 右侧操作区
  final List<Widget>? actions;

  /// 背景色
  final Color? backgroundColor;

  /// 前景色
  final Color? foregroundColor;

  /// 阴影
  final double elevation;

  /// 是否居中标题
  final bool centerTitle;

  /// 是否显示返回按钮
  final bool showBackButton;

  /// 返回按钮颜色
  final Color? backButtonColor;

  /// 返回按钮回调
  final VoidCallback? onBack;

  /// 是否透明背景
  final bool transparent;

  /// 是否显示底部边框
  final bool borderBottom;

  /// 标题样式
  final TextStyle? titleStyle;

  /// 工具栏高度
  final double? toolbarHeight;

  /// 底部组件
  final PreferredSizeWidget? bottom;

  @override
  Size get preferredSize {
    final height = toolbarHeight ?? kToolbarHeight;
    return Size.fromHeight(height + (bottom?.preferredSize.height ?? 0));
  }

  /// 中文：构建当前组件的界面树，并根据响应式状态刷新可见内容。
  /// English: Builds the widget tree for this component and refreshes visible content from reactive state.
  @override
  Widget build(BuildContext context) {
    // 透明模式
    if (transparent) {
      return _buildTransparentAppBar(context);
    }

    final effectiveBgColor = backgroundColor ?? AppTheme.bgPrimary;
    final effectiveFgColor = foregroundColor ?? AppTheme.textPrimary;

    return Container(
      decoration: borderBottom
          ? BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppTheme.dividerColor, width: 0.5.w),
              ),
            )
          : null,
      child: AppBar(
        title:
            titleWidget ??
            (title != null
                ? Text(
                    title!,
                    style:
                        titleStyle ??
                        TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: effectiveFgColor,
                        ),
                  )
                : null),
        centerTitle: centerTitle,
        elevation: elevation,
        backgroundColor: effectiveBgColor,
        foregroundColor: effectiveFgColor,
        leading: _buildLeading(effectiveFgColor),
        actions: actions,
        bottom: bottom,
        toolbarHeight: toolbarHeight,
        titleSpacing: title != null || titleWidget != null ? null : 0,
      ),
    );
  }

  /// 中文：构建当前页面中的局部 UI 片段，保持主构建方法结构清晰。
  /// English: Builds a focused UI section in the page so the main build method stays readable.
  Widget _buildTransparentAppBar(BuildContext context) {
    return AppBar(
      title:
          titleWidget ??
          (title != null
              ? Text(
                  title!,
                  style:
                      titleStyle ??
                      TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                )
              : null),
      centerTitle: centerTitle,
      elevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: foregroundColor ?? Colors.white,
      leading: _buildLeading(foregroundColor ?? Colors.white),
      actions: actions,
      bottom: bottom,
      toolbarHeight: toolbarHeight,
      flexibleSpace: transparent ? const SizedBox.shrink() : null,
    );
  }

  /// 中文：构建当前页面中的局部 UI 片段，保持主构建方法结构清晰。
  /// English: Builds a focused UI section in the page so the main build method stays readable.
  Widget? _buildLeading(Color color) {
    if (leading != null) return leading;
    if (!showBackButton) return null;

    // 检查能否返回
    final canPop = Navigator.of(Get.context!).canPop();

    if (!canPop) return const SizedBox.shrink();

    return IconButton(
      icon: Icon(
        Icons.arrow_back_ios_new,
        size: 22.w,
        color: backButtonColor ?? color,
      ),
      onPressed: onBack ?? () => Get.back(),
      padding: EdgeInsets.only(left: 16.w),
      constraints: BoxConstraints(minWidth: 44.w, minHeight: 44.w),
    );
  }
}
