// 中文：本文件承载主框架页面逻辑，负责底部导航、页面容器和当前标签状态同步。
// English: This file owns the main shell logic for bottom navigation, page hosting, and selected-tab synchronization.
//
// 中文：本文件的注释统一采用“上中文、下英文”的双语顺序，不能使用 ASCII 转码代替中文。
// English: Comments in this file keep Chinese above English and use real Chinese characters instead of ASCII escapes.

import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// 主页控制器
/// 中文：管理 MainController 对应页面或功能的状态、数据加载和用户交互。
/// English: MainController manages state, data loading, and user interactions for its related page or feature.
class MainController extends GetxController {
  final _currentIndex = 0.obs;
  int get currentIndex => _currentIndex.value;

  late PageController pageController;

  final List<BottomNavigationBarItem> bottomNavItems = [
    BottomNavigationBarItem(
      icon: const Icon(Icons.home_outlined),
      activeIcon: const Icon(Icons.home),
      label: 'tab_home'.tr,
    ),
    BottomNavigationBarItem(
      icon: const Icon(Icons.notifications_outlined),
      activeIcon: const Icon(Icons.notifications),
      label: 'tab_message'.tr,
    ),
    BottomNavigationBarItem(
      icon: const Icon(Icons.person_outline),
      activeIcon: const Icon(Icons.person),
      label: 'tab_mine'.tr,
    ),
  ];

  /// 中文：完成当前对象的初始化流程，确保依赖、监听器或初始数据在使用前准备好。
  /// English: Initializes the current object so dependencies, listeners, or initial data are ready before use.
  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: 0);
  }

  /// 中文：释放当前对象持有的控制器、监听器或异步资源，避免页面销毁后继续占用资源。
  /// English: Releases controllers, listeners, or async resources held by this object so they do not outlive the page.
  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  /// 切换 Tab
  /// 中文：更新当前功能状态或持久化数据，并确保界面和本地缓存保持一致。
  /// English: Updates feature state or persisted data while keeping the UI and local cache consistent.
  void changePage(int index) {
    if (index == _currentIndex.value) return;
    _currentIndex.value = index;
    pageController.jumpToPage(index);
  }

  /// PageView 页面切换回调
  /// 中文：执行 onPageChanged 对应的业务步骤，并把内部细节封装在当前模块内。
  /// English: Executes the onPageChanged business step while keeping internal details encapsulated in this module.
  void onPageChanged(int index) {
    _currentIndex.value = index;
  }
}
