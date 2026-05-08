// 中文：本文件承载首页逻辑，负责按当前环境加载首页配置、Banner、功能入口和推荐内容。
// English: This file owns the Home page logic for loading environment-specific home config, banners, feature entries, and recommendations.
//
// 中文：本文件的注释统一采用“上中文、下英文”的双语顺序，不能使用 ASCII 转码代替中文。
// English: Comments in this file keep Chinese above English and use real Chinese characters instead of ASCII escapes.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:soys_app/app/routes/app_routes.dart';
import 'package:soys_app/app/theme/app_theme.dart';
import 'package:soys_app/core/constants/env_config.dart';
import 'package:soys_app/core/data/local_app_data.dart';
import 'package:soys_app/core/network/http_service.dart';

/// 中文：管理 HomeController 对应页面或功能的状态、数据加载和用户交互。
/// English: HomeController manages state, data loading, and user interactions for its related page or feature.
class HomeController extends GetxController {
  final HttpService _http = Get.find<HttpService>();

  final _bannerList = <Map<String, String>>[].obs;
  final _webEntryList = <Map<String, String>>[].obs;
  final _recommendList = <Map<String, String>>[].obs;

  List<Map<String, String>> get bannerList => _bannerList;
  List<Map<String, String>> get webEntryList => _webEntryList;
  List<Map<String, String>> get recommendList => _recommendList;

  /// 中文：完成当前对象的初始化流程，确保依赖、监听器或初始数据在使用前准备好。
  /// English: Initializes the current object so dependencies, listeners, or initial data are ready before use.
  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  /// 中文：加载或刷新当前功能所需数据，并在失败时保留可用的兜底状态。
  /// English: Loads or refreshes data required by this feature and keeps usable fallback state when requests fail.
  Future<void> _loadData() async {
    if (Environments.current.useLocalContent) {
      _applyHomeConfig(LocalAppData.homeConfig);
      return;
    }

    final response = await _http.get<Map<String, List<Map<String, String>>>>(
      '/home/config',
      showErrorToast: true,
      fromJson: _parseHomeConfig,
    );

    if (response.isSuccess && response.data != null) {
      _applyHomeConfig(response.data!);
      return;
    }

    _applyHomeConfig(const {});
  }

  void _applyHomeConfig(Map<String, List<Map<String, String>>> config) {
    _bannerList.assignAll(config['banners'] ?? []);
    _webEntryList.assignAll(config['entries'] ?? []);
    _recommendList.assignAll(config['recommendations'] ?? []);
  }

  Map<String, List<Map<String, String>>> _parseHomeConfig(dynamic json) {
    final data = json as Map<String, dynamic>;
    return {
      'banners': _parseStringMapList(data['banners']),
      'entries': _parseStringMapList(data['entries'] ?? data['webEntries']),
      'recommendations': _parseStringMapList(
        data['recommendations'] ?? data['recommends'] ?? data['items'],
      ),
    };
  }

  List<Map<String, String>> _parseStringMapList(dynamic value) {
    if (value is! List) return [];
    return value
        .whereType<Map>()
        .map(
          (item) => item.map(
            (key, value) => MapEntry(key.toString(), value?.toString() ?? ''),
          ),
        )
        .toList();
  }

  /// 中文：处理导航、桥接或事件分发动作，统一外部交互入口。
  /// English: Handles navigation, bridge, or event-dispatch actions through a single interaction entry point.
  void openWebView(String url, String title) {
    Get.toNamed(
      '${AppRoutes.webview}?title=${Uri.encodeComponent(title)}'
      '&url=${Uri.encodeComponent(url)}',
    );
  }
}

/// 中文：构建 HomePage 对应的页面界面，并把用户操作转交给控制器处理。
/// English: HomePage builds its page UI and delegates user actions to the controller.
class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  /// 中文：构建当前组件的界面树，并根据响应式状态刷新可见内容。
  /// English: Builds the widget tree for this component and refreshes visible content from reactive state.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('tab_home'.tr),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => Get.toNamed(AppRoutes.message),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner
            _buildBanner(),
            SizedBox(height: 20.h),
            // 功能入口
            _buildFeatureGrid(),
            SizedBox(height: 20.h),
            // 推荐内容
            _buildRecommendSection(),
          ],
        ),
      ),
    );
  }

  /// 中文：构建当前页面中的局部 UI 片段，保持主构建方法结构清晰。
  /// English: Builds a focused UI section in the page so the main build method stays readable.
  Widget _buildBanner() {
    return Obx(
      () => SizedBox(
        height: 160.h,
        child: PageView.builder(
          itemCount: controller.bannerList.length,
          itemBuilder: (context, index) {
            final banner = controller.bannerList[index];
            return GestureDetector(
              onTap: () =>
                  controller.openWebView(banner['url']!, banner['title']!),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primaryColor.withValues(alpha: 0.7),
                      AppTheme.primaryColor,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Center(
                  child: Text(
                    banner['title']!,
                    style: TextStyle(color: Colors.white, fontSize: 20.sp),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// 中文：构建当前页面中的局部 UI 片段，保持主构建方法结构清晰。
  /// English: Builds a focused UI section in the page so the main build method stays readable.
  Widget _buildFeatureGrid() {
    return Obx(
      () => GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 16.h,
          crossAxisSpacing: 16.w,
          childAspectRatio: 0.8,
        ),
        itemCount: controller.webEntryList.length,
        itemBuilder: (context, index) {
          final entry = controller.webEntryList[index];
          final iconMap = {
            'apps': Icons.apps,
            'celebration': Icons.celebration,
            'help': Icons.help_outline,
            'support_agent': Icons.support_agent,
            'campaign': Icons.campaign,
            'info': Icons.info_outline,
          };
          return GestureDetector(
            onTap: () => controller.openWebView(entry['url']!, entry['title']!),
            child: Column(
              children: [
                Container(
                  width: 48.w,
                  height: 48.w,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    iconMap[entry['icon']] ?? Icons.web,
                    color: AppTheme.primaryColor,
                    size: 24.sp,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  entry['title']!,
                  style: TextStyle(fontSize: 12.sp),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// 中文：构建当前页面中的局部 UI 片段，保持主构建方法结构清晰。
  /// English: Builds a focused UI section in the page so the main build method stays readable.
  Widget _buildRecommendSection() {
    return Obx(() {
      final recommendations = controller.recommendList;
      if (recommendations.isEmpty) {
        return const SizedBox.shrink();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '推荐',
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 12.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: recommendations.length,
            separatorBuilder: (context, index) => Divider(height: 24.h),
            itemBuilder: (context, index) {
              final item = recommendations[index];
              final title = item['title'] ?? '';
              final description = item['description'] ?? item['subtitle'] ?? '';
              final url = item['url'] ?? LocalAppData.localPageUrl;
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 56.w,
                  height: 56.w,
                  decoration: BoxDecoration(
                    color: AppTheme.bgSecondary,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: const Icon(Icons.article, color: AppTheme.textHint),
                ),
                title: Text(title, style: TextStyle(fontSize: 14.sp)),
                subtitle: Text(
                  description,
                  style: TextStyle(fontSize: 12.sp, color: AppTheme.textHint),
                ),
                trailing: Icon(Icons.arrow_forward_ios, size: 14.sp),
                onTap: () => controller.openWebView(url, title),
              );
            },
          ),
        ],
      );
    });
  }
}
