// 中文：本文件封装图片、头像和图片预览能力，统一占位、错误、圆角和分页指示器逻辑。
// English: This file wraps image, avatar, and preview features, standardizing placeholders, errors, corners, and page indicators.
//
// 中文：本文件的注释统一采用“上中文、下英文”的双语顺序，不能使用 ASCII 转码代替中文。
// English: Comments in this file keep Chinese above English and use real Chinese characters instead of ASCII escapes.

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';

import 'package:soys_app/app/theme/app_theme.dart';

/// 通用网络图片组件
/// 中文：承载 AppImage 的核心职责，配合当前文件完成对应业务或界面逻辑。
/// English: AppImage carries its core responsibility and supports the business or UI logic in this file.
class AppImage extends StatelessWidget {
  const AppImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
    this.color,
    this.colorBlendMode,
    this.cacheWidth,
    this.cacheHeight,
  });

  /// 图片 URL
  final String imageUrl;

  /// 宽度
  final double? width;

  /// 高度
  final double? height;

  /// 填充模式
  final BoxFit fit;

  /// 圆角
  final BorderRadius? borderRadius;

  /// 占位组件
  final Widget? placeholder;

  /// 错误组件
  final Widget? errorWidget;

  /// 颜色滤镜
  final Color? color;

  /// 颜色混合模式
  final BlendMode? colorBlendMode;

  /// 缓存宽度
  final int? cacheWidth;

  /// 缓存高度
  final int? cacheHeight;

  /// 中文：构建当前页面中的局部 UI 片段，保持主构建方法结构清晰。
  /// English: Builds a focused UI section in the page so the main build method stays readable.
  Widget _buildPlaceholder() {
    return placeholder ??
        Container(
          width: width,
          height: height,
          color: AppTheme.bgSecondary,
          child: Center(
            child: Icon(
              Icons.image_outlined,
              size: (width != null ? width! * 0.3 : 24).w,
              color: AppTheme.textDisabled,
            ),
          ),
        );
  }

  /// 中文：构建当前页面中的局部 UI 片段，保持主构建方法结构清晰。
  /// English: Builds a focused UI section in the page so the main build method stays readable.
  Widget _buildErrorWidget() {
    return errorWidget ??
        Container(
          width: width,
          height: height,
          color: AppTheme.bgSecondary,
          child: Center(
            child: Icon(
              Icons.broken_image_outlined,
              size: (width != null ? width! * 0.3 : 24).w,
              color: AppTheme.textHint,
            ),
          ),
        );
  }

  /// 中文：构建当前组件的界面树，并根据响应式状态刷新可见内容。
  /// English: Builds the widget tree for this component and refreshes visible content from reactive state.
  @override
  Widget build(BuildContext context) {
    final image = CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      color: color,
      colorBlendMode: colorBlendMode,
      memCacheWidth: cacheWidth,
      memCacheHeight: cacheHeight,
      placeholder: (context, url) => _buildPlaceholder(),
      errorWidget: (context, url, error) => _buildErrorWidget(),
    );

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: image);
    }

    return image;
  }
}

/// 圆形头像组件
/// 中文：承载 AppAvatar 的核心职责，配合当前文件完成对应业务或界面逻辑。
/// English: AppAvatar carries its core responsibility and supports the business or UI logic in this file.
class AppAvatar extends StatelessWidget {
  const AppAvatar({
    super.key,
    this.imageUrl,
    this.size = 44,
    this.placeholderIcon,
    this.placeholderText,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 0,
  });

  /// 头像 URL
  final String? imageUrl;

  /// 头像大小
  final double size;

  /// 占位图标
  final IconData? placeholderIcon;

  /// 占位文字（取首字）
  final String? placeholderText;

  /// 占位背景色
  final Color? backgroundColor;

  /// 边框颜色
  final Color? borderColor;

  /// 边框宽度
  final double borderWidth;

  /// 中文：构建当前组件的界面树，并根据响应式状态刷新可见内容。
  /// English: Builds the widget tree for this component and refreshes visible content from reactive state.
  @override
  Widget build(BuildContext context) {
    final effectiveBgColor =
        backgroundColor ?? AppTheme.primaryColor.withValues(alpha: 0.1);
    final effectiveBorderColor = borderColor ?? Colors.transparent;

    Widget avatar;

    if (imageUrl != null && imageUrl!.isNotEmpty) {
      avatar = CachedNetworkImage(
        imageUrl: imageUrl!,
        width: size.w,
        height: size.w,
        fit: BoxFit.cover,
        placeholder: (context, url) => _buildPlaceholder(effectiveBgColor),
        errorWidget: (context, url, error) =>
            _buildPlaceholder(effectiveBgColor),
      );
    } else {
      avatar = _buildPlaceholder(effectiveBgColor);
    }

    // 边框
    if (borderWidth > 0) {
      avatar = Container(
        width: size.w + borderWidth * 2,
        height: size.w + borderWidth * 2,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: effectiveBorderColor, width: borderWidth.w),
        ),
        child: ClipOval(child: avatar),
      );
    }

    return ClipOval(child: avatar);
  }

  /// 中文：构建当前页面中的局部 UI 片段，保持主构建方法结构清晰。
  /// English: Builds a focused UI section in the page so the main build method stays readable.
  Widget _buildPlaceholder(Color bgColor) {
    return Container(
      width: size.w,
      height: size.w,
      color: bgColor,
      child: Center(
        child: placeholderText != null && placeholderText!.isNotEmpty
            ? Text(
                placeholderText!.substring(0, 1).toUpperCase(),
                style: TextStyle(
                  fontSize: size * 0.4.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryColor,
                ),
              )
            : Icon(
                placeholderIcon ?? Icons.person,
                size: size * 0.5.w,
                color: AppTheme.primaryColor,
              ),
      ),
    );
  }
}

/// 全屏图片预览
/// 中文：承载 AppImagePreview 的核心职责，配合当前文件完成对应业务或界面逻辑。
/// English: AppImagePreview carries its core responsibility and supports the business or UI logic in this file.
class AppImagePreview extends StatelessWidget {
  const AppImagePreview({
    super.key,
    required this.imageUrls,
    this.initialIndex = 0,
    this.heroTag,
  });

  /// 图片 URL 列表
  final List<String> imageUrls;

  /// 初始索引
  final int initialIndex;

  /// Hero 动画标签
  final String? heroTag;

  /// 中文：构建当前组件的界面树，并根据响应式状态刷新可见内容。
  /// English: Builds the widget tree for this component and refreshes visible content from reactive state.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.white, size: 28.w),
          onPressed: () => Get.back(),
        ),
      ),
      body: PageView.builder(
        itemCount: imageUrls.length,
        controller: PageController(initialPage: initialIndex),
        itemBuilder: (context, index) {
          final imageUrl = imageUrls[index];

          Widget image = InteractiveViewer(
            minScale: 0.5,
            maxScale: 4.0,
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.contain,
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
              errorWidget: (context, url, error) => Center(
                child: Icon(
                  Icons.broken_image_outlined,
                  size: 48.w,
                  color: Colors.white54,
                ),
              ),
            ),
          );

          if (heroTag != null && index == initialIndex) {
            image = Hero(tag: heroTag!, child: image);
          }

          return GestureDetector(
            onTap: () => Get.back(),
            child: Container(color: Colors.black, child: image),
          );
        },
      ),
      bottomNavigationBar: imageUrls.length > 1
          ? Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom + 16.h,
              ),
              child: _ImagePageIndicator(
                count: imageUrls.length,
                initialIndex: initialIndex,
              ),
            )
          : null,
    );
  }

  /// 打开图片预览
  static void open({
    required List<String> imageUrls,
    int initialIndex = 0,
    String? heroTag,
  }) {
    Get.to(
      () => AppImagePreview(
        imageUrls: imageUrls,
        initialIndex: initialIndex,
        heroTag: heroTag,
      ),
      transition: Transition.fadeIn,
      fullscreenDialog: true,
    );
  }
}

/// 中文：承载 ImagePageIndicator 的核心职责，配合当前文件完成对应业务或界面逻辑。
/// English: ImagePageIndicator carries its core responsibility and supports the business or UI logic in this file.
class _ImagePageIndicator extends StatefulWidget {
  const _ImagePageIndicator({required this.count, required this.initialIndex});

  final int count;
  final int initialIndex;

  @override
  State<_ImagePageIndicator> createState() => _ImagePageIndicatorState();
}

/// 中文：承载 ImagePageIndicatorState 的核心职责，配合当前文件完成对应业务或界面逻辑。
/// English: ImagePageIndicatorState carries its core responsibility and supports the business or UI logic in this file.
class _ImagePageIndicatorState extends State<_ImagePageIndicator> {
  late int _currentIndex;

  /// 中文：完成当前对象的初始化流程，确保依赖、监听器或初始数据在使用前准备好。
  /// English: Initializes the current object so dependencies, listeners, or initial data are ready before use.
  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  /// 中文：构建当前组件的界面树，并根据响应式状态刷新可见内容。
  /// English: Builds the widget tree for this component and refreshes visible content from reactive state.
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '${_currentIndex + 1} / ${widget.count}',
        style: TextStyle(fontSize: 16.sp, color: Colors.white70),
      ),
    );
  }
}
