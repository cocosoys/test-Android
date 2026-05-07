// 中文：本文件封装骨架屏占位组件，统一页面加载时的线条、圆形、卡片和列表占位效果。
// English: This file wraps skeleton placeholders and standardizes line, circle, card, and list loading effects.
//
// 中文：本文件的注释统一采用“上中文、下英文”的双语顺序，不能使用 ASCII 转码代替中文。
// English: Comments in this file keep Chinese above English and use real Chinese characters instead of ASCII escapes.

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:soys_app/app/theme/app_theme.dart';

/// 骨架屏 - 基础闪烁容器
/// 中文：承载 SkeletonPlaceholder 的核心职责，配合当前文件完成对应业务或界面逻辑。
/// English: SkeletonPlaceholder carries its core responsibility and supports the business or UI logic in this file.
class SkeletonPlaceholder extends StatefulWidget {
  const SkeletonPlaceholder({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
    this.enabled = true,
  });

  /// 子组件
  final Widget child;

  /// 基色
  final Color? baseColor;

  /// 高亮色
  final Color? highlightColor;

  /// 是否启用
  final bool enabled;

  @override
  State<SkeletonPlaceholder> createState() => _SkeletonPlaceholderState();
}

/// 中文：承载 SkeletonPlaceholderState 的核心职责，配合当前文件完成对应业务或界面逻辑。
/// English: SkeletonPlaceholderState carries its core responsibility and supports the business or UI logic in this file.
class _SkeletonPlaceholderState extends State<SkeletonPlaceholder>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  /// 中文：完成当前对象的初始化流程，确保依赖、监听器或初始数据在使用前准备好。
  /// English: Initializes the current object so dependencies, listeners, or initial data are ready before use.
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  /// 中文：释放当前对象持有的控制器、监听器或异步资源，避免页面销毁后继续占用资源。
  /// English: Releases controllers, listeners, or async resources held by this object so they do not outlive the page.
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// 中文：构建当前组件的界面树，并根据响应式状态刷新可见内容。
  /// English: Builds the widget tree for this component and refreshes visible content from reactive state.
  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;

    final baseColor = widget.baseColor ?? AppTheme.bgSecondary;
    final highlightColor =
        widget.highlightColor ?? AppTheme.borderColor.withValues(alpha: 0.6);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [baseColor, highlightColor, baseColor],
              stops: const [0.0, 0.5, 1.0],
              begin: Alignment(-1.0 + 2.0 * _controller.value, 0),
              end: Alignment(1.0 + 2.0 * _controller.value, 0),
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

/// 自定义 AnimatedBuilder（兼容无第三方 shimmer 依赖）
/// 中文：承载 AnimatedBuilder 的核心职责，配合当前文件完成对应业务或界面逻辑。
/// English: AnimatedBuilder carries its core responsibility and supports the business or UI logic in this file.
class AnimatedBuilder extends AnimatedWidget {
  const AnimatedBuilder({
    super.key,
    required Listenable animation,
    required this.builder,
    this.child,
  }) : super(listenable: animation);

  final Widget Function(BuildContext context, Widget? child) builder;

  final Widget? child;

  /// 中文：构建当前组件的界面树，并根据响应式状态刷新可见内容。
  /// English: Builds the widget tree for this component and refreshes visible content from reactive state.
  @override
  Widget build(BuildContext context) {
    return builder(context, child);
  }
}

/// 骨架屏 - 单行
/// 中文：承载 SkeletonLine 的核心职责，配合当前文件完成对应业务或界面逻辑。
/// English: SkeletonLine carries its core responsibility and supports the business or UI logic in this file.
class SkeletonLine extends StatelessWidget {
  const SkeletonLine({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.baseColor,
    this.highlightColor,
    this.margin,
  });

  /// 宽度（默认撑满）
  final double? width;

  /// 高度
  final double? height;

  /// 圆角
  final double? borderRadius;

  /// 基色
  final Color? baseColor;

  /// 高亮色
  final Color? highlightColor;

  /// 外边距
  final EdgeInsetsGeometry? margin;

  /// 中文：构建当前组件的界面树，并根据响应式状态刷新可见内容。
  /// English: Builds the widget tree for this component and refreshes visible content from reactive state.
  @override
  Widget build(BuildContext context) {
    final effectiveHeight = height ?? 14.h;
    final effectiveBorderRadius = borderRadius ?? 4.r;
    final effectiveBaseColor = baseColor ?? AppTheme.bgSecondary;
    final effectiveHighlightColor =
        highlightColor ?? AppTheme.borderColor.withValues(alpha: 0.6);

    return Container(
      width: width,
      height: effectiveHeight,
      margin: margin,
      decoration: BoxDecoration(
        color: effectiveBaseColor,
        borderRadius: BorderRadius.circular(effectiveBorderRadius),
      ),
      child: SkeletonPlaceholder(
        baseColor: effectiveBaseColor,
        highlightColor: effectiveHighlightColor,
        child: Container(
          width: width,
          height: effectiveHeight,
          decoration: BoxDecoration(
            color: effectiveBaseColor,
            borderRadius: BorderRadius.circular(effectiveBorderRadius),
          ),
        ),
      ),
    );
  }
}

/// 骨架屏 - 圆形
/// 中文：承载 SkeletonCircle 的核心职责，配合当前文件完成对应业务或界面逻辑。
/// English: SkeletonCircle carries its core responsibility and supports the business or UI logic in this file.
class SkeletonCircle extends StatelessWidget {
  const SkeletonCircle({
    super.key,
    this.size = 44,
    this.baseColor,
    this.highlightColor,
    this.margin,
  });

  /// 大小
  final double size;

  /// 基色
  final Color? baseColor;

  /// 高亮色
  final Color? highlightColor;

  /// 外边距
  final EdgeInsetsGeometry? margin;

  /// 中文：构建当前组件的界面树，并根据响应式状态刷新可见内容。
  /// English: Builds the widget tree for this component and refreshes visible content from reactive state.
  @override
  Widget build(BuildContext context) {
    final effectiveBaseColor = baseColor ?? AppTheme.bgSecondary;
    final effectiveHighlightColor =
        highlightColor ?? AppTheme.borderColor.withValues(alpha: 0.6);

    return Container(
      width: size.w,
      height: size.w,
      margin: margin,
      child: SkeletonPlaceholder(
        baseColor: effectiveBaseColor,
        highlightColor: effectiveHighlightColor,
        child: Container(
          width: size.w,
          height: size.w,
          decoration: BoxDecoration(
            color: effectiveBaseColor,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

/// 骨架屏 - 卡片
/// 中文：承载 SkeletonCard 的核心职责，配合当前文件完成对应业务或界面逻辑。
/// English: SkeletonCard carries its core responsibility and supports the business or UI logic in this file.
class SkeletonCard extends StatelessWidget {
  const SkeletonCard({
    super.key,
    this.showAvatar = true,
    this.showTitle = true,
    this.showSubtitle = true,
    this.contentLines = 3,
    this.padding,
    this.borderRadius,
    this.baseColor,
    this.highlightColor,
  });

  /// 是否显示头像
  final bool showAvatar;

  /// 是否显示标题
  final bool showTitle;

  /// 是否显示副标题
  final bool showSubtitle;

  /// 内容行数
  final int contentLines;

  /// 内边距
  final EdgeInsetsGeometry? padding;

  /// 圆角
  final double? borderRadius;

  /// 基色
  final Color? baseColor;

  /// 高亮色
  final Color? highlightColor;

  /// 中文：构建当前组件的界面树，并根据响应式状态刷新可见内容。
  /// English: Builds the widget tree for this component and refreshes visible content from reactive state.
  @override
  Widget build(BuildContext context) {
    final effectivePadding =
        padding ?? EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h);
    final effectiveBorderRadius = borderRadius ?? 12.r;
    final effectiveBaseColor = baseColor ?? AppTheme.bgSecondary;
    final effectiveHighlightColor =
        highlightColor ?? AppTheme.borderColor.withValues(alpha: 0.6);

    return Container(
      padding: effectivePadding,
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(effectiveBorderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 头部：头像 + 标题行
          if (showAvatar || showTitle)
            Row(
              children: [
                if (showAvatar)
                  SkeletonCircle(
                    size: 40,
                    baseColor: effectiveBaseColor,
                    highlightColor: effectiveHighlightColor,
                  ),
                if (showAvatar && showTitle) SizedBox(width: 12.w),
                if (showTitle)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SkeletonLine(
                          width: 120.w,
                          height: 14.h,
                          baseColor: effectiveBaseColor,
                          highlightColor: effectiveHighlightColor,
                        ),
                        if (showSubtitle) ...[
                          SizedBox(height: 8.h),
                          SkeletonLine(
                            width: 80.w,
                            height: 12.h,
                            baseColor: effectiveBaseColor,
                            highlightColor: effectiveHighlightColor,
                          ),
                        ],
                      ],
                    ),
                  ),
              ],
            ),
          // 内容行
          if (contentLines > 0) ...[
            SizedBox(height: 16.h),
            ...List.generate(contentLines, (index) {
              final isLast = index == contentLines - 1;
              return Padding(
                padding: EdgeInsets.only(bottom: isLast ? 0 : 8.h),
                child: SkeletonLine(
                  width: isLast ? 200.w : null,
                  height: 12.h,
                  baseColor: effectiveBaseColor,
                  highlightColor: effectiveHighlightColor,
                ),
              );
            }),
          ],
        ],
      ),
    );
  }
}

/// 骨架屏 - 列表项
/// 中文：承载 SkeletonListItem 的核心职责，配合当前文件完成对应业务或界面逻辑。
/// English: SkeletonListItem carries its core responsibility and supports the business or UI logic in this file.
class SkeletonListItem extends StatelessWidget {
  const SkeletonListItem({
    super.key,
    this.showAvatar = true,
    this.lines = 2,
    this.baseColor,
    this.highlightColor,
  });

  final bool showAvatar;
  final int lines;
  final Color? baseColor;
  final Color? highlightColor;

  /// 中文：构建当前组件的界面树，并根据响应式状态刷新可见内容。
  /// English: Builds the widget tree for this component and refreshes visible content from reactive state.
  @override
  Widget build(BuildContext context) {
    final effectiveBaseColor = baseColor ?? AppTheme.bgSecondary;
    final effectiveHighlightColor =
        highlightColor ?? AppTheme.borderColor.withValues(alpha: 0.6);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showAvatar)
            SkeletonCircle(
              size: 44,
              baseColor: effectiveBaseColor,
              highlightColor: effectiveHighlightColor,
            ),
          if (showAvatar) SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(lines, (index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: index < lines - 1 ? 8.h : 0),
                  child: SkeletonLine(
                    width: index == 0
                        ? 150.w
                        : (index == lines - 1 ? 100.w : null),
                    height: index == 0 ? 14.h : 12.h,
                    baseColor: effectiveBaseColor,
                    highlightColor: effectiveHighlightColor,
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
