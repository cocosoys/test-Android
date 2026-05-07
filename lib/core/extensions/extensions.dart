// 中文：本文件扩展常用 Dart 和 Flutter 类型，提供点击、间距、可见性、透明度和字符串判断等语法糖。
// English: This file extends common Dart and Flutter types with helpers for tapping, spacing, visibility, opacity, and string checks.
//
// 中文：本文件的注释统一采用“上中文、下英文”的双语顺序，不能使用 ASCII 转码代替中文。
// English: Comments in this file keep Chinese above English and use real Chinese characters instead of ASCII escapes.

import 'package:flutter/material.dart';

/// Widget 扩展
/// 中文：为 WidgetExtension 扩展便捷能力，减少重复的 UI 或数据处理代码。
/// English: WidgetExtension adds convenience helpers that reduce repeated UI or data-handling code.
extension WidgetExtension on Widget {
  /// 添加点击事件
  /// 中文：执行 onTap 对应的业务步骤，并把内部细节封装在当前模块内。
  /// English: Executes the onTap business step while keeping internal details encapsulated in this module.
  Widget onTap(VoidCallback onTap, {double? padding}) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: padding != null
          ? Padding(padding: EdgeInsets.all(padding), child: this)
          : this,
    );
  }

  /// 添加内边距
  /// 中文：执行 padding 对应的业务步骤，并把内部细节封装在当前模块内。
  /// English: Executes the padding business step while keeping internal details encapsulated in this module.
  Widget padding(EdgeInsetsGeometry padding) {
    return Padding(padding: padding, child: this);
  }

  /// 添加圆角
  /// 中文：执行 borderRadius 对应的业务步骤，并把内部细节封装在当前模块内。
  /// English: Executes the borderRadius business step while keeping internal details encapsulated in this module.
  Widget borderRadius(BorderRadius borderRadius) {
    return ClipRRect(borderRadius: borderRadius, child: this);
  }

  /// 添加可见性控制
  /// 中文：执行 visible 对应的业务步骤，并把内部细节封装在当前模块内。
  /// English: Executes the visible business step while keeping internal details encapsulated in this module.
  Widget visible(bool visible) {
    return Visibility(visible: visible, child: this);
  }

  /// 添加透明度
  /// 中文：执行 opacity 对应的业务步骤，并把内部细节封装在当前模块内。
  /// English: Executes the opacity business step while keeping internal details encapsulated in this module.
  Widget opacity(double opacity) {
    return Opacity(opacity: opacity, child: this);
  }

  /// 居中
  Widget get center => Center(child: this);

  /// 扩展填充
  Widget get expanded => Expanded(child: this);

  /// 添加弹性
  /// 中文：执行 flexible 对应的业务步骤，并把内部细节封装在当前模块内。
  /// English: Executes the flexible business step while keeping internal details encapsulated in this module.
  Widget flexible({int flex = 1}) => Flexible(flex: flex, child: this);
}

/// String 扩展
/// 中文：为 StringExtension 扩展便捷能力，减少重复的 UI 或数据处理代码。
/// English: StringExtension adds convenience helpers that reduce repeated UI or data-handling code.
extension StringExtension on String {
  /// 是否是空或空白
  bool get isBlank => trim().isEmpty;

  /// 是否非空
  bool get isNotBlank => trim().isNotEmpty;
}

/// num 扩展
/// 中文：为 NumExtension 扩展便捷能力，减少重复的 UI 或数据处理代码。
/// English: NumExtension adds convenience helpers that reduce repeated UI or data-handling code.
extension NumExtension on num {
  /// 转换为 SizedBox 高度
  SizedBox get hBox => SizedBox(height: toDouble());

  /// 转换为 SizedBox 宽度
  SizedBox get wBox => SizedBox(width: toDouble());
}
