// 中文：本文件承载 WebView 页面逻辑，负责 H5 加载、JS 桥、导航控制和缓存处理。
// English: This file owns the WebView page logic for H5 loading, JavaScript bridges, navigation controls, and cache handling.
//
// 中文：本文件的注释统一采用“上中文、下英文”的双语顺序，不能使用 ASCII 转码代替中文。
// English: Comments in this file keep Chinese above English and use real Chinese characters instead of ASCII escapes.

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:webview_flutter/webview_flutter.dart' as wv;

import 'package:soys_app/app/theme/app_theme.dart';
import 'package:soys_app/services/webview/webview_service.dart';

/// App WebView 控制器
/// 中文：管理 AppWebViewController 对应页面或功能的状态、数据加载和用户交互。
/// English: AppWebViewController manages state, data loading, and user interactions for its related page or feature.
class AppWebViewController extends GetxController {
  final WebViewService _webViewService = Get.find<WebViewService>();

  late final wv.WebViewController webController;

  final _title = ''.obs;
  final _progress = 0.obs;
  final _isLoading = true.obs;

  String get title => _title.value;
  int get progress => _progress.value;
  bool get isLoading => _isLoading.value;

  final String initialUrl;
  final String initialTitle;

  AppWebViewController({required this.initialUrl, this.initialTitle = ''});

  /// 中文：完成当前对象的初始化流程，确保依赖、监听器或初始数据在使用前准备好。
  /// English: Initializes the current object so dependencies, listeners, or initial data are ready before use.
  @override
  void onInit() {
    super.onInit();
    _title.value = initialTitle;
    _initWebView();
  }

  /// 中文：执行 initWebView 对应的业务步骤，并把内部细节封装在当前模块内。
  /// English: Executes the initWebView business step while keeping internal details encapsulated in this module.
  void _initWebView() {
    webController = wv.WebViewController()
      ..setJavaScriptMode(wv.JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        wv.NavigationDelegate(
          onProgress: (int progress) {
            _progress.value = progress;
          },
          onPageStarted: (String url) {
            _isLoading.value = true;
          },
          onPageFinished: (String url) async {
            _isLoading.value = false;
            _title.value = await webController.getTitle() ?? initialTitle;
          },
          onWebResourceError: (wv.WebResourceError error) {
            _isLoading.value = false;
          },
        ),
      )
      ..addJavaScriptChannel(
        WebViewService.jsBridgeName,
        onMessageReceived: (wv.JavaScriptMessage message) {
          try {
            final Map<String, dynamic> msg = _parseJson(message.message);
            final name = msg['name'] as String?;
            final data = msg['data'];
            if (name != null) {
              _webViewService.handleMessage(name, data);
            }
          } catch (e) {
            _webViewService.handleMessage(message.message, null);
          }
        },
      )
      ..loadRequest(Uri.parse(initialUrl));

    webController.runJavaScript(_webViewService.getInjectJS());
  }

  /// 中文：转换接口或本地数据结构，隔离外部字段格式对页面层的影响。
  /// English: Converts API or local data structures so external field formats stay isolated from the UI layer.
  Map<String, dynamic> _parseJson(String jsonStr) {
    return Map<String, dynamic>.from(
      const JsonDecoder().convert(jsonStr) as Map,
    );
  }

  /// Flutter调用H5
  /// 中文：处理导航、桥接或事件分发动作，统一外部交互入口。
  /// English: Handles navigation, bridge, or event-dispatch actions through a single interaction entry point.
  Future<void> callJS(String methodName, [dynamic args]) async {
    await _webViewService.callJS(webController, methodName, args);
  }

  /// 返回
  /// 中文：处理导航、桥接或事件分发动作，统一外部交互入口。
  /// English: Handles navigation, bridge, or event-dispatch actions through a single interaction entry point.
  Future<void> goBack() async {
    if (await webController.canGoBack()) {
      webController.goBack();
    } else {
      Get.back();
    }
  }

  /// 前进
  /// 中文：处理导航、桥接或事件分发动作，统一外部交互入口。
  /// English: Handles navigation, bridge, or event-dispatch actions through a single interaction entry point.
  void goForward() {
    webController.goForward();
  }

  /// 刷新
  /// 中文：处理导航、桥接或事件分发动作，统一外部交互入口。
  /// English: Handles navigation, bridge, or event-dispatch actions through a single interaction entry point.
  void reload() {
    webController.reload();
  }
}

/// 中文：构建 WebViewPage 对应的页面界面，并把用户操作转交给控制器处理。
/// English: WebViewPage builds its page UI and delegates user actions to the controller.
class WebViewPage extends GetView<AppWebViewController> {
  const WebViewPage({super.key});

  /// 中文：构建当前组件的界面树，并根据响应式状态刷新可见内容。
  /// English: Builds the widget tree for this component and refreshes visible content from reactive state.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => Text(
            controller.title,
            style: TextStyle(fontSize: 16.sp),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.reload,
          ),
        ],
      ),
      body: Stack(
        children: [
          wv.WebViewWidget(controller: controller.webController),
          Obx(
            () => controller.isLoading
                ? LinearProgressIndicator(
                    value: controller.progress / 100.0,
                    backgroundColor: Colors.transparent,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppTheme.primaryColor,
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
