// 中文：本文件封装通用按钮组件，统一按钮类型、尺寸、加载态、禁用态和颜色规则。
// English: This file wraps shared button widgets and standardizes button types, sizes, loading states, disabled states, and color rules.
//
// 中文：本文件的注释统一采用“上中文、下英文”的双语顺序，不能使用 ASCII 转码代替中文。
// English: Comments in this file keep Chinese above English and use real Chinese characters instead of ASCII escapes.

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:soys_app/app/theme/app_theme.dart';

/// 按钮类型
/// 中文：定义 AppButtonType 枚举值，用于限制调用方只能选择受支持的业务选项。
/// English: AppButtonType defines enum values so callers can only choose supported business options.
enum AppButtonType {
  /// 主要按钮 - 实心背景
  primary,

  /// 次要按钮 - 浅色背景
  secondary,

  /// 描边按钮
  outline,

  /// 文本按钮
  text,
}

/// 按钮尺寸
/// 中文：定义 AppButtonSize 枚举值，用于限制调用方只能选择受支持的业务选项。
/// English: AppButtonSize defines enum values so callers can only choose supported business options.
enum AppButtonSize {
  /// 大按钮 h=48
  large,

  /// 中按钮 h=44
  medium,

  /// 小按钮 h=36
  small,
}

/// 通用按钮组件
/// 中文：承载 AppButton 的核心职责，配合当前文件完成对应业务或界面逻辑。
/// English: AppButton carries its core responsibility and supports the business or UI logic in this file.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = AppButtonType.primary,
    this.size = AppButtonSize.large,
    this.icon,
    this.iconRight,
    this.loading = false,
    this.disabled = false,
    this.fullWidth = true,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.borderRadius,
    this.padding,
    this.fontSize,
  });

  /// 按钮文字
  final String text;

  /// 点击回调
  final VoidCallback? onPressed;

  /// 按钮类型
  final AppButtonType type;

  /// 按钮尺寸
  final AppButtonSize size;

  /// 左侧图标
  final Widget? icon;

  /// 右侧图标
  final Widget? iconRight;

  /// 是否加载中
  final bool loading;

  /// 是否禁用
  final bool disabled;

  /// 是否全宽
  final bool fullWidth;

  /// 自定义背景色
  final Color? backgroundColor;

  /// 自定义文字色
  final Color? textColor;

  /// 自定义边框色
  final Color? borderColor;

  /// 自定义圆角
  final double? borderRadius;

  /// 自定义内边距
  final EdgeInsetsGeometry? padding;

  /// 自定义字号
  final double? fontSize;

  /// 中文：构建当前组件的界面树，并根据响应式状态刷新可见内容。
  /// English: Builds the widget tree for this component and refreshes visible content from reactive state.
  @override
  Widget build(BuildContext context) {
    final isDisabled = disabled || loading;
    final effectiveHeight = _getHeight();
    final effectiveBorderRadius = borderRadius ?? 8.r;
    final effectiveFontSize = fontSize ?? _getFontSize();

    // 根据类型确定颜色
    final colors = _getColors(isDisabled);

    Widget child = Row(
      mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (loading)
          Padding(
            padding: EdgeInsets.only(right: 6.w),
            child: SizedBox(
              width: 18.w,
              height: 18.w,
              child: CircularProgressIndicator(
                strokeWidth: 2.w,
                valueColor: AlwaysStoppedAnimation<Color>(colors.textColor),
              ),
            ),
          )
        else if (icon != null)
          Padding(
            padding: EdgeInsets.only(right: 6.w),
            child: IconTheme(
              data: IconThemeData(
                size: effectiveFontSize + 2,
                color: colors.textColor,
              ),
              child: icon!,
            ),
          ),
        Flexible(
          child: Text(
            text,
            style: TextStyle(
              fontSize: effectiveFontSize.sp,
              fontWeight: FontWeight.w600,
              color: colors.textColor,
            ),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
        if (iconRight != null && !loading)
          Padding(
            padding: EdgeInsets.only(left: 6.w),
            child: IconTheme(
              data: IconThemeData(
                size: effectiveFontSize + 2,
                color: colors.textColor,
              ),
              child: iconRight!,
            ),
          ),
      ],
    );

    // 根据类型构建不同按钮
    switch (type) {
      case AppButtonType.primary:
        return _buildPrimary(
          child: child,
          height: effectiveHeight,
          borderRadius: effectiveBorderRadius,
          colors: colors,
          isDisabled: isDisabled,
        );
      case AppButtonType.secondary:
        return _buildSecondary(
          child: child,
          height: effectiveHeight,
          borderRadius: effectiveBorderRadius,
          colors: colors,
          isDisabled: isDisabled,
        );
      case AppButtonType.outline:
        return _buildOutline(
          child: child,
          height: effectiveHeight,
          borderRadius: effectiveBorderRadius,
          colors: colors,
          isDisabled: isDisabled,
        );
      case AppButtonType.text:
        return _buildText(
          child: child,
          height: effectiveHeight,
          colors: colors,
          isDisabled: isDisabled,
        );
    }
  }

  /// 中文：构建当前页面中的局部 UI 片段，保持主构建方法结构清晰。
  /// English: Builds a focused UI section in the page so the main build method stays readable.
  Widget _buildPrimary({
    required Widget child,
    required double height,
    required double borderRadius,
    required _ButtonColors colors,
    required bool isDisabled,
  }) {
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: height,
      child: ElevatedButton(
        onPressed: isDisabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.backgroundColor,
          disabledBackgroundColor: colors.backgroundColor.withValues(
            alpha: isDisabled ? 0.5 : 1.0,
          ),
          foregroundColor: colors.textColor,
          disabledForegroundColor: colors.textColor.withValues(alpha: 0.6),
          elevation: 0,
          shadowColor: Colors.transparent,
          padding:
              padding ?? EdgeInsets.symmetric(horizontal: 24.w, vertical: 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: child,
      ),
    );
  }

  /// 中文：构建当前页面中的局部 UI 片段，保持主构建方法结构清晰。
  /// English: Builds a focused UI section in the page so the main build method stays readable.
  Widget _buildSecondary({
    required Widget child,
    required double height,
    required double borderRadius,
    required _ButtonColors colors,
    required bool isDisabled,
  }) {
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: height,
      child: ElevatedButton(
        onPressed: isDisabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.backgroundColor,
          disabledBackgroundColor: colors.backgroundColor.withValues(
            alpha: isDisabled ? 0.5 : 1.0,
          ),
          foregroundColor: colors.textColor,
          disabledForegroundColor: colors.textColor.withValues(alpha: 0.6),
          elevation: 0,
          shadowColor: Colors.transparent,
          padding:
              padding ?? EdgeInsets.symmetric(horizontal: 24.w, vertical: 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: child,
      ),
    );
  }

  /// 中文：构建当前页面中的局部 UI 片段，保持主构建方法结构清晰。
  /// English: Builds a focused UI section in the page so the main build method stays readable.
  Widget _buildOutline({
    required Widget child,
    required double height,
    required double borderRadius,
    required _ButtonColors colors,
    required bool isDisabled,
  }) {
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: height,
      child: OutlinedButton(
        onPressed: isDisabled ? null : onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: colors.backgroundColor,
          disabledBackgroundColor: colors.backgroundColor,
          foregroundColor: colors.textColor,
          disabledForegroundColor: colors.textColor.withValues(alpha: 0.6),
          side: BorderSide(
            color: isDisabled
                ? (borderColor ?? AppTheme.primaryColor).withValues(alpha: 0.4)
                : (borderColor ?? AppTheme.primaryColor),
          ),
          padding:
              padding ?? EdgeInsets.symmetric(horizontal: 24.w, vertical: 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: child,
      ),
    );
  }

  /// 中文：构建当前页面中的局部 UI 片段，保持主构建方法结构清晰。
  /// English: Builds a focused UI section in the page so the main build method stays readable.
  Widget _buildText({
    required Widget child,
    required double height,
    required _ButtonColors colors,
    required bool isDisabled,
  }) {
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: height,
      child: TextButton(
        onPressed: isDisabled ? null : onPressed,
        style: TextButton.styleFrom(
          backgroundColor: colors.backgroundColor,
          foregroundColor: colors.textColor,
          disabledForegroundColor: colors.textColor.withValues(alpha: 0.6),
          padding:
              padding ?? EdgeInsets.symmetric(horizontal: 16.w, vertical: 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        child: child,
      ),
    );
  }

  /// 中文：根据当前输入计算并返回调用方需要的派生值。
  /// English: Computes and returns the derived value required by the caller from the current input.
  double _getHeight() {
    switch (size) {
      case AppButtonSize.large:
        return 48.h;
      case AppButtonSize.medium:
        return 44.h;
      case AppButtonSize.small:
        return 36.h;
    }
  }

  /// 中文：根据当前输入计算并返回调用方需要的派生值。
  /// English: Computes and returns the derived value required by the caller from the current input.
  double _getFontSize() {
    switch (size) {
      case AppButtonSize.large:
        return 16;
      case AppButtonSize.medium:
        return 15;
      case AppButtonSize.small:
        return 13;
    }
  }

  _ButtonColors _getColors(bool isDisabled) {
    switch (type) {
      case AppButtonType.primary:
        return _ButtonColors(
          backgroundColor: backgroundColor ?? AppTheme.primaryColor,
          textColor: textColor ?? Colors.white,
        );
      case AppButtonType.secondary:
        return _ButtonColors(
          backgroundColor:
              backgroundColor ?? AppTheme.primaryColor.withValues(alpha: 0.1),
          textColor: textColor ?? AppTheme.primaryColor,
        );
      case AppButtonType.outline:
        return _ButtonColors(
          backgroundColor: backgroundColor ?? Colors.transparent,
          textColor: textColor ?? AppTheme.primaryColor,
        );
      case AppButtonType.text:
        return _ButtonColors(
          backgroundColor: backgroundColor ?? Colors.transparent,
          textColor: textColor ?? AppTheme.primaryColor,
        );
    }
  }
}

/// 中文：承载 ButtonColors 的核心职责，配合当前文件完成对应业务或界面逻辑。
/// English: ButtonColors carries its core responsibility and supports the business or UI logic in this file.
class _ButtonColors {
  const _ButtonColors({required this.backgroundColor, required this.textColor});

  final Color backgroundColor;
  final Color textColor;
}
