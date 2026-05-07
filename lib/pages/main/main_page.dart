// 中文：本文件承载主框架页面逻辑，负责底部导航、页面容器和当前标签状态同步。
// English: This file owns the main shell logic for bottom navigation, page hosting, and selected-tab synchronization.
//
// 中文：本文件的注释统一采用“上中文、下英文”的双语顺序，不能使用 ASCII 转码代替中文。
// English: Comments in this file keep Chinese above English and use real Chinese characters instead of ASCII escapes.

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:soys_app/app/theme/app_theme.dart';
import 'package:soys_app/pages/home/home_page.dart';
import 'package:soys_app/pages/main/main_controller.dart';
import 'package:soys_app/pages/message/message_page.dart';
import 'package:soys_app/pages/mine/mine_page.dart';

/// 主页 - 底部 Tab 导航
/// 中文：构建 MainPage 对应的页面界面，并把用户操作转交给控制器处理。
/// English: MainPage builds its page UI and delegates user actions to the controller.
class MainPage extends GetView<MainController> {
  const MainPage({super.key});

  /// 中文：构建当前组件的界面树，并根据响应式状态刷新可见内容。
  /// English: Builds the widget tree for this component and refreshes visible content from reactive state.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: controller.pageController,
        onPageChanged: controller.onPageChanged,
        physics: const NeverScrollableScrollPhysics(),
        children: const [HomePage(), MessagePage(), MinePage()],
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.currentIndex,
          onTap: controller.changePage,
          items: controller.bottomNavItems,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppTheme.primaryColor,
          unselectedItemColor: AppTheme.textHint,
          selectedFontSize: 12.sp,
          unselectedFontSize: 12.sp,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
