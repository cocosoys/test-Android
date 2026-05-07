// 中文：本文件定义数据模型和序列化逻辑，负责把接口 JSON 与应用内强类型对象互相转换。
// English: This file defines data models and serialization logic for converting between API JSON and strongly typed app objects.
//
// 中文：本文件的注释统一采用“上中文、下英文”的双语顺序，不能使用 ASCII 转码代替中文。
// English: Comments in this file keep Chinese above English and use real Chinese characters instead of ASCII escapes.

/// 应用信息模型
/// 中文：表示 AppInfoModel 数据结构，并负责接口数据与应用对象之间的转换。
/// English: AppInfoModel represents a data structure and converts between API payloads and app objects.
class AppInfoModel {
  final String? versionName;
  final int? versionCode;
  final String? downloadUrl;
  final String? updateContent;
  final bool? forceUpdate;
  final String? packageName;

  AppInfoModel({
    this.versionName,
    this.versionCode,
    this.downloadUrl,
    this.updateContent,
    this.forceUpdate,
    this.packageName,
  });

  factory AppInfoModel.fromJson(Map<String, dynamic> json) {
    return AppInfoModel(
      versionName: json['versionName'] as String?,
      versionCode: json['versionCode'] as int?,
      downloadUrl: json['downloadUrl'] as String?,
      updateContent: json['updateContent'] as String?,
      forceUpdate: json['forceUpdate'] as bool?,
      packageName: json['packageName'] as String?,
    );
  }

  /// 中文：转换接口或本地数据结构，隔离外部字段格式对页面层的影响。
  /// English: Converts API or local data structures so external field formats stay isolated from the UI layer.
  Map<String, dynamic> toJson() {
    return {
      'versionName': versionName,
      'versionCode': versionCode,
      'downloadUrl': downloadUrl,
      'updateContent': updateContent,
      'forceUpdate': forceUpdate,
      'packageName': packageName,
    };
  }
}

/// 消息模型
/// 中文：表示 MessageModel 数据结构，并负责接口数据与应用对象之间的转换。
/// English: MessageModel represents a data structure and converts between API payloads and app objects.
class MessageModel {
  final String? id;
  final String? title;
  final String? content;
  final String? type;
  final bool? isRead;
  final String? createTime;

  MessageModel({
    this.id,
    this.title,
    this.content,
    this.type,
    this.isRead,
    this.createTime,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id']?.toString(),
      title: json['title'] as String?,
      content: json['content'] as String?,
      type: json['type'] as String?,
      isRead: json['isRead'] as bool?,
      createTime: json['createTime'] as String?,
    );
  }

  /// 中文：转换接口或本地数据结构，隔离外部字段格式对页面层的影响。
  /// English: Converts API or local data structures so external field formats stay isolated from the UI layer.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'type': type,
      'isRead': isRead,
      'createTime': createTime,
    };
  }
}
