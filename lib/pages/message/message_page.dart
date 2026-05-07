// 中文：本文件承载消息页面逻辑，负责消息加载、解析、已读状态和刷新交互。
// English: This file owns the Message page logic for message loading, parsing, read state, and refresh interactions.
//
// 中文：本文件的注释统一采用“上中文、下英文”的双语顺序，不能使用 ASCII 转码代替中文。
// English: Comments in this file keep Chinese above English and use real Chinese characters instead of ASCII escapes.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:soys_app/app/theme/app_theme.dart';
import 'package:soys_app/core/network/http_service.dart';
import 'package:soys_app/models/app/app_models.dart';

/// 中文：管理 MessageController 对应页面或功能的状态、数据加载和用户交互。
/// English: MessageController manages state, data loading, and user interactions for its related page or feature.
class MessageController extends GetxController {
  final HttpService _http = Get.find<HttpService>();

  final _messageList = <MessageModel>[].obs;
  final _isLoading = true.obs;

  List<MessageModel> get messageList => _messageList;
  bool get isLoading => _isLoading.value;

  /// 中文：完成当前对象的初始化流程，确保依赖、监听器或初始数据在使用前准备好。
  /// English: Initializes the current object so dependencies, listeners, or initial data are ready before use.
  @override
  void onInit() {
    super.onInit();
    _loadMessages();
  }

  /// 中文：加载或刷新当前功能所需数据，并在失败时保留可用的兜底状态。
  /// English: Loads or refreshes data required by this feature and keeps usable fallback state when requests fail.
  Future<void> _loadMessages() async {
    _isLoading.value = true;
    final response = await _http.get<List<MessageModel>>(
      '/messages',
      showErrorToast: false,
      fromJson: _parseMessages,
    );

    if (response.isSuccess && response.data != null) {
      _messageList.assignAll(response.data!);
    } else {
      _messageList.assignAll(_defaultMessages);
    }
    _isLoading.value = false;
  }

  /// 中文：转换接口或本地数据结构，隔离外部字段格式对页面层的影响。
  /// English: Converts API or local data structures so external field formats stay isolated from the UI layer.
  List<MessageModel> _parseMessages(dynamic json) {
    final source = json is Map<String, dynamic>
        ? (json['list'] ?? json['records'] ?? json['items'])
        : json;
    if (source is! List) return [];
    return source
        .whereType<Map<String, dynamic>>()
        .map(MessageModel.fromJson)
        .toList();
  }

  List<MessageModel> get _defaultMessages => List.generate(
    10,
    (i) => MessageModel(
      id: '$i',
      title: '系统通知 ${i + 1}',
      content: '这是一条系统通知消息内容，通知编号：${i + 1}',
      type: i % 3 == 0 ? 'system' : 'notification',
      isRead: i > 2,
      createTime: DateTime.now().subtract(Duration(hours: i)).toIso8601String(),
    ),
  );

  /// 中文：更新当前功能状态或持久化数据，并确保界面和本地缓存保持一致。
  /// English: Updates feature state or persisted data while keeping the UI and local cache consistent.
  void markAsRead(int index) {
    if (index < _messageList.length) {
      final item = _messageList[index];
      _messageList[index] = MessageModel(
        id: item.id,
        title: item.title,
        content: item.content,
        type: item.type,
        isRead: true,
        createTime: item.createTime,
      );
    }
  }

  /// 中文：加载或刷新当前功能所需数据，并在失败时保留可用的兜底状态。
  /// English: Loads or refreshes data required by this feature and keeps usable fallback state when requests fail.
  Future<void> onRefresh() async {
    await _loadMessages();
  }
}

/// 中文：构建 MessagePage 对应的页面界面，并把用户操作转交给控制器处理。
/// English: MessagePage builds its page UI and delegates user actions to the controller.
class MessagePage extends GetView<MessageController> {
  const MessagePage({super.key});

  /// 中文：构建当前组件的界面树，并根据响应式状态刷新可见内容。
  /// English: Builds the widget tree for this component and refreshes visible content from reactive state.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('message_center'.tr)),
      body: Obx(() {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.messageList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inbox_outlined,
                  size: 64.sp,
                  color: AppTheme.textHint,
                ),
                SizedBox(height: 16.h),
                Text(
                  'no_data'.tr,
                  style: TextStyle(color: AppTheme.textHint, fontSize: 14.sp),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          itemCount: controller.messageList.length,
          separatorBuilder: (context, index) => Divider(height: 1.h),
          itemBuilder: (context, index) {
            final msg = controller.messageList[index];
            return ListTile(
              leading: Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: (msg.isRead ?? true)
                      ? AppTheme.bgSecondary
                      : AppTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Icon(
                  msg.type == 'system'
                      ? Icons.notifications
                      : Icons.chat_bubble_outline,
                  color: (msg.isRead ?? true)
                      ? AppTheme.textHint
                      : AppTheme.primaryColor,
                  size: 20.sp,
                ),
              ),
              title: Text(
                msg.title ?? '',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: (msg.isRead ?? true)
                      ? FontWeight.normal
                      : FontWeight.w600,
                ),
              ),
              subtitle: Text(
                msg.content ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppTheme.textSecondary,
                ),
              ),
              trailing: Text(
                _formatTime(msg.createTime),
                style: TextStyle(fontSize: 11.sp, color: AppTheme.textHint),
              ),
              onTap: () => controller.markAsRead(index),
            );
          },
        );
      }),
    );
  }

  /// 中文：执行 formatTime 对应的业务步骤，并把内部细节封装在当前模块内。
  /// English: Executes the formatTime business step while keeping internal details encapsulated in this module.
  String _formatTime(String? time) {
    if (time == null) return '';
    try {
      final dt = DateTime.parse(time);
      final now = DateTime.now();
      final diff = now.difference(dt);
      if (diff.inDays == 0) {
        return '${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
      }
      if (diff.inDays == 1) return '昨天';
      if (diff.inDays < 7) return '${diff.inDays}天前';
      return '${dt.month}/${dt.day}';
    } catch (_) {
      return '';
    }
  }
}
