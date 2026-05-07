// 中文：本文件封装通用输入框，统一输入类型、校验、清空、密码显隐和样式控制。
// English: This file wraps shared input fields and standardizes input types, validation, clearing, password visibility, and styling.
//
// 中文：本文件的注释统一采用“上中文、下英文”的双语顺序，不能使用 ASCII 转码代替中文。
// English: Comments in this file keep Chinese above English and use real Chinese characters instead of ASCII escapes.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:soys_app/app/theme/app_theme.dart';

/// 输入框类型
/// 中文：定义 AppInputType 枚举值，用于限制调用方只能选择受支持的业务选项。
/// English: AppInputType defines enum values so callers can only choose supported business options.
enum AppInputType {
  /// 普通文本
  text,

  /// 手机号
  phone,

  /// 邮箱
  email,

  /// 账号
  account,

  /// 密码
  password,

  /// 数字
  number,

  /// 多行文本
  multiline,
}

/// 通用输入框组件
/// 中文：承载 AppInput 的核心职责，配合当前文件完成对应业务或界面逻辑。
/// English: AppInput carries its core responsibility and supports the business or UI logic in this file.
class AppInput extends StatefulWidget {
  const AppInput({
    super.key,
    this.controller,
    this.label,
    this.hintText,
    this.inputType = AppInputType.text,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.maxLength,
    this.maxLines = 1,
    this.errorText,
    this.showClearButton = true,
    this.showPasswordToggle = false,
    this.keyboardType,
    this.inputFormatters,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.focusNode,
    this.textInputAction,
    this.contentPadding,
    this.fillColor,
    this.borderRadius,
    this.labelStyle,
    this.hintStyle,
    this.style,
  });

  /// TextEditingController
  final TextEditingController? controller;

  /// 标签文字
  final String? label;

  /// 占位文字
  final String? hintText;

  /// 输入类型
  final AppInputType inputType;

  /// 前置图标
  final Widget? prefixIcon;

  /// 后置图标
  final Widget? suffixIcon;

  /// 是否密文
  final bool obscureText;

  /// 是否可用
  final bool enabled;

  /// 是否只读
  final bool readOnly;

  /// 最大长度
  final int? maxLength;

  /// 最大行数
  final int maxLines;

  /// 错误文本
  final String? errorText;

  /// 是否显示清除按钮
  final bool showClearButton;

  /// 是否显示密码切换按钮
  final bool showPasswordToggle;

  /// 键盘类型（覆盖默认）
  final TextInputType? keyboardType;

  /// 输入格式化
  final List<TextInputFormatter>? inputFormatters;

  /// 文字变化回调
  final ValueChanged<String>? onChanged;

  /// 提交回调
  final ValueChanged<String>? onSubmitted;

  /// 点击回调
  final VoidCallback? onTap;

  /// 焦点节点
  final FocusNode? focusNode;

  /// 输入动作
  final TextInputAction? textInputAction;

  /// 内边距
  final EdgeInsetsGeometry? contentPadding;

  /// 填充色
  final Color? fillColor;

  /// 圆角
  final double? borderRadius;

  /// 标签样式
  final TextStyle? labelStyle;

  /// 占位样式
  final TextStyle? hintStyle;

  /// 文字样式
  final TextStyle? style;

  @override
  State<AppInput> createState() => _AppInputState();
}

/// 中文：承载 AppInputState 的核心职责，配合当前文件完成对应业务或界面逻辑。
/// English: AppInputState carries its core responsibility and supports the business or UI logic in this file.
class _AppInputState extends State<AppInput> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _isObscured = true;
  bool _hasFocus = false;
  bool _hasText = false;

  /// 中文：完成当前对象的初始化流程，确保依赖、监听器或初始数据在使用前准备好。
  /// English: Initializes the current object so dependencies, listeners, or initial data are ready before use.
  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();
    _isObscured =
        widget.obscureText || widget.inputType == AppInputType.password;
    _hasText = _controller.text.isNotEmpty;

    _focusNode.addListener(_onFocusChange);
    _controller.addListener(_onTextChange);
  }

  /// 中文：根据当前输入计算并返回调用方需要的派生值。
  /// English: Computes and returns the derived value required by the caller from the current input.
  @override
  void didUpdateWidget(covariant AppInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != null && widget.controller != _controller) {
      _controller.removeListener(_onTextChange);
      _controller = widget.controller!;
      _controller.addListener(_onTextChange);
      _hasText = _controller.text.isNotEmpty;
    }
    if (widget.focusNode != null && widget.focusNode != _focusNode) {
      _focusNode.removeListener(_onFocusChange);
      _focusNode = widget.focusNode!;
      _focusNode.addListener(_onFocusChange);
    }
  }

  /// 中文：释放当前对象持有的控制器、监听器或异步资源，避免页面销毁后继续占用资源。
  /// English: Releases controllers, listeners, or async resources held by this object so they do not outlive the page.
  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _controller.removeListener(_onTextChange);
    // 仅在内部创建时释放
    if (widget.controller == null) _controller.dispose();
    if (widget.focusNode == null) _focusNode.dispose();
    super.dispose();
  }

  /// 中文：执行 onFocusChange 对应的业务步骤，并把内部细节封装在当前模块内。
  /// English: Executes the onFocusChange business step while keeping internal details encapsulated in this module.
  void _onFocusChange() {
    setState(() {
      _hasFocus = _focusNode.hasFocus;
    });
  }

  /// 中文：执行 onTextChange 对应的业务步骤，并把内部细节封装在当前模块内。
  /// English: Executes the onTextChange business step while keeping internal details encapsulated in this module.
  void _onTextChange() {
    final hasText = _controller.text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
  }

  TextInputType _getKeyboardType() {
    if (widget.keyboardType != null) return widget.keyboardType!;
    switch (widget.inputType) {
      case AppInputType.phone:
      case AppInputType.number:
        return TextInputType.phone;
      case AppInputType.email:
        return TextInputType.emailAddress;
      case AppInputType.account:
        return TextInputType.text;
      case AppInputType.password:
        return TextInputType.visiblePassword;
      case AppInputType.multiline:
        return TextInputType.multiline;
      case AppInputType.text:
        return TextInputType.text;
    }
  }

  /// 中文：根据当前输入计算并返回调用方需要的派生值。
  /// English: Computes and returns the derived value required by the caller from the current input.
  List<TextInputFormatter> _getInputFormatters() {
    final formatters = <TextInputFormatter>[...?widget.inputFormatters];
    if (widget.inputType == AppInputType.phone) {
      formatters.add(FilteringTextInputFormatter.digitsOnly);
      formatters.add(LengthLimitingTextInputFormatter(11));
    }
    if (widget.inputType == AppInputType.number) {
      formatters.add(FilteringTextInputFormatter.digitsOnly);
    }
    return formatters;
  }

  /// 中文：根据当前输入计算并返回调用方需要的派生值。
  /// English: Computes and returns the derived value required by the caller from the current input.
  String? _getHintText() {
    if (widget.hintText != null) return widget.hintText;
    switch (widget.inputType) {
      case AppInputType.phone:
        return 'phone_hint'.tr;
      case AppInputType.email:
        return 'email_hint'.tr;
      case AppInputType.account:
        return 'account_hint'.tr;
      case AppInputType.password:
        return 'password_hint'.tr;
      case AppInputType.text:
      case AppInputType.number:
      case AppInputType.multiline:
        return null;
    }
  }

  /// 中文：构建当前页面中的局部 UI 片段，保持主构建方法结构清晰。
  /// English: Builds a focused UI section in the page so the main build method stays readable.
  Widget? _buildPrefixIcon() {
    if (widget.prefixIcon != null) return widget.prefixIcon;
    IconData? iconData;
    switch (widget.inputType) {
      case AppInputType.phone:
        iconData = Icons.phone_android;
        break;
      case AppInputType.email:
        iconData = Icons.email_outlined;
        break;
      case AppInputType.account:
        iconData = Icons.person_outline;
        break;
      case AppInputType.password:
        iconData = Icons.lock_outline;
        break;
      default:
        return null;
    }
    return Icon(
      iconData,
      size: 22.w,
      color: _hasFocus ? AppTheme.primaryColor : AppTheme.textHint,
    );
  }

  /// 中文：构建当前页面中的局部 UI 片段，保持主构建方法结构清晰。
  /// English: Builds a focused UI section in the page so the main build method stays readable.
  Widget? _buildSuffixIcon() {
    final List<Widget> actions = [];

    // 清除按钮
    if (widget.showClearButton && _hasText && _hasFocus && !widget.readOnly) {
      actions.add(
        GestureDetector(
          onTap: () {
            _controller.clear();
            widget.onChanged?.call('');
          },
          child: Padding(
            padding: EdgeInsets.all(8.w),
            child: Icon(Icons.cancel, size: 18.w, color: AppTheme.textHint),
          ),
        ),
      );
    }

    // 密码切换按钮
    if (widget.showPasswordToggle ||
        widget.inputType == AppInputType.password ||
        widget.obscureText) {
      actions.add(
        GestureDetector(
          onTap: () {
            setState(() {
              _isObscured = !_isObscured;
            });
          },
          child: Padding(
            padding: EdgeInsets.all(8.w),
            child: Icon(
              _isObscured
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              size: 18.w,
              color: AppTheme.textHint,
            ),
          ),
        ),
      );
    }

    // 自定义后置图标
    if (widget.suffixIcon != null) {
      actions.add(widget.suffixIcon!);
    }

    if (actions.isEmpty) return null;
    if (actions.length == 1) return actions.first;

    return Row(mainAxisSize: MainAxisSize.min, children: actions);
  }

  /// 中文：构建当前组件的界面树，并根据响应式状态刷新可见内容。
  /// English: Builds the widget tree for this component and refreshes visible content from reactive state.
  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius = widget.borderRadius ?? 8.r;
    final effectiveFillColor = widget.fillColor ?? AppTheme.bgSecondary;
    final effectiveContentPadding =
        widget.contentPadding ??
        EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h);

    final isPassword =
        widget.inputType == AppInputType.password || widget.obscureText;

    Widget textField = TextField(
      controller: _controller,
      focusNode: _focusNode,
      obscureText: isPassword && _isObscured,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      maxLength: widget.maxLength,
      maxLines: isPassword ? 1 : widget.maxLines,
      keyboardType: _getKeyboardType(),
      inputFormatters: _getInputFormatters(),
      textInputAction:
          widget.textInputAction ??
          (widget.inputType == AppInputType.multiline
              ? TextInputAction.newline
              : TextInputAction.done),
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      onTap: widget.onTap,
      style:
          widget.style ??
          TextStyle(fontSize: 15.sp, color: AppTheme.textPrimary),
      decoration: InputDecoration(
        hintText: _getHintText(),
        hintStyle:
            widget.hintStyle ??
            TextStyle(fontSize: 14.sp, color: AppTheme.textHint),
        prefixIcon: _buildPrefixIcon(),
        prefixIconConstraints: BoxConstraints(
          minWidth: widget.prefixIcon != null || _buildPrefixIcon() != null
              ? 44.w
              : 0,
          minHeight: 0,
        ),
        suffixIcon: _buildSuffixIcon(),
        suffixIconConstraints: BoxConstraints(
          minWidth: _buildSuffixIcon() != null ? 36.w : 0,
          minHeight: 0,
        ),
        filled: true,
        fillColor: widget.enabled
            ? effectiveFillColor
            : effectiveFillColor.withValues(alpha: 0.5),
        contentPadding: effectiveContentPadding,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(effectiveBorderRadius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(effectiveBorderRadius),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(effectiveBorderRadius),
          borderSide: BorderSide(color: AppTheme.primaryColor, width: 1.5.w),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(effectiveBorderRadius),
          borderSide: const BorderSide(color: AppTheme.errorColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(effectiveBorderRadius),
          borderSide: const BorderSide(color: AppTheme.errorColor, width: 1.5),
        ),
        errorText: widget.errorText,
        errorStyle: TextStyle(fontSize: 12.sp, color: AppTheme.errorColor),
        counterText: '',
        isDense: true,
      ),
    );

    // 带标签
    if (widget.label != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Text(
              widget.label!,
              style:
                  widget.labelStyle ??
                  TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textPrimary,
                  ),
            ),
          ),
          textField,
        ],
      );
    }

    return textField;
  }
}
