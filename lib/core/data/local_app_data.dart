// 中文：本文件集中提供本地测试环境的数据，确保 local 环境不依赖服务器。
// English: This file centralizes local-test data so the local environment does not depend on servers.
//
// 中文：dev 和 prod 环境不能使用这里的数据，远程环境内容必须由接口返回。
// English: Dev and prod environments must not use this data; remote content must come from APIs.

import 'package:soys_app/core/constants/app_constants.dart';
import 'package:soys_app/models/app/app_models.dart';
import 'package:soys_app/models/user/user_model.dart';

/// 中文：本地测试数据仓库。
/// English: Local-test data registry.
class LocalAppData {
  LocalAppData._();

  static const localPageUrl = 'asset://assets/html/local_page.html';

  /// 中文：首页本地配置，包含 Banner、功能入口和推荐内容。
  /// English: Local home config containing banners, feature entries, and recommendations.
  static Map<String, List<Map<String, String>>> get homeConfig => {
    'banners': [
      {'title': '本地测试 Banner', 'image': '', 'url': localPageUrl},
      {'title': '离线运营位', 'image': '', 'url': localPageUrl},
      {'title': '本地 H5 预览', 'image': '', 'url': localPageUrl},
    ],
    'entries': [
      {'title': '功能中心', 'icon': 'apps', 'url': localPageUrl},
      {'title': '活动专区', 'icon': 'celebration', 'url': localPageUrl},
      {'title': '帮助中心', 'icon': 'help', 'url': localPageUrl},
      {'title': '在线客服', 'icon': 'support_agent', 'url': localPageUrl},
      {'title': '公告通知', 'icon': 'campaign', 'url': localPageUrl},
      {'title': '关于我们', 'icon': 'info', 'url': localPageUrl},
    ],
    'recommendations': [
      {
        'title': '本地推荐内容 1',
        'description': '该内容来自本地测试数据，不会请求服务器。',
        'url': localPageUrl,
      },
      {
        'title': '本地推荐内容 2',
        'description': '可以在无网络或无后端环境下验证首页布局。',
        'url': localPageUrl,
      },
      {
        'title': '本地推荐内容 3',
        'description': '切换到 dev 或 prod 后推荐内容必须由服务器返回。',
        'url': localPageUrl,
      },
    ],
  };

  /// 中文：本地消息列表。
  /// English: Local message list.
  static List<MessageModel> get messages => List.generate(
    5,
    (index) => MessageModel(
      id: 'local-message-$index',
      title: '本地消息 ${index + 1}',
      content: '这是一条来自本地测试环境的消息，用于离线验证消息列表。',
      type: 'local',
      isRead: index.isEven,
      createTime: DateTime.now()
          .subtract(Duration(hours: index + 1))
          .toIso8601String(),
    ),
  );

  /// 中文：本地测试用户。
  /// English: Local test user.
  static UserModel user({
    String? username,
    String? phone,
    String? email,
    String? nickname,
  }) {
    return UserModel(
      id: 'local-test-user',
      username: username?.isNotEmpty == true
          ? username
          : AppConstants.testAccount,
      nickname: nickname?.isNotEmpty == true ? nickname : '本地测试用户',
      phone: phone,
      email: email,
      avatar: '',
      gender: '保密',
      birthday: '2000-01-01',
      token: 'local-test-token',
      refreshToken: 'local-test-refresh-token',
    );
  }
}
