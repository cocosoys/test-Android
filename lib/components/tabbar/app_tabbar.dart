// 中文：本文件封装顶部标签和分段标签组件，统一选中态、指示器和动画对齐逻辑。
// English: This file wraps tab and segmented tab widgets, standardizing selected states, indicators, and animation alignment.
//
// 中文：本文件的注释统一采用“上中文、下英文”的双语顺序，不能使用 ASCII 转码代替中文。
// English: Comments in this file keep Chinese above English and use real Chinese characters instead of ASCII escapes.

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:soys_app/app/theme/app_theme.dart';

/// 带样式的 TabBar 组件
/// 中文：承载 AppTabBar 的核心职责，配合当前文件完成对应业务或界面逻辑。
/// English: AppTabBar carries its core responsibility and supports the business or UI logic in this file.
class AppTabBar extends StatelessWidget {
  const AppTabBar({
    super.key,
    required this.tabs,
    this.controller,
    this.onTap,
    this.labelColor,
    this.unselectedLabelColor,
    this.indicatorColor,
    this.indicatorHeight = 3,
    this.indicatorWidth,
    this.labelFontSize = 15,
    this.unselectedLabelFontSize = 14,
    this.backgroundColor,
    this.isScrollable = false,
    this.padding,
    this.labelStyle,
    this.unselectedLabelStyle,
    this.indicatorPadding,
    this.tabAlignment,
  });

  /// Tab 列表
  final List<String> tabs;

  /// TabController
  final TabController? controller;

  /// Tab 点击回调
  final ValueChanged<int>? onTap;

  /// 选中文字颜色
  final Color? labelColor;

  /// 未选中文字颜色
  final Color? unselectedLabelColor;

  /// 指示器颜色
  final Color? indicatorColor;

  /// 指示器高度
  final double indicatorHeight;

  /// 指示器宽度（null 则使用默认 UnderlineIndicator）
  final double? indicatorWidth;

  /// 选中字号
  final double labelFontSize;

  /// 未选中字号
  final double unselectedLabelFontSize;

  /// 背景色
  final Color? backgroundColor;

  /// 是否可滚动
  final bool isScrollable;

  /// 内边距
  final EdgeInsetsGeometry? padding;

  /// 选中标签样式
  final TextStyle? labelStyle;

  /// 未选中标签样式
  final TextStyle? unselectedLabelStyle;

  /// 指示器内边距
  final EdgeInsetsGeometry? indicatorPadding;

  /// Tab 对齐方式
  final TabAlignment? tabAlignment;

  /// 中文：构建当前组件的界面树，并根据响应式状态刷新可见内容。
  /// English: Builds the widget tree for this component and refreshes visible content from reactive state.
  @override
  Widget build(BuildContext context) {
    final effectiveLabelColor = labelColor ?? AppTheme.primaryColor;
    final effectiveUnselectedLabelColor =
        unselectedLabelColor ?? AppTheme.textHint;
    final effectiveIndicatorColor = indicatorColor ?? AppTheme.primaryColor;

    return Container(
      color: backgroundColor ?? AppTheme.bgPrimary,
      child: TabBar(
        controller: controller,
        isScrollable: isScrollable,
        padding: padding ?? EdgeInsets.zero,
        labelColor: effectiveLabelColor,
        unselectedLabelColor: effectiveUnselectedLabelColor,
        labelStyle:
            labelStyle ??
            TextStyle(fontSize: labelFontSize.sp, fontWeight: FontWeight.w600),
        unselectedLabelStyle:
            unselectedLabelStyle ??
            TextStyle(
              fontSize: unselectedLabelFontSize.sp,
              fontWeight: FontWeight.normal,
            ),
        indicatorColor: effectiveIndicatorColor,
        indicatorSize: TabBarIndicatorSize.label,
        indicatorWeight: indicatorHeight.w,
        indicatorPadding: indicatorPadding ?? EdgeInsets.zero,
        indicator: indicatorWidth != null
            ? _CustomUnderlineIndicator(
                width: indicatorWidth!,
                height: indicatorHeight,
                color: effectiveIndicatorColor,
                borderRadius: indicatorHeight / 2,
              )
            : null,
        tabAlignment: tabAlignment,
        dividerColor: AppTheme.dividerColor,
        dividerHeight: 0.5,
        onTap: onTap,
        tabs: tabs.map((tab) => Tab(height: 44.h, text: tab)).toList(),
      ),
    );
  }
}

/// 自定义下划线指示器（支持固定宽度）
/// 中文：承载 CustomUnderlineIndicator 的核心职责，配合当前文件完成对应业务或界面逻辑。
/// English: CustomUnderlineIndicator carries its core responsibility and supports the business or UI logic in this file.
class _CustomUnderlineIndicator extends Decoration {
  const _CustomUnderlineIndicator({
    required this.width,
    required this.height,
    required this.color,
    this.borderRadius = 0,
  });

  final double width;
  final double height;
  final Color color;
  final double borderRadius;

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CustomUnderlinePainter(
      width: width,
      height: height,
      color: color,
      borderRadius: borderRadius,
    );
  }
}

/// 中文：承载 CustomUnderlinePainter 的核心职责，配合当前文件完成对应业务或界面逻辑。
/// English: CustomUnderlinePainter carries its core responsibility and supports the business or UI logic in this file.
class _CustomUnderlinePainter extends BoxPainter {
  _CustomUnderlinePainter({
    required this.width,
    required this.height,
    required this.color,
    required this.borderRadius,
  });

  final double width;
  final double height;
  final Color color;
  final double borderRadius;

  /// 中文：执行 paint 对应的业务步骤，并把内部细节封装在当前模块内。
  /// English: Executes the paint business step while keeping internal details encapsulated in this module.
  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final double? tabWidth = configuration.size?.width;
    if (tabWidth == null) return;

    // 指示器居中
    final double dx = offset.dx + (tabWidth - width) / 2;
    final double dy = offset.dy + (configuration.size?.height ?? 0) - height;

    final rect = Rect.fromLTWH(dx, dy, width, height);
    final rrect = RRect.fromRectAndCorners(
      rect,
      topLeft: Radius.circular(borderRadius),
      topRight: Radius.circular(borderRadius),
    );

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawRRect(rrect, paint);
  }
}

/// 分段控制器 TabBar
/// 中文：承载 AppSegmentTabBar 的核心职责，配合当前文件完成对应业务或界面逻辑。
/// English: AppSegmentTabBar carries its core responsibility and supports the business or UI logic in this file.
class AppSegmentTabBar extends StatelessWidget {
  const AppSegmentTabBar({
    super.key,
    required this.tabs,
    this.controller,
    this.onTap,
    this.activeColor,
    this.inactiveColor,
    this.textColor,
    this.activeTextColor,
    this.height = 36,
    this.borderRadius,
    this.margin,
    this.fontSize = 13,
  });

  /// Tab 列表
  final List<String> tabs;

  /// TabController
  final TabController? controller;

  /// 点击回调
  final ValueChanged<int>? onTap;

  /// 选中背景色
  final Color? activeColor;

  /// 未选中背景色
  final Color? inactiveColor;

  /// 未选中文字色
  final Color? textColor;

  /// 选中文字色
  final Color? activeTextColor;

  /// 高度
  final double height;

  /// 圆角
  final double? borderRadius;

  /// 外边距
  final EdgeInsetsGeometry? margin;

  /// 字号
  final double fontSize;

  /// 中文：构建当前组件的界面树，并根据响应式状态刷新可见内容。
  /// English: Builds the widget tree for this component and refreshes visible content from reactive state.
  @override
  Widget build(BuildContext context) {
    final effectiveActiveColor = activeColor ?? AppTheme.primaryColor;
    final effectiveInactiveColor = inactiveColor ?? AppTheme.bgSecondary;
    final effectiveTextColor = textColor ?? AppTheme.textSecondary;
    final effectiveActiveTextColor = activeTextColor ?? Colors.white;
    final effectiveBorderRadius = borderRadius ?? 8.r;

    return Container(
      margin: margin ?? EdgeInsets.symmetric(horizontal: 16.w),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return AnimatedBuilder2(
            animation: controller ?? DefaultTabController.of(context),
            builder: (context, _) {
              final tabController =
                  controller ?? DefaultTabController.of(context);
              final selectedIndex = tabController.animation?.value.round() ?? 0;

              return Container(
                height: height.h,
                decoration: BoxDecoration(
                  color: effectiveInactiveColor,
                  borderRadius: BorderRadius.circular(effectiveBorderRadius),
                ),
                child: Stack(
                  children: [
                    // 滑动指示器
                    AnimatedAlign(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      alignment: Alignment(
                        _getAlignment(selectedIndex, tabs.length),
                        0,
                      ),
                      child: FractionallySizedBox(
                        widthFactor: 1 / tabs.length,
                        child: Padding(
                          padding: EdgeInsets.all(2.w),
                          child: Container(
                            height: (height - 4).h,
                            decoration: BoxDecoration(
                              color: effectiveActiveColor,
                              borderRadius: BorderRadius.circular(
                                effectiveBorderRadius - 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: effectiveActiveColor.withValues(
                                    alpha: 0.3,
                                  ),
                                  blurRadius: 4,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Tab 文字
                    Row(
                      children: List.generate(tabs.length, (index) {
                        final isActive = index == selectedIndex;
                        return Expanded(
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              tabController.animateTo(index);
                              onTap?.call(index);
                            },
                            child: Center(
                              child: AnimatedDefaultTextStyle(
                                duration: const Duration(milliseconds: 250),
                                style: TextStyle(
                                  fontSize: fontSize.sp,
                                  fontWeight: isActive
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                  color: isActive
                                      ? effectiveActiveTextColor
                                      : effectiveTextColor,
                                ),
                                child: Text(
                                  tabs[index],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  /// 中文：根据当前输入计算并返回调用方需要的派生值。
  /// English: Computes and returns the derived value required by the caller from the current input.
  double _getAlignment(int index, int total) {
    if (total <= 1) return 0;
    return -1.0 + (2.0 * index / (total - 1));
  }
}

/// 简易 AnimatedBuilder（复用，避免和 skeleton 中冲突）
/// 中文：承载 AnimatedBuilder2 的核心职责，配合当前文件完成对应业务或界面逻辑。
/// English: AnimatedBuilder2 carries its core responsibility and supports the business or UI logic in this file.
class AnimatedBuilder2 extends AnimatedWidget {
  const AnimatedBuilder2({
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
