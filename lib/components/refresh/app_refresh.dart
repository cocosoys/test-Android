// 中文：本文件封装下拉刷新和上拉加载容器，统一列表刷新控制器的使用方式。
// English: This file wraps pull-to-refresh and load-more containers, standardizing refresh controller usage for lists.
//
// 中文：本文件的注释统一采用“上中文、下英文”的双语顺序，不能使用 ASCII 转码代替中文。
// English: Comments in this file keep Chinese above English and use real Chinese characters instead of ASCII escapes.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:easy_refresh/easy_refresh.dart';

import 'package:soys_app/app/theme/app_theme.dart';

/// 下拉刷新 + 上拉加载更多 包装器
/// 中文：承载 AppRefreshWrapper 的核心职责，配合当前文件完成对应业务或界面逻辑。
/// English: AppRefreshWrapper carries its core responsibility and supports the business or UI logic in this file.
class AppRefreshWrapper extends StatelessWidget {
  const AppRefreshWrapper({
    super.key,
    required this.child,
    this.controller,
    this.onRefresh,
    this.onLoad,
    this.header,
    this.footer,
    this.disableRefresh = false,
    this.disableLoad = false,
  });

  /// 子组件（通常为 ScrollView）
  final Widget child;

  /// EasyRefreshController
  final EasyRefreshController? controller;

  /// 下拉刷新回调
  final FutureOr Function()? onRefresh;

  /// 上拉加载回调
  final FutureOr Function()? onLoad;

  /// 自定义 Header
  final Header? header;

  /// 自定义 Footer
  final Footer? footer;

  /// 是否禁用下拉刷新
  final bool disableRefresh;

  /// 是否禁用上拉加载
  final bool disableLoad;

  /// 中文：构建当前组件的界面树，并根据响应式状态刷新可见内容。
  /// English: Builds the widget tree for this component and refreshes visible content from reactive state.
  @override
  Widget build(BuildContext context) {
    return EasyRefresh(
      controller: controller,
      onRefresh: disableRefresh ? null : onRefresh,
      onLoad: disableLoad ? null : onLoad,
      header: header ?? _buildHeader(),
      footer: footer ?? _buildFooter(),
      child: child,
    );
  }

  /// 默认 Header 样式
  Header _buildHeader() {
    return MaterialHeader(
      backgroundColor: AppTheme.bgPrimary,
      color: AppTheme.primaryColor,
      clamping: false,
    );
  }

  /// 默认 Footer 样式
  Footer _buildFooter() {
    return MaterialFooter(
      backgroundColor: AppTheme.bgPrimary,
      color: AppTheme.primaryColor,
    );
  }
}

/// 经典样式的刷新包装器
/// 中文：承载 AppClassicRefreshWrapper 的核心职责，配合当前文件完成对应业务或界面逻辑。
/// English: AppClassicRefreshWrapper carries its core responsibility and supports the business or UI logic in this file.
class AppClassicRefreshWrapper extends StatelessWidget {
  const AppClassicRefreshWrapper({
    super.key,
    required this.child,
    this.controller,
    this.onRefresh,
    this.onLoad,
    this.disableRefresh = false,
    this.disableLoad = false,
  });

  final Widget child;
  final EasyRefreshController? controller;
  final FutureOr Function()? onRefresh;
  final FutureOr Function()? onLoad;
  final bool disableRefresh;
  final bool disableLoad;

  /// 中文：构建当前组件的界面树，并根据响应式状态刷新可见内容。
  /// English: Builds the widget tree for this component and refreshes visible content from reactive state.
  @override
  Widget build(BuildContext context) {
    return EasyRefresh(
      controller: controller,
      onRefresh: disableRefresh ? null : onRefresh,
      onLoad: disableLoad ? null : onLoad,
      header: const ClassicHeader(
        dragText: '下拉刷新',
        armedText: '松开刷新',
        readyText: '正在刷新...',
        processingText: '正在刷新...',
        processedText: '刷新完成',
        noMoreText: '没有更多了',
        failedText: '刷新失败',
        messageText: '最后更新于 %T',
        showMessage: true,
      ),
      footer: const ClassicFooter(
        dragText: '上拉加载',
        armedText: '松开加载',
        readyText: '正在加载...',
        processingText: '正在加载...',
        processedText: '加载完成',
        noMoreText: '没有更多了',
        failedText: '加载失败',
        messageText: '%T 之前更新',
        showMessage: false,
      ),
      child: child,
    );
  }
}

/// 提供简便的刷新控制器创建
/// 中文：管理 AppRefreshController 对应页面或功能的状态、数据加载和用户交互。
/// English: AppRefreshController manages state, data loading, and user interactions for its related page or feature.
class AppRefreshController {
  AppRefreshController._();

  /// 创建一个 EasyRefreshController
  static EasyRefreshController create() {
    return EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: true,
    );
  }

  /// 结束刷新（成功）
  static void finishRefresh(EasyRefreshController controller) {
    controller.finishRefresh(IndicatorResult.success);
  }

  /// 结束刷新（无更多数据）
  static void finishRefreshNoMore(EasyRefreshController controller) {
    controller.finishRefresh(IndicatorResult.noMore);
  }

  /// 结束加载（成功）
  static void finishLoad(EasyRefreshController controller) {
    controller.finishLoad(IndicatorResult.success);
  }

  /// 结束加载（无更多数据）
  static void finishLoadNoMore(EasyRefreshController controller) {
    controller.finishLoad(IndicatorResult.noMore);
  }

  /// 结束加载（失败）
  static void finishLoadFailed(EasyRefreshController controller) {
    controller.finishLoad(IndicatorResult.fail);
  }
}
